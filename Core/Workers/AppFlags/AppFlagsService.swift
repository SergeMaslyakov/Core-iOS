import Foundation

public protocol AppFlagsService: class {

    typealias FirstLaunchData = (isFirstLaunch: Bool, firstLaunchDate: Date?)
    typealias NewVersionData = (initialVersion: String, newVersion: String)

    var firstLaunchDate: Date? { get }
    var initialVersion: String { get }
    var currentVersion: String { get }

    func processAppUpdateIfNeeded(handler: ((NewVersionData) -> Void)?)
    func processFirstLaunchIfNeeded(handler: ((FirstLaunchData) -> Void)?)
}
