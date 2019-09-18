import Foundation
import CoreTelephony

import RxCocoa
import RxSwift

final public class NetworkQualityMonitoring: NSObject {

    private let disposeBag = DisposeBag()

    private let serialQueue: DispatchQueue
    private let telephonyInfo: CTTelephonyNetworkInfo
    private let reachabilityService: NetworkReachabilityService

    private let radioRelay: BehaviorRelay<RadioTechnologyType>
    private let qualityRelay: BehaviorRelay<NetworkQualityType>

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

        if #available(iOS 12.0, *) {
            let values = telephonyInfo.serviceCurrentRadioAccessTechnology?.values.map { RadioTechnologyType.make(from: $0) }
            let value = values?.first(where: { $0 != .unknown }) ?? .unknown
            self.radioRelay = BehaviorRelay<RadioTechnologyType>(value: value)
        } else {
            let value = RadioTechnologyType.make(from: telephonyInfo.currentRadioAccessTechnology ?? "")
            self.radioRelay = BehaviorRelay<RadioTechnologyType>(value: value)
        }

        self.qualityRelay = BehaviorRelay<NetworkQualityType>(value: .unknown)
        self.networkQuality = qualityRelay.asObservable().share(replay: 1, scope: .forever)

        super.init()

        Observable
            .combineLatest(radioRelay, reachabilityService.reachabilityStatus)
            .skip(1)
            .map { NetworkQualityType.make(fromRadio: $0, andReachability: $1) }
            .asDriver(onErrorJustReturn: .unknown)
            .drive(qualityRelay)
            .disposed(by: disposeBag)
    }

    // MARK: - Public

    public let networkQuality: Observable<NetworkQualityType>

    public func start() {

        if #available(iOS 13.0, *) {
            telephonyInfo.delegate = self
        } else if #available(iOS 12.0, *) {
            telephonyInfo.serviceSubscriberCellularProvidersDidUpdateNotifier = { [unowned self] identifier in
                self.serialQueue.async {
                    let value = RadioTechnologyType.make(from: identifier)
                    self.radioRelay.accept(value)
                }
            }
        } else {
            telephonyInfo.subscriberCellularProviderDidUpdateNotifier = { [unowned self] carrier in
                self.serialQueue.async {
                    let value = RadioTechnologyType.make(from: self.telephonyInfo.currentRadioAccessTechnology ?? "")
                    self.radioRelay.accept(value)
                }
            }
        }

        try? reachabilityService.start()
    }

    public func stop() {
        if #available(iOS 13.0, *) {
            telephonyInfo.delegate = nil
        } else if #available(iOS 12.0, *) {
            telephonyInfo.serviceSubscriberCellularProvidersDidUpdateNotifier = nil
        } else {
            telephonyInfo.subscriberCellularProviderDidUpdateNotifier = nil
        }
        reachabilityService.stop()
    }

}

extension NetworkQualityMonitoring: CTTelephonyNetworkInfoDelegate {

    public func dataServiceIdentifierDidChange(_ identifier: String) {
        serialQueue.async {
            let value = RadioTechnologyType.make(from: identifier)
            self.radioRelay.accept(value)
        }
    }

}
