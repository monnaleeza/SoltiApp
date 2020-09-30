import Foundation

struct Centers : Codable {
    
    var slug : String?
    var name : String?
    var language : String?
    var logoUrl :String?
    var rss :String?
    var rssLimit :Int?
    var hasWelcome :Bool?
    var message: String?
    var statusCode: Int?
    var details: [String]?
    enum CodingKeys: String, CodingKey {
        case slug = "slug"
        case name = "name"
        case language = "language"
        case logoUrl = "logoUrl"
        case rss = "rss"
        case rssLimit = "rssLimit"
        case hasWelcome = "hasWelcome"
        case message = "message"
        case statusCode = "statusCode"
        case details = "details"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        language = try values.decodeIfPresent(String.self, forKey: .language)
        logoUrl = try values.decodeIfPresent(String.self, forKey: .logoUrl)
        rss = try values.decodeIfPresent(String.self, forKey: .rss)
        rssLimit = try values.decodeIfPresent(Int.self, forKey: .rssLimit)
        hasWelcome = try values.decodeIfPresent(Bool.self, forKey: .hasWelcome)        
        message = try values.decodeIfPresent(String.self, forKey: .message)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        details = try values.decodeIfPresent([String].self, forKey: .details)
    }
}
