import Foundation

/// Simple encoder (it's not suitable for big images and videos)
public final class MultipartFormEncoder: NetworkRequestEncoding {

    private enum EncodingCharacters {
        static let crlf = "\r\n"
        static let crlfcrlf = "\r\n\r\n"
    }

    private enum BoundaryType {
        case initial, final
    }

    private let dataKey: String
    private let boundaryToken: String

    public init(boundaryToken: String, dataKey: String) {
        self.boundaryToken = boundaryToken
        self.dataKey = dataKey
    }

    public func encode(params: [String: Any]) throws -> Data {
        guard let data = params[dataKey] as? MultipartData else { throw CodingError.missingData }

        var mutableParams = params
        mutableParams.removeValue(forKey: dataKey)

        return createMultipartBody(fromMultipartData: data, params: mutableParams)
    }

    private func createMultipartBody(fromMultipartData data: MultipartData, params: [String: Any]) -> Data {
        var multipartData = Data()

        /// params
        params.forEach { (key: String, value: Any) in

            let data = "\(value)".data(using: .utf8) ?? Data()

            multipartData.append(boundaryData(forBoundaryType: .initial, boundary: boundaryToken))

            multipartData.append("Content-Disposition: form-data; name=\"\(key)\"\(EncodingCharacters.crlf)".data(using: .utf8) ?? Data())
            multipartData.append("Content-Length: \(data.count)\(EncodingCharacters.crlfcrlf)".data(using: .utf8) ?? Data())
            multipartData.append(data)
            multipartData.append("\(EncodingCharacters.crlf)".data(using: .utf8) ?? Data())
        }

        /// binary data
        multipartData.append(boundaryData(forBoundaryType: .initial, boundary: boundaryToken))
        let contentDisposition = "Content-Disposition: form-data; name=\"file\"; filename=\"\(data.filename)\"\(EncodingCharacters.crlf)"

        multipartData.append(contentDisposition.data(using: .utf8) ?? Data())
        multipartData.append("Content-Length: \(data.data.count)\(EncodingCharacters.crlf)".data(using: .utf8) ?? Data())
        multipartData.append("Content-Type: \(data.mimeType)\(EncodingCharacters.crlfcrlf)".data(using: .utf8) ?? Data())
        multipartData.append(data.data)
        multipartData.append("\(EncodingCharacters.crlf)".data(using: .utf8) ?? Data())

        /// final
        multipartData.append(boundaryData(forBoundaryType: .final, boundary: boundaryToken))

        return multipartData
    }

    private func boundaryData(forBoundaryType type: BoundaryType, boundary: String) -> Data {
        let boundaryText: String

        switch type {
        case .initial:
            boundaryText = "--\(boundary)\(EncodingCharacters.crlf)"
        case .final:
            boundaryText = "--\(boundary)--\(EncodingCharacters.crlf)"
        }

        return boundaryText.data(using: .utf8, allowLossyConversion: false) ?? Data()
    }
}
