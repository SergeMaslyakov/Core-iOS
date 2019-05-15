import Foundation
import RxSwift

public typealias ConcurrentRxScheduler = ConcurrentDispatchQueueScheduler

public extension ConcurrentDispatchQueueScheduler {

    static var sharedBackground: ConcurrentDispatchQueueScheduler = {
        return makeConcurrentBackgroundScheduler("\(AppBundle.bundleIdentifier).background.shared.concurrent.scheduler")
    }()

    static func makeConcurrentBackgroundScheduler(_ label: String = UUID().uuidString) -> ConcurrentDispatchQueueScheduler {
        return ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: label,
                                                                     qos: .background,
                                                                     attributes: .concurrent))
    }

}
