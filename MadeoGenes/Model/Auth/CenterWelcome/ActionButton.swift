struct ActionButton : Codable {
    var text : String?
    var uri : String?
    
    enum CodingKeys: String, CodingKey {
        case text = "text"
        case uri = "uri"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        uri = try values.decodeIfPresent(String.self, forKey: .uri)
    }
}
