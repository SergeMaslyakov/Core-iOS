import Foundation

public protocol AppFlagsService: class {

    var firstLaunchDate: Date? { get }

    var initialVersion: String { get }

    var currentVersion: String { get }

    var onboardingWasFinished: Bool { get set }

    func processAppUpdateIfNeeded(handler: ((String, String) -> Void)?)

    func processFirstLaunchIfNeeded(handler: ((Bool, Date?) -> Void)?)
}
