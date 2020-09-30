import Foundation

struct Attributes : Codable {
    
    var color : String?
    var logoUrl : String?
    var website : String?
    var message: String?
    var statusCode: Int?
    var details: [String]?
    enum CodingKeys: String, CodingKey {
        case color = "color"
        case logoUrl = "logoUrl"
        case website = "website"
        case message = "message"
        case statusCode = "statusCode"
        case details = "details"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        color = try values.decodeIfPresent(String.self, forKey: .color)
        logoUrl = try values.decodeIfPresent(String.self, forKey: .logoUrl)
        website = try values.decodeIfPresent(String.self, forKey: .website)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        details = try values.decodeIfPresent([String].self, forKey: .details)
    }
    
}
