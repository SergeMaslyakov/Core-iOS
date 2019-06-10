import Foundation

public enum DataStorageError: Error {
    case dataError
    case pathToFile(String)
    case errorWithUnderlying(Error)

    case keychainWriteError(OSStatus)
    case keychainUpdateError(OSStatus)
    case keychainReadError(OSStatus)
    case keychainDeleteError(OSStatus)
}
