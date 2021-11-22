import CoreTelephony
import Foundation

import RxCocoa
import RxSwift

public final class NetworkQualityMonitoring: NSObject {
    private let disposeBag = DisposeBag()

    private let serialQueue: DispatchQueue
    private let telephonyInfo: CTTelephonyNetworkInfo
    private let reachabilityService: NetworkReachabilityService

    private let radioRelay: BehaviorRelay<RadioTechnologyType>
    private let qualityRelay: BehaviorRelay<NetworkQualityType>

    private let logger: AppLoggerProtocol

    public init?(logger: AppLoggerProtocol) {
        self.serialQueue = DispatchQueue(label: "network-monitoring-service.serial", qos: .userInitiated)
        self.telephonyInfo = CTTelephonyNetworkInfo()
        self.logger = logger

        do {
            self.reachabilityService = try NetworkReachabilityService(serialQueue: serialQueue)
        } catch {
            logger.error(error.localizedDescription)
            return nil
        }

        let values = telephonyInfo.serviceCurrentRadioAccessTechnology?.values.map { RadioTechnologyType.make(from: $0) }
        let value = values?.first(where: { $0 != .unknown }) ?? .unknown

        self.radioRelay = BehaviorRelay<RadioTechnologyType>(value: value)
        self.qualityRelay = BehaviorRelay<NetworkQualityType>(value: .unknown(.unknown))
        self.networkQuality = qualityRelay.asObservable().share(replay: 1, scope: .forever)

        super.init()

        Observable
            .combineLatest(radioRelay, reachabilityService.reachabilityStatus)
            .skip(1)
            .map { NetworkQualityType.make(fromRadio: $0, andReachability: $1) }
            .asDriver(onErrorJustReturn: .unknown(.unknown))
            .drive(qualityRelay)
            .disposed(by: disposeBag)
    }

    // MARK: - Public

    public let networkQuality: Observable<NetworkQualityType>

    public func start() {
        telephonyInfo.delegate = self
        try? reachabilityService.start()
    }

    public func stop() {
        telephonyInfo.delegate = nil
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
