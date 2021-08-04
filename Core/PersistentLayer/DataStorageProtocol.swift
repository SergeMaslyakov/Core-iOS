import Foundation

public protocol DataStorageProtocol {
    func setData(_ data: Any?, forKey key: String) throws
    func updateData(_ data: Any?, forKey key: String) throws
    func getData(forKey key: String) throws -> Any?
    func removeData(forKey key: String) throws
    func removeAll() throws
}
