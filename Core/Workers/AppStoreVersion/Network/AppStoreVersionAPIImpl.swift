import Foundation
import RxSwift

final public class AppStoreVersionAPIImpl: AppStoreVersionAPI {

    private let networkClient: NetworkClient

    public init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    private func appStoreVersionRequest() -> Observable<[AppStoreVersionModel]> {
        let endpoint = AppStoreLookupEndpoint(bundleId: AppBundle.bundleIdentifier)

        return networkClient.sendGenericRequest(endpoint: endpoint)
    }

    // MARK: - AppStoreVersionAPI

    public func appStoreVersion() -> Observable<AppStoreVersionModel> {
        return appStoreVersionRequest().map { $0.first ?? AppStoreVersionModel.makeZeroVersion() }
    }
}
