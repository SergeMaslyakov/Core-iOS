import Foundation
import Security

///
/// Acknowledgements:
/// - KeychainSwift
///

public final class KeychainDataStorage: DataStorageProtocol {

    private let keyPrefix: String
    private let accessGroup: String?  /// errSecMissingEntitlement = -34018; errSecInteractionNotAllowed = -25308

    public init(keyPrefix: String, accessGroup: String?) {
        self.keyPrefix = keyPrefix
        self.accessGroup = accessGroup
    }

    // MARK: - Private

    private func toString(_ value: CFString) -> String {
        return value as String
    }

    private func keyWithPrefix(_ key: String) -> String {
        return "\(keyPrefix)\(key)"
    }

    private func addAccessGroupWhenPresent(_ items: inout [String: Any]) {
        guard let accessGroup = accessGroup else { return }

        items[toString(kSecAttrAccessGroup)] = accessGroup
    }

    // MARK: - DataStorageProtocol

    public func setData(_ data: Any?, forKey key: String) throws {

        if let data = data {

            var attr: [String: Any] = [
                toString(kSecClass): kSecClassGenericPassword,
                toString(kSecAttrService): keyWithPrefix(key),
                toString(kSecValueData): data
            ]

            addAccessGroupWhenPresent(&attr)

            let status = SecItemAdd(attr as CFDictionary, nil)

            if status != errSecSuccess && status != errSecDuplicateItem {
                debugPrint("KeychainDataStorage: error during writing data \(status)")
                throw DataStorageError.keychainWriteError(status)
            }

            // update item silently
            if status == errSecDuplicateItem {
                try updateData(data, forKey: key)
            }
        } else {
            try removeData(forKey: keyWithPrefix(key))
        }
    }

    public func updateData(_ data: Any?, forKey key: String) throws {

        if let data = data {

            let changes: [String: Any] = [toString(kSecValueData): data]
            var query: [String: Any] = [
                toString(kSecClass): kSecClassGenericPassword,
                toString(kSecAttrService): keyWithPrefix(key)
            ]

            addAccessGroupWhenPresent(&query)

            let status = SecItemUpdate(query as CFDictionary, changes as CFDictionary)

            if status != errSecSuccess && status != errSecItemNotFound {
                debugPrint("KeychainDataStorage: error during updating data \(status)")
                throw DataStorageError.keychainUpdateError(status)
            }
        } else {
            try removeData(forKey: keyWithPrefix(key))
        }
    }

    public func getData(forKey key: String) throws -> Any? {

        var query: [String: Any] = [
            toString(kSecClass): kSecClassGenericPassword,
            toString(kSecAttrService): keyWithPrefix(key),
            toString(kSecMatchLimit): kSecMatchLimitOne,
            toString(kSecReturnData): kCFBooleanTrue!
        ]

        addAccessGroupWhenPresent(&query)

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess || status == errSecItemNotFound {
            return result
        }

        debugPrint("KeychainDataStorage: error during reading data \(status)")
        throw DataStorageError.keychainReadError(status)
    }

    public func removeData(forKey key: String) throws {
        var query: [String: Any] = [
            toString(kSecClass): kSecClassGenericPassword,
            toString(kSecAttrService): keyWithPrefix(key)
        ]

        addAccessGroupWhenPresent(&query)

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            debugPrint("KeychainDataStorage: error during removing data \(status)")
            throw DataStorageError.keychainDeleteError(status)
        }
    }

    public func removeAll() throws {
        var query: [String: Any] = [
            toString(kSecClass): kSecClassGenericPassword
        ]

        addAccessGroupWhenPresent(&query)

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            debugPrint("KeychainDataStorage: error during wiping out data \(status)")
            throw DataStorageError.keychainDeleteError(status)
        }
    }
}
