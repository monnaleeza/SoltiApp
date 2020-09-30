import Foundation

struct Platforms : Codable {
    
    var id : Int?
    var name : String?
    var slug : String?
    var frontUrl :String?
    var message: String?
    var statusCode: Int?
    var details: [String]?
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case slug = "slug"
        case frontUrl = "frontUrl"
        case message = "message"
        case statusCode = "statusCode"
        case details = "details"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        frontUrl = try values.decodeIfPresent(String.self, forKey: .frontUrl)        
        message = try values.decodeIfPresent(String.self, forKey: .message)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        details = try values.decodeIfPresent([String].self, forKey: .details)
    }
    
}
