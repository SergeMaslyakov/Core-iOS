import Photos
import RxCocoa
import RxSwift

public final class PhotoGalleryService: NSObject {
    public let photoLibrary: PHPhotoLibrary
    public let imageManager: PHImageManager

    public init(photoLibrary: PHPhotoLibrary, imageManager: PHImageManager) {
        self.photoLibrary = photoLibrary
        self.imageManager = imageManager

        super.init()
    }

    public func makePhotosFetchResult(for assetCollection: PHAssetCollection) -> PHFetchResult<PHAsset> {
        let options = PHFetchOptions()

        options.predicate = NSPredicate(format: "%K == %d",
                                        #keyPath(PHAsset.mediaType),
                                        PHAssetMediaType.image.rawValue)
        options.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(PHAsset.creationDate), ascending: false)
        ]
        return PHAsset.fetchAssets(in: assetCollection, options: options)
    }

    public func makeAllPhotosFetchResult() -> PHFetchResult<PHAsset> {
        let options = PHFetchOptions()

        options.predicate = NSPredicate(format: "%K == %d",
                                        #keyPath(PHAsset.mediaType),
                                        PHAssetMediaType.image.rawValue)
        options.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(PHAsset.creationDate), ascending: false)
        ]
        return PHAsset.fetchAssets(with: options)
    }

    public func makeAlbumsFetchResult() -> PHFetchResult<PHAssetCollection> {
        let options = PHFetchOptions()

        options.predicate = NSPredicate(format: "%K > 0",
                                        #keyPath(PHAssetCollection.estimatedAssetCount))
        options.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(PHAssetCollection.endDate), ascending: false)
        ]

        return PHAssetCollection.fetchAssetCollections(with: .album,
                                                       subtype: .any,
                                                       options: options)
    }
}
