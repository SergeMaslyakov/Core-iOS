import Foundation
import RxSwift

public enum QRCodeUtils {

    public static func generateQRCode(for message: String) -> Observable<UIImage> {

        return Observable.create { observer -> Disposable in

            if let filter = CIFilter(name: "CIQRCodeGenerator") {
                let data = String(message).data(using: .ascii)

                filter.setValue(data, forKey: "inputMessage")
                let transform = CGAffineTransform(scaleX: 10, y: 10)

                if let output = filter.outputImage?.transformed(by: transform) {
                    observer.onNext(UIImage(ciImage: output))
                    observer.onCompleted()
                } else {
                    observer.onError(AppError.cantCreateQRCode)
                }
            } else {
                observer.onError(AppError.cantCreateQRCode)
            }

            return Disposables.create()
        }
    }
}
