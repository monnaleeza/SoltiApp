import Foundation
struct CenterWelcome : Codable {
    var title : String?
    var text : String?
    var media : Media?
    var readMore : ReadMore?
    var actionButton : ActionButton?
    var message: String?
    var statusCode: Int?
    var details: [String]?
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case text = "text"
        case media = "media"
        case readMore = "readMore"
        case actionButton = "actionButton"
        case message = "message"
        case statusCode = "statusCode"
        case details = "details"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        media = try values.decodeIfPresent(Media.self, forKey: .media)
        readMore = try values.decodeIfPresent(ReadMore.self, forKey: .readMore)
        actionButton = try values.decodeIfPresent(ActionButton.self, forKey: .actionButton)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        details = try values.decodeIfPresent([String].self, forKey: .details)
    }
}
