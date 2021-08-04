import RxSwift

public typealias ConcurrentRxScheduler = ConcurrentDispatchQueueScheduler

public extension ConcurrentDispatchQueueScheduler {
    static func makeConcurrentBackgroundScheduler(_ label: String = UUID().uuidString) -> ConcurrentDispatchQueueScheduler {
        ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: label,
                                                              qos: .background,
                                                              attributes: .concurrent,
                                                              autoreleaseFrequency: .inherit,
                                                              target: .global(qos: .background)))
    }
}
