import Foundation

struct Menu : Codable {
    
    var icon : String?
    var label : String?
    var uri : String?
    var message: String?
    var statusCode: Int?
    var details: [String]?
    enum CodingKeys: String, CodingKey {
        case icon = "icon"
        case label = "label"
        case uri = "uri"
        case message = "message"
        case statusCode = "statusCode"
        case details = "details"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        label = try values.decodeIfPresent(String.self, forKey: .label)
        uri = try values.decodeIfPresent(String.self, forKey: .uri)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        details = try values.decodeIfPresent([String].self, forKey: .details)
    }
    
}
