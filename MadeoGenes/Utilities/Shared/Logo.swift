import Foundation
import UIKit
class Logo
{
    static let shared = Logo()
    var isRequestPending = false
    func displayLogo(_ logoURL : String, completion: @escaping(_ svg: Bool?, _ image: UIImage?, _ svgView: UIView?) -> ()) {
        let components = logoURL.components(separatedBy: ".")
        let url = URL(string: logoURL)
        do{
            if components[components.count-1].lowercased() == "svg" {
                let logosvg = UIView(SVGURL: url!) { (svgLayer) in
                    let rect = CGRect(x: 0, y: 0, width: 200, height: 60)
                    svgLayer.resizeToFit(rect)
                }
                completion(true, nil, logosvg)
            } else {
                let data = try Data(contentsOf: url!)
                let img = UIImage(data: data)
                completion(false,img, nil)
            }
        } catch let error {
            print("Error occured : \(error.localizedDescription)")
            completion(nil,nil,nil)
        }
    }
}
