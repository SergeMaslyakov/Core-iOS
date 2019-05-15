import Foundation

public struct AppStoreLookupEndpoint: EndpointDescriptor {

    private let bundleId: String

    public init(bundleId: String) {
        self.bundleId = bundleId
    }

    // MARK: - EndpointDescriptor

    public let path: String = "/lookup"
    public let method: HTTPMethod = .get
    public let keyPath: String? = "results"

    public var overriddenBaseURL: URL? {
        return URL(string: "https://itunes.apple.com")
    }

    public var queries: URLQueries {
        return [
            "bundleId": bundleId
        ]
    }

    public var authRequired: Bool {
        return false
    }
}
