import Foundation

public struct MultipartData {

    public init(data: Data, mimetype: String, filename: String) {
        self.data = data
        self.mimetype = mimetype
        self.filename = filename
    }

    let data: Data
    let mimetype: String
    let filename: String
}
