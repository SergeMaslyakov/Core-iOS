import UIKit
import MobileCoreServices
import Photos
import RxSwift

public extension PHAsset {
    var isGifImage: Bool {
        if let identifier = self.value(forKey: "uniformTypeIdentifier") as? String {
            if identifier == kUTTypeGIF as String {
                return true
            }
        }
        return false
    }
}

public extension Reactive where Base: PHAsset {

    var image: Observable<UIImage> {
        let base = self.base
        return Observable.create { [weak base] (observer) -> Disposable in
            guard let self = base, self.mediaType == .image else {
                observer.onError(AppError.unexpected)
                return Disposables.create()
            }

            let options = PHImageRequestOptions()
            options.resizeMode = .exact
            options.isNetworkAccessAllowed = true
            options.isSynchronous = true

            PHImageManager.default()
                .requestImage(for: self,
                              targetSize: PHImageManagerMaximumSize,
                              contentMode: .aspectFill,
                              options: options,
                              resultHandler: { image, _ in
                                guard let image = image else {
                                    observer.onError(AppError.unexpected)
                                    return
                                }
                                observer.onNext(image)
                                observer.onCompleted()
                })
            return Disposables.create()
        }
    }

    var path: Observable<String> {
        return Observable.create { [weak base = self.base] (observer) -> Disposable in
            guard let self = base else {
                observer.onError(AppError.unexpected)
                return Disposables.create()
            }

            if self.mediaType == .image {
                let options = PHContentEditingInputRequestOptions()

                options.isNetworkAccessAllowed = true
                options.canHandleAdjustmentData = { (_: PHAdjustmentData) -> Bool in
                    true
                }
                self.requestContentEditingInput(with: options, completionHandler: { contentEditingInput, _ in
                    guard let path = contentEditingInput?.fullSizeImageURL?.path else {
                        observer.onError(AppError.unexpected)
                        return
                    }

                    observer.onNext(path)
                    observer.onCompleted()
                })
            } else if self.mediaType == .video {
                let options = PHVideoRequestOptions()
                options.version = .original
                options.isNetworkAccessAllowed = true

                PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: { (asset, _, param) -> Void in
                    DispatchQueue.main.async {
                        guard asset != nil else {
                            if let error = param?[PHImageErrorKey] as? NSError {
                                observer.onError(error)
                            } else {
                                observer.onError(AppError.unexpected)
                            }
                            return
                        }

                        if asset is AVComposition {
                            observer.onError(AppError.cantExportAssets)
                            return
                        }

                        guard let urlAsset = asset as? AVURLAsset else {
                            observer.onError(AppError.cantExportAssets)
                            return
                        }

                        observer.onNext(urlAsset.url.path)
                        observer.onCompleted()
                    }
                })
            }

            return Disposables.create()
        }
    }
}
