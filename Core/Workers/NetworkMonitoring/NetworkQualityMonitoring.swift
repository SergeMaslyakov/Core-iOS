import Foundation
import CoreTelephony

import RxCocoa
import RxSwift

final public class NetworkQualityMonitoring {

    private let disposeBag = DisposeBag()
    private var notificationToken: NotificationToken?

    private let serialQueue: DispatchQueue
    private let telephonyInfo: CTTelephonyNetworkInfo
    private let reachabilityService: NetworkReachabilityService

    private let radioTechnology = BehaviorRelay<RadioTechnologyType>(value: .unknown)
    private let quality = BehaviorRelay<NetworkQualityType>(value: .unknown)

    private let logger: Logger

    public init?(logger: Logger) {
        self.serialQueue = DispatchQueue(label: "network-monitoring-service.serial", qos: .default, target: nil)
        self.telephonyInfo = CTTelephonyNetworkInfo()
        self.logger = logger

        do {
            self.reachabilityService = try NetworkReachabilityService(serialQueue: self.serialQueue)
        } catch {
            logger.error(error.localizedDescription)
            return nil
        }

        self.networkQuality = quality.asObservable().share(replay: 1, scope: .forever)

        Observable
            .combineLatest(radioTechnology, reachabilityService.reachabilityStatus)
            .skip(1)
            .map { NetworkQualityType.make(fromRadio: $0, andReachability: $1) }
            .asDriver(onErrorJustReturn: .unknown)
            .drive(quality)
            .disposed(by: disposeBag)
    }

    // MARK: - Public

    public let networkQuality: Observable<NetworkQualityType>

    public func start() {

        if #available(iOS 12.1, *) {
            notificationToken = NotificationCenter.default.observe(name: .CTServiceRadioAccessTechnologyDidChange) { [weak self] _ in
                self?.serialQueue.async {
                    self?.radioAccessTechnologyDidChange_ios12()
                }
            }
        } else if #available(iOS 12.0, *) {
            /// https://openradar.appspot.com/46873673
            /// App crashes while reading CTTelephonyNetworkInfo.serviceCurrentRadioAccessTechnology - iOS 12.0 only
            logger.info("Skip subscribing for .CTServiceRadioAccessTechnologyDidChange")
        } else {
            notificationToken = NotificationCenter.default.observe(name: .CTRadioAccessTechnologyDidChange) { [weak self] _ in
                self?.serialQueue.async {
                    self?.radioAccessTechnologyDidChange()
                }
            }
        }

        try? reachabilityService.start()
    }

    public func stop() {
        notificationToken = nil
        reachabilityService.stop()
    }
}

private extension NetworkQualityMonitoring {

    @available(iOS 12, *)
    func radioAccessTechnologyDidChange_ios12() {
        let values = telephonyInfo.serviceCurrentRadioAccessTechnology?.values.map { RadioTechnologyType.make(from: $0) }
        let value = values?.first(where: { $0 != .unknown }) ?? .unknown

        radioTechnology.accept(value)
    }

    func radioAccessTechnologyDidChange() {
        let value = RadioTechnologyType.make(from: telephonyInfo.currentRadioAccessTechnology ?? "")

        radioTechnology.accept(value)
    }

}
