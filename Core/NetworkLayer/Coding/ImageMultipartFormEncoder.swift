import Foundation

public final class ImageMultipartFormEncoder: NetworkRequestEncoding {

    private let dataKey: String
    private let boundaryToken: String

    public init(boundaryToken: String, dataKey: String) {
        self.boundaryToken = boundaryToken
        self.dataKey = dataKey
    }

    public func encode(params: [String: Any]) throws -> Data {
        guard let data = params[dataKey] as? Data else { throw CodingError.missingData }

        var mutableParams = params
        mutableParams.removeValue(forKey: dataKey)

        return createMultipartBody(fromBinaryData: data, params: mutableParams)
    }

    private func createMultipartBody(fromBinaryData data: Data, params: [String: Any]) -> Data {
        var multipartData = Data()

        /// binary data
        let filename = "\(UUID().uuidString).jpg"
        let contentDisposition = "Content-Disposition: form-data; name=\"Image\"; filename=\"\(filename)\"\r\n"

        multipartData.append("--\(boundaryToken)\r\n".data(using: .utf8) ?? Data())
        multipartData.append(contentDisposition.data(using: .utf8) ?? Data())
        multipartData.append("Content-Type: image/jpg\r\n\r\n".data(using: .utf8) ?? Data())
        multipartData.append(data)
        multipartData.append("\r\n".data(using: .utf8) ?? Data())
        multipartData.append("--\(boundaryToken)--\r\n".data(using: .utf8) ?? Data())

        /// params
        params.forEach { (key: String, value: Any) in

            let contentDisposition = "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"

            multipartData.append("--\(boundaryToken)\r\n".data(using: .utf8) ?? Data())
            multipartData.append(contentDisposition.data(using: .utf8) ?? Data())
            multipartData.append("\(value)\r\n".data(using: .utf8) ?? Data())
            multipartData.append("--\(boundaryToken)--\r\n".data(using: .utf8) ?? Data())
        }

        return multipartData
    }
}
