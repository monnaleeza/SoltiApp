import Foundation
import UIKit
import FAPanels
class Share : UIViewController
{
    static let shared = Share()
    var users : User?
    var centers : Centers?
    var meta : Meta?
    var centerArrays : [Centers] = []
    var isRequestPending = false
    lazy var welcomeView: WelcomeVC = {
        let viewController = UIStoryboard(name: Storyboard.Welcome, bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.welcomeController) as? WelcomeVC ?? WelcomeVC()
        return viewController
    }()
    lazy var dashboardView: DashboardVC = {
        let viewController = UIStoryboard(name: Storyboard.Dashboard, bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.dashboardViewController) as? DashboardVC ?? DashboardVC()
        return viewController
    }()
    lazy var sidemenuView: SideMenuVC = {
        let viewController = UIStoryboard(name: Storyboard.Dashboard, bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.sideMenuViewController) as? SideMenuVC ?? SideMenuVC()
        return viewController
    }()
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
    func saveInfor( users: User ){
        UserDefaults.standard.set(true, forKey: "isLogin")
        UserDefaults.standard.set(users.token, forKey: "token")
        UserDefaults.standard.set(users.refreshToken, forKey: "refreshToken")
    }
    
    func processUnitCenter(attributes: Attributes, users: User, centers: Centers){
        self.users = users
        self.centers = centers
        WebServices.shared.getRefreshToken((self.users?.token)!, (self.users?.refreshToken)!, (self.centers?.slug)!) { (success, statusCode, response, detail, message) in
            if success {
                let dict = response as! NSDictionary
                self.users = dict.userModel()
                if (self.centers?.hasWelcome)! {
                    self.getMeta(attributes:attributes,users: self.users!)
                } else {
                    self.createFAPanel(attributes: attributes,users: self.users!)
                }
            }else{
                showToast(message ?? "")
            }
        }
    }
    func getMeta(attributes: Attributes, users:User){
        let isLogin = UserDefaults.standard.bool(forKey: "isLogin")
        self.welcomeView.users = users
        self.welcomeView.attributes = attributes
        let endpoint1 = "\(ServerURL.recordURL)\(String(format: EndPoint.meta))"
        WebServices.shared.getInforByToken(users.token!,endpoint: endpoint1,method:"get") { (success, statusCode, response, detail, message) in
           if success {
               let dict = response as! NSDictionary
               self.meta = dict.metaModel()!
            if (self.meta?.welcomeAccepted)!{
                if (self.meta?.legalAccepted)!{
                    self.createFAPanel(attributes: attributes,users: users)
                } else {
                    if isLogin {
                        self.dashboardView.isLegalAccepted = true
                    }
                    self.createFAPanel(attributes: attributes, users: users)
                }
            } else {
               if isLogin {
                   self.welcomeView.isWelcomeAccepted = true
               }
               self.createNavigation(viewController: self.welcomeView)
            }
           }else{
                let token = UserDefaults.standard.string(forKey: "token")!
                let refreshToken = UserDefaults.standard.string(forKey: "refreshToken")!
                WebServices.shared.getRefreshToken(token, refreshToken,"") { (success, statusCode, response, detail, message) in
                   if success {
                       let dict = response as! NSDictionary
                       self.users = dict.userModel()
                       self.saveInfor(users: self.users!)
                       self.getMeta(attributes: attributes, users: self.users!)
                   }else{
                       showToast(message ?? "")
                   }
               }
           }
        }
    }
    func createNavigation(viewController:UIViewController){
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(viewController, animated: true)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    func createFAPanel(attributes:Attributes,users:User) {
        self.saveInfor(users: users)
        dashboardView.users = users
        dashboardView.attributes = attributes
        sidemenuView.attributes = attributes
        sidemenuView.isChange = UserDefaults.standard.bool(forKey: "isChange")
        let endpoint = "\(ServerURL.baseURL)\(String(format: EndPoint.centermenu))"
        WebServices.shared.getInforByToken(users.token!,endpoint: endpoint,method:"get") { (success, statusCode, response, detail, message) in
           if success {
                let arrays = response as! NSArray
                for array in arrays {
                    self.sidemenuView.menuArrarys.append((array as! NSDictionary).menuModel()!)
                }
                let dashboardNavVC = UINavigationController(rootViewController: self.dashboardView)
                dashboardNavVC.setNavigationBarHidden(true, animated: true)
                let rootController = FAPanelController()
                rootController.configs.bounceOnRightPanelOpen = false
                rootController.configs.canRecognizePanGesture = true
                rootController.configs.leftPanelWidth = UIScreen.main.bounds.size.width - 20
                rootController.leftPanelPosition = .back
                _ = rootController.center(dashboardNavVC).left(self.sidemenuView)
                UIApplication.shared.windows.first?.rootViewController = rootController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
           }else{
            showToast(message ?? "")
           }
        }
    }
    
    func processCenterWelcome(users:User, completion: @escaping (_ centerWelcome: CenterWelcome?, _ message: String?)-> Void) {
        let endpoint = "\(ServerURL.baseURL)\(String(format: EndPoint.centerwelcome))"
            WebServices.shared.getInforByToken((users.token)!,endpoint: endpoint,method:"get") { (success, statusCode, response, detail, message) in
           if success {
               let dict = response as! NSDictionary
               completion(dict.centerWelcomeModel(), nil)
           }else{
               completion(nil, message)
           }
        }
    }
    func processCenterLegal(users:User ,completion: @escaping (_ centerLegal: CenterLegal?, _ message: String? )->Void ){
        let endpoint = "\(ServerURL.baseURL)\(String(format: EndPoint.centerlegal))"
        WebServices.shared.getInforByToken((users.token)!,endpoint: endpoint,method:"get") { (success, statusCode, response, detail, message) in
           if success {
               let dict = response as! NSDictionary
               completion(dict.centerLegalModel(),nil)
           }else{
               completion(nil,message)
           }
        }
    }
}
