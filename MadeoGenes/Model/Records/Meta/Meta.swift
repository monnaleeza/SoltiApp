import Foundation

struct Meta : Codable {
    
    var welcomeAccepted : Bool?
    var legalAccepted : Bool?
    var message: String?
    var statusCode: Int?
    var details: [String]?
    enum CodingKeys: String, CodingKey {
        case welcomeAccepted = "welcomeAccepted"
        case legalAccepted = "legalAccepted"
        case message = "message"
        case statusCode = "statusCode"
        case details = "details"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        welcomeAccepted = try values.decodeIfPresent(Bool.self, forKey: .welcomeAccepted)
        legalAccepted = try values.decodeIfPresent(Bool.self, forKey: .legalAccepted)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        details = try values.decodeIfPresent([String].self, forKey: .details)
    }
}
