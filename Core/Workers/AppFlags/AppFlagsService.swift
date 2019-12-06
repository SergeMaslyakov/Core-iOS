import Foundation

public protocol AppFlagsService: class {

    typealias FirstLaunchData = (isFirstLaunch: Bool, firstLaunchDate: Date?)
    typealias NewVersionData = (initialVersion: String, newVersion: String)

    func retreiveFirstLaunchDate() throws -> Date?
    func retreiveInitialVersion() throws -> String
    func retreiveCurrentVersion() throws -> String

    func processAppUpdateIfNeeded(handler: ((NewVersionData) -> Void)?) throws
    func processFirstLaunchIfNeeded(handler: ((FirstLaunchData) -> Void)?) throws
}
