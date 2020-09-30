import Foundation
struct User : Codable {
    var token : String?
    var refreshToken : String?
    var userData : UserData?
    var message: String?
    var statusCode: Int?
    var details: [String]?
    enum CodingKeys: String, CodingKey {
        case token = "token"
        case refreshToken = "refreshToken"
        case userData = "user"
        case message = "message"
        case statusCode = "statusCode"
        case details = "details"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        refreshToken = try values.decodeIfPresent(String.self, forKey: .refreshToken)
        userData = try values.decodeIfPresent(UserData.self, forKey: .userData)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        details = try values.decodeIfPresent([String].self, forKey: .details)
    }

}
