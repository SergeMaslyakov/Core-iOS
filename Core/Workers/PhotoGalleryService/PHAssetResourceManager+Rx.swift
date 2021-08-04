import Photos
import RxCocoa
import RxSwift

public extension PHAssetResourceManager {
    func requestAssetResource(_ resource: PHAssetResource,
                              options: PHAssetResourceRequestOptions? = nil) -> Single<Data> {
        Single.create { [unowned self] single -> Disposable in
            let id = self.requestData(for: resource,
                                      options: options,
                                      dataReceivedHandler: { data in
                                          single(.success(data))
                                      },
                                      completionHandler: { error in
                                          guard let error = error else { return }
                                          single(.failure(error))
                                      })
            return Disposables.create {
                self.cancelDataRequest(id)
            }
        }
        .observe(on: MainScheduler.asyncInstance)
    }
}
