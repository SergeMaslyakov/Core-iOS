import Photos
import RxCocoa
import RxSwift

public extension PHImageManager {
    func requestAssetImage(_ asset: PHAsset,
                           targetSize: CGSize = PHImageManagerMaximumSize,
                           contentMode: PHImageContentMode = .default,
                           options: PHImageRequestOptions? = nil) -> Single<UIImage> {
        Single.create { [unowned self] single -> Disposable in
            let id = self.requestImage(for: asset,
                                       targetSize: targetSize,
                                       contentMode: contentMode,
                                       options: options) { image, _ in
                if let image = image {
                    single(.success(image))
                } else {
                    let error = NSError(domain: "",
                                        code: -1,
                                        userInfo: nil)
                    single(.failure(error))
                }
            }

            return Disposables.create {
                self.cancelImageRequest(id)
            }
        }
        .observe(on: MainScheduler.asyncInstance)
    }

    func requestAssetResource(_ asset: PHAsset,
                              options: PHImageRequestOptions? = nil) -> Single<Data> {
        Single.create { [unowned self] single -> Disposable in
            let id = self.requestImageDataAndOrientation(for: asset,
                                                         options: options) { data, _, _, _ in
                if let data = data {
                    single(.success(data))
                } else {
                    let error = NSError(domain: "",
                                        code: -1,
                                        userInfo: nil)
                    single(.failure(error))
                }
            }

            return Disposables.create {
                self.cancelImageRequest(id)
            }
        }
        .observe(on: MainScheduler.asyncInstance)
    }
}
