import Foundation

///
/// Acknowledgements:
/// - Max Sokolov - https://github.com/maxsokolov/Kee/
///

public final class UserDefaultsDataStorage: DataStorageProtocol {
    private let defaults: UserDefaults
    private let suiteName: String?
    private let keyPrefix: String

    public init(keyPrefix: String, suiteName: String? = nil) {
        self.keyPrefix = keyPrefix
        self.suiteName = suiteName

        if let suiteName = suiteName {
            self.defaults = UserDefaults(suiteName: keyPrefix + suiteName) ?? .standard
        } else {
            self.defaults = UserDefaults.standard
        }
    }

    // MARK: - Private

    private func keyWithPrefix(_ key: String) -> String {
        "\(keyPrefix)\(key)"
    }

    // MARK: - DataStorageProtocol

    public func setData(_ data: Any?, forKey key: String) throws {
        if let data = data {
            defaults.set(data, forKey: keyWithPrefix(key))
        } else {
            try removeData(forKey: keyWithPrefix(key))
        }
    }

    public func updateData(_ data: Any?, forKey key: String) throws {
        try setData(data, forKey: keyWithPrefix(key))
    }

    public func getData(forKey key: String) throws -> Any? {
        guard let object = defaults.object(forKey: keyWithPrefix(key)) else { return nil }

        return object
    }

    public func removeData(forKey key: String) throws {
        defaults.set(nil, forKey: keyWithPrefix(key))
        // defaults.removeObject(forKey: keyWithPrefix(key))
    }

    public func removeAll() throws {
        if let suiteName = suiteName {
            defaults.removeSuite(named: suiteName)
        } else {
            UserDefaults.resetStandardUserDefaults()
        }
    }
}
