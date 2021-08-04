import Foundation
import RxSwift

public typealias SerialRxScheduler = SerialDispatchQueueScheduler

public extension SerialDispatchQueueScheduler {
    static var sharedBackground: SerialDispatchQueueScheduler = {
        makeSerialBackgroundScheduler("\(AppBundle.bundleIdentifier).background.shared.serial.scheduler")
    }()

    static func makeSerialBackgroundScheduler(_ label: String) -> SerialDispatchQueueScheduler {
        SerialDispatchQueueScheduler(internalSerialQueueName: label)
    }
}
