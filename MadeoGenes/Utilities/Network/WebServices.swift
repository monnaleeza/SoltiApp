import Foundation
import UIKit
import Alamofire
class WebServices : ResponseError {
    static var shared = WebServices()
    func getAttributes(_ slug: String, completionHandler: @escaping (Bool, Int?, Any?, String?, String?) -> Void) {
        AF.request("\(ServerURL.baseURL)\(String(format: EndPoint.attributes, slug))", method: .get).responseJSON { (response) in
            self.processResponse(response, completionHandler: completionHandler)
        }
    }
    func getPlatforms(_ ids: Int, completionHandler: @escaping (Bool, Int?, Any?, String?, String?) -> Void) {
        let params = ["ids": ids]
        AF.request("\(ServerURL.baseURL)\(String(format: EndPoint.platforms))", method: .get,parameters: params).responseJSON { (response) in
            self.processResponse(response, completionHandler: completionHandler)
        }
    }
    
    func getInforByToken(_ token: String, endpoint : String, method : String, completionHandler: @escaping (Bool, Int?, Any?, String?, String?) -> Void) {
        let headers : HTTPHeaders = [
            "Authorization": "Bearer "+token
        ]
        AF.request(endpoint, method: HTTPMethod(rawValue: method),headers: headers).responseJSON { (response) in
            self.processResponse(response, completionHandler: completionHandler)
        }
    }
    
    func getRefreshToken(_ token: String,_ refreshToken: String,_ slug:String, completionHandler: @escaping (Bool, Int?, Any?, String?, String?) -> Void) {
        var params : [String:Any] = [:]
        if slug.isEmpty {
            params = [
                "token":token,
                "refreshToken":refreshToken
            ]
        } else{
            params = [
                "token":token,
                "refreshToken":refreshToken,
                "project":slug
            ]
        }
        
        AF.request("\(ServerURL.baseURL)\(EndPoint.refreshToken)", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            self.processResponse(response, completionHandler: completionHandler)
        }
    }
    
    func sendResetPasswordLink(_ email: String, platform: String, completionHandler: @escaping (Bool, Int?, Any?, String?, String?) -> Void) {
        let params = [
            "username":email,
            "organization":"GC",
            "platform":platform
        ]
        AF.request("\(ServerURL.baseURL)\(EndPoint.requestpassword)", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            self.processResponse(response, completionHandler: completionHandler)
        }
    }
    
    func loginData(_ email: String, password: String, completionHandler: @escaping (Bool, Int?, Any?, String?, String?) -> Void) {
        let params = [
            "username":email,
            "password":password,
            "organization":Bundle.main.infoDictionary!["organizationName"] as! String,
            "project":Flavor.project
        ]
        AF.request("\(ServerURL.baseURL)\(EndPoint.login)", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            self.processResponse(response, completionHandler: completionHandler)
        }
    }
    
    func processResponse(_ response: DataResponse<Any, AFError>, completionHandler: @escaping (Bool, Int?, Any?, String?, String?) -> Void) {
        guard let httpResponse = response.response else {
            completionHandler(false, nil, nil, nil, AlertMessage.no_internet)
            return
        }
        switch httpResponse.statusCode {
        case 200, 201:
            guard let responseData = response.value else {
//                completionHandler(false, httpResponse.statusCode, nil, nil, AlertMessage.something_error)
                completionHandler(true, httpResponse.statusCode, nil, nil, nil)
                return
            }
            completionHandler(true, httpResponse.statusCode, responseData, nil, nil)
        case 202 :
            completionHandler(true, httpResponse.statusCode, nil, nil, nil)
        default:
            let (details, message) = error(response.value as! NSDictionary)
            completionHandler(false, httpResponse.statusCode, nil, details, message)
        }
    }
}
