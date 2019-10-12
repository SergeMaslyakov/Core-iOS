import Foundation

public final class SyncMemoryCache<KeyType, ObjectType> where KeyType: NSObject, ObjectType: NSObject {

    private let cache: NSCache<KeyType, ObjectType>
    private let syncQueue: DispatchQueue

    public init(label: String) {
        self.cache = NSCache<KeyType, ObjectType>()
        self.syncQueue = DispatchQueue(label: label, qos: .background, attributes: .concurrent)
    }

    public func object(forKey key: KeyType) -> ObjectType? {
        return syncQueue.sync { cache.object(forKey: key) }
    }

    public func setObject(_ obj: ObjectType, forKey key: KeyType) {
        syncQueue.async(flags: .barrier) {
            self.cache.setObject(obj, forKey: key)
        }
    }

    public func removeObject(forKey key: KeyType) {
        syncQueue.async(flags: .barrier) {
            self.cache.removeObject(forKey: key)
        }
    }

    public func invalidate() {
        syncQueue.async(flags: .barrier) {
            self.cache.removeAllObjects()
        }
    }
}
