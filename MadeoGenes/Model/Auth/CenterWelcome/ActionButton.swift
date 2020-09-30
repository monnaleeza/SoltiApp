struct ActionButton : Codable {
    var text : String?
    var url : String?
    
    enum CodingKeys: String, CodingKey {
        case text = "text"
        case url = "url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }
}
