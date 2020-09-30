import UIKit
import FAPanels
class ViewController: UIViewController {
    var attributes : Attributes?
    var users: User?
    lazy var loginView: LoginVC = {
        let viewController = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.loginViewController) as? LoginVC ?? LoginVC()
        return viewController
    }()
    lazy var dashboardView: DashboardVC = {
        let viewController = UIStoryboard(name: Storyboard.Dashboard, bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.dashboardViewController) as? DashboardVC ?? DashboardVC()
        return viewController
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.getAttributes()
            self.getPlatforms()
        }
    }

    func getAttributes() {
        let organizationSlug = Bundle.main.infoDictionary!["organizationSlug"] as! String
        WebServices.shared.getAttributes(organizationSlug) { (status, statusCode, response, detail, message) in
            if status {
                let dict = response as! NSDictionary
                self.attributes = dict.attributeModel()
                self.loginView.attributes = self.attributes
                let isLogin = UserDefaults.standard.bool(forKey: "isLogin")
                if (isLogin) {
                    let user = [
                        "token" : UserDefaults.standard.string(forKey: "token")!,
                        "refreshToken" : UserDefaults.standard.string(forKey: "refreshToken")!
                    ]
                    self.users = (user as NSDictionary).userModel()
                    Share.shared.getMeta(attributes: self.attributes!, users: self.users!)
                } else {
                    self.navigationController?.pushViewController(self.loginView, animated: true)
                }
            }else{
                showToast(message ?? "")
            }
        }
    }
    
    func getPlatforms() {
        WebServices.shared.getPlatforms(Flavor.platformId) { (success, statusCode, response, detail, message) in
            if success {
                let array = response as! NSArray
                let dict = array[0] as! NSDictionary
                self.loginView.platforms = dict.platformModel()
            }else{
                showToast(message ?? "")
            }
        }
    }
}

