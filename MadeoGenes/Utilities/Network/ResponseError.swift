import UIKit
import Alamofire
class ResponseError {
    func error(_ responseDict: NSDictionary) -> (String, String) {
        var strDetails = "", strMessage = ""
        if let details = responseDict.value(forKey: "details") as? NSArray {
            strDetails = "\(details)"
        }
        if let message = responseDict.value(forKey: "message") as? String {
            strMessage = message
        }
        return (strDetails, strMessage)
    }
}
