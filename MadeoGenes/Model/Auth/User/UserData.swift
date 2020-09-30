import Foundation
struct UserData : Codable {
    var id : Int?
    var email : String?
    var platformId : Int?
    var organizationId : Int?
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case email = "email"
        case platformId = "platformId"
        case organizationId = "organizationId"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        platformId = try values.decodeIfPresent(Int.self, forKey: .platformId)
        organizationId = try values.decodeIfPresent(Int.self, forKey: .organizationId)
    }

}
