import Foundation

public final class SmsCodesManager {

    public typealias Phone = String

    private var storage: [Phone: TimeInterval] = [:]
    private let resendTimeout: TimeInterval
    private let accessQueue: DispatchQueue

    public init(resendTimeout: TimeInterval) {
        self.resendTimeout = resendTimeout
        self.accessQueue = DispatchQueue(label: "sms-codes-manager.access-queue", qos: .background, attributes: .concurrent)
    }

    public func setTimestamp(forPhone phone: Phone) {
        accessQueue.async(flags: .barrier) {
            self.storage[phone] = Date().timeIntervalSince1970
        }
    }

    public func remainingCoolDown(forPhone phone: Phone) -> Int {
        return accessQueue.sync {
            let ts = storage[phone] ?? 0
            let elapsedTime = Date().timeIntervalSince1970 - ts
            return Int(max(0, resendTimeout - elapsedTime))
        }
    }
}
