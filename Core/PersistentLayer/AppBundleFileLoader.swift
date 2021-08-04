import Foundation

public enum AppBundleResourceLoader {
    public static func readFile(path: String,
                                extension ext: String,
                                subdirectory: String? = nil,
                                bundle: Bundle = .main) throws -> Data {
        guard let url = bundle.url(forResource: path, withExtension: ext, subdirectory: subdirectory) else {
            let errorPath = "\(bundle.bundlePath)/\(subdirectory ?? "/")\(path).\(ext)"
            throw DataStorageError.pathToFile(errorPath)
        }

        do {
            return try Data(contentsOf: url)
        } catch {
            throw DataStorageError.errorWithUnderlying(error)
        }
    }
}
