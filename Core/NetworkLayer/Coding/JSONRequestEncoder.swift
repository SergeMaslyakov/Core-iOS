import Foundation

public final class JSONRequestEncoder: NetworkRequestEncoding {

    public init() {}

    public func encode(params: [String: Any]) throws -> (data: Data, contentLength: Int) {
        let data = try JSONSerialization.data(withJSONObject: params, options: [])
        return (data, data.count)
    }

}
