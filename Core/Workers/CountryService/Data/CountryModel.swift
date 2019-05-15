import Foundation

public struct CountryModel: Codable {

    public let name: String
    public let countryCode: String
    public let phoneCode: String
    public let flag: String

    public init(name: String, countryCode: String, phoneCode: String, flag: String) {
        self.name = name
        self.countryCode = countryCode
        self.phoneCode = phoneCode
        self.flag = flag
    }

}
