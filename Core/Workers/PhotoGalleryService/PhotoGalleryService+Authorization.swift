import Photos
import RxCocoa
import RxSwift

public extension PhotoGalleryService {
    func currentPhotoLibraryAuthorizationStatus() -> PHAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            return PHPhotoLibrary.authorizationStatus()
        }
    }

    func requestPhotoLibraryAuthorization() -> Single<Bool> {
        Single.create { [unowned self] single -> Disposable in
            let shouldRequestAuthEvaluator: (PHAuthorizationStatus) -> Bool = { status in
                switch status {
                case .authorized, .limited:
                    single(.success(true))
                case .denied, .restricted:
                    single(.success(false))
                case .notDetermined:
                    return true
                @unknown default:
                    single(.success(false))
                }
                return false
            }

            let requestEvaluator: (PHAuthorizationStatus) -> Void = { status in
                switch status {
                case .authorized, .limited:
                    single(.success(true))
                default:
                    single(.success(false))
                }
            }

            let status = self.currentPhotoLibraryAuthorizationStatus()

            if shouldRequestAuthEvaluator(status) {
                if #available(iOS 14.0, *) {
                    PHPhotoLibrary.requestAuthorization(for: .readWrite) { requestEvaluator($0) }
                } else {
                    PHPhotoLibrary.requestAuthorization { requestEvaluator($0) }
                }
            }

            return Disposables.create()
        }
        .subscribe(on: MainScheduler.asyncInstance)
        .observe(on: MainScheduler.asyncInstance)
    }
}
