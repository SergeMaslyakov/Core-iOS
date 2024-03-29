import Nuke
import RxSwift

#if !os(macOS)
    import UIKit
#else
    import AppKit
#endif

extension ImagePipeline: ReactiveCompatible { }

public extension Reactive where Base: ImagePipeline {
    /// Loads an image with a given url. Emits the value synchronously if the
    /// image was found in memory cache.
    func loadImage(with url: URL) -> Single<ImageResponse> {
        loadImage(with: ImageRequest(url: url))
    }

    /// Loads an image with a given request. Emits the value synchronously if the
    /// image was found in memory cache.
    func loadImage(with request: ImageRequest) -> Single<ImageResponse> {
        Single<ImageResponse>.create { single in
            if let image = self.base.cache[request] {
                single(.success(ImageResponse(container: image))) // return synchronously
                return Disposables.create() // nop
            } else {
                let task = self.base.loadImage(with: request, completion: { result in
                    switch result {
                    case let .success(response):
                        single(.success(response))
                    case let .failure(error):
                        single(.failure(error))
                    }
                })
                return Disposables.create { task.cancel() }
            }
        }
    }
}
