import Foundation

/// Simple encoder (it's not suitable for big images and videos)
public final class MultipartFormEncoder: NetworkRequestEncoding {

    private enum EncodingCharacters {
        static let crlf = "\r\n"
    }

    private enum BoundaryType {
        case initial, encapsulated, final
    }

    private let dataKey: String
    private let boundaryToken: String

    public init(boundaryToken: String, dataKey: String) {
        self.boundaryToken = boundaryToken
        self.dataKey = dataKey
    }

    public func encode(params: [String: Any]) throws -> (data: Data, contentLength: Int) {
        guard let data = params[dataKey] as? MultipartData else { throw CodingError.missingData }

        var mutableParams = params
        mutableParams.removeValue(forKey: dataKey)

        let body = createMultipartBody(fromMultipartData: data, params: mutableParams)
        return (body, data.data.count)
    }

    private func createMultipartBody(fromMultipartData data: MultipartData, params: [String: Any]) -> Data {
        var multipartData = Data()

        /// initial
        multipartData.append(boundaryData(forBoundaryType: .initial, boundary: boundaryToken))

        /// binary data
        let contentDisposition = "Content-Disposition: form-data; name=\"file\"; filename=\"\(data.filename)\"\r\n"

        multipartData.append(contentDisposition.data(using: .utf8) ?? Data())
        multipartData.append("Content-Type: \(data.mimetype)\r\n\r\n".data(using: .utf8) ?? Data())
        multipartData.append(data.data)
        multipartData.append("\r\n".data(using: .utf8) ?? Data())

        /// params
        params.forEach { (key: String, value: Any) in

            let contentDisposition = "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"

            multipartData.append(boundaryData(forBoundaryType: .encapsulated, boundary: boundaryToken))
            multipartData.append(contentDisposition.data(using: .utf8) ?? Data())
            multipartData.append("\(value)\r\n".data(using: .utf8) ?? Data())
        }

        /// final
        multipartData.append(boundaryData(forBoundaryType: .final, boundary: boundaryToken))

        return multipartData
    }

    private func boundaryData(forBoundaryType type: BoundaryType, boundary: String) -> Data {
        let boundaryText: String

        switch type {
        case .initial:
            boundaryText = "--\(boundary)\(EncodingCharacters.crlf)"
        case .encapsulated:
            boundaryText = "\(EncodingCharacters.crlf)--\(boundary)\(EncodingCharacters.crlf)"
        case .final:
            boundaryText = "\(EncodingCharacters.crlf)--\(boundary)--\(EncodingCharacters.crlf)"
        }

        return boundaryText.data(using: .utf8, allowLossyConversion: false) ?? Data()
    }
}
