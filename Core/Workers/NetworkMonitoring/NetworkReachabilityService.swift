/// Partialy copyright: https://github.com/ashleymills/Reachability.swift

import Foundation
import SystemConfiguration

import RxCocoa
import RxSwift

public final class NetworkReachabilityService {
    private let serialQueue: DispatchQueue
    private let reachability: SCNetworkReachability
    private var isStarted = false

    public init(serialQueue: DispatchQueue) throws {
        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zeroAddress.sa_family = sa_family_t(AF_INET)

        guard let reference = SCNetworkReachabilityCreateWithAddress(nil, &zeroAddress) else {
            throw AppError.reachabilityUnavailable
        }

        self.serialQueue = serialQueue
        self.reachability = reference
        self.reachabilityStatus = BehaviorRelay(value: .unknown)
    }

    // MARK: - Public

    public let reachabilityStatus: BehaviorRelay<ReachabilityStatus>

    public func start() throws {
        guard !isStarted else { return }

        let callback: SCNetworkReachabilityCallBack = { _, flags, info in
            guard let info = info else { return }

            let reachability = Unmanaged<NetworkReachabilityService>.fromOpaque(info).takeUnretainedValue()
            reachability.reachabilityChanged(flags)
        }

        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = UnsafeMutableRawPointer(Unmanaged<NetworkReachabilityService>.passUnretained(self).toOpaque())

        if !SCNetworkReachabilitySetCallback(reachability, callback, &context) {
            throw AppError.reachabilityUnavailable
        }

        if !SCNetworkReachabilitySetDispatchQueue(reachability, serialQueue) {
            throw AppError.reachabilityUnavailable
        }

        try serialQueue.sync { [unowned self] in
            var flags = SCNetworkReachabilityFlags()
            if !SCNetworkReachabilityGetFlags(reachability, &flags) {
                throw AppError.reachabilityUnavailable
            }

            self.reachabilityChanged(flags)
        }

        isStarted = true
    }

    public func stop() {
        defer { isStarted = false }

        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
    }
}

private extension NetworkReachabilityService {
    func reachabilityChanged(_ flags: SCNetworkReachabilityFlags) {
        #if targetEnvironment(simulator)
            reachabilityStatus.accept(.wifi)
        #else
            reachabilityStatus.accept(ReachabilityStatus.make(from: flags))
        #endif
    }
}
