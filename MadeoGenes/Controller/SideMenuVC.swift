import UIKit
class SideMenuVC: UIViewController {
    
    @IBOutlet weak var accountSVGView: UIView!
    @IBOutlet weak var changeSVGView: UIView!
    @IBOutlet weak var logoutSVGView: UIView!
    
    @IBOutlet weak var accountBtn: UIButton!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var accountLbl: UILabel!
    @IBOutlet weak var changeLbl: UILabel!
    @IBOutlet weak var logoutLbl: UILabel!
    
    @IBOutlet weak var dynamicTableView: UITableView!
    var attributes : Attributes?
    var menuArrarys : [Menu] = []
    var menuLabels : [String] = []
    var menuIcons : [String] = []
    var menuUris : [String] = []
    var isChange : Bool = true
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
        initializeView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func actionAccount(_ sender: Any) {
        dashboardView.attributes = attributes
        let dashboardNavVC = UINavigationController(rootViewController: dashboardView)
        dashboardNavVC.setNavigationBarHidden(true, animated: false)
        panel!.center(dashboardNavVC, afterThat:{})
    }
    @IBAction func changeAction(_ sender: Any) {
        dashboardView.attributes = attributes
        let dashboardNavVC = UINavigationController(rootViewController: dashboardView)
        dashboardNavVC.setNavigationBarHidden(true, animated: false)
        panel!.center(dashboardNavVC, afterThat:{})
        showToast("change Center")
    }
    @IBAction func logoutAction(_ sender: Any) {
        dashboardView.attributes = attributes
        let dashboardNavVC = UINavigationController(rootViewController: dashboardView)
        dashboardNavVC.setNavigationBarHidden(true, animated: false)
        panel!.center(dashboardNavVC, afterThat:{})
        showToast("Log Out")
    }
    
}
extension SideMenuVC: UITableViewDataSource, UITableViewDelegate {
    func initializeView(){
        let accountSVG = UIView(SVGNamed: "ic_user") { (svgLayer) in
            let rect = CGRect(x: 0, y: 0, width: 30, height: 30)
            svgLayer.resizeToFit(rect)
            svgLayer.fillColor = UIColor(hex:Flavor.colorWhite,alpha: 0.5)?.cgColor
        }
        let changeSVG = UIView(SVGNamed: "ic_change") { (svgLayer) in
            let rect = CGRect(x: 0, y: 0, width: 20, height: 20)
            svgLayer.resizeToFit(rect)
            svgLayer.fillColor = UIColor(hex:Flavor.colorWhite,alpha: 0.5)?.cgColor
        }
        let logoutSVG = UIView(SVGNamed: "ic_logout") { (svgLayer) in
            let rect = CGRect(x: 0, y: 0, width: 20, height: 20)
            svgLayer.resizeToFit(rect)
            svgLayer.fillColor = UIColor(hex:Flavor.colorWhite,alpha: 0.5)?.cgColor
        }
        
        self.accountSVGView.addSubview(accountSVG)
        self.logoutSVGView.addSubview(logoutSVG)
        self.accountBtn.setBackgroundColor(UIColor(named: "systembackground")!, for: .highlighted)
        self.changeBtn.setBackgroundColor(UIColor(named: "systembackground")!, for: .highlighted)
        self.logoutBtn.setBackgroundColor(UIColor(named: "systembackground")!, for: .highlighted)
        for array in self.menuArrarys {
            self.menuIcons.append(array.icon!)
            self.menuLabels.append(array.label!)
            self.menuUris.append(array.uri!)
        }
        if(isChange){
            self.changeSVGView.addSubview(changeSVG)
            
        } else {
            self.changeLbl.isHidden = true
            self.changeBtn.isEnabled = false
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuLabels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SideMenuCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SideMenuCell
        cell.menuOption.text = menuLabels[indexPath.row]
        let menuSVG = UIView(SVGNamed: "ic_"+menuIcons[indexPath.row].lowercased()) { (svgLayer) in
            let rect = CGRect(x: 0, y: 0, width: 20, height: 20)
            svgLayer.resizeToFit(rect)
            svgLayer.fillColor = UIColor(hex:Flavor.colorWhite,alpha: 0.5)?.cgColor
        }
        cell.menuBtn.setBackgroundColor(UIColor(named: "systembackground")!, for: .highlighted)
        cell.menuBtn.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        cell.menuBtn.tag = indexPath.row
        cell.menuSVGView.addSubview(menuSVG)
        return cell
    }
    @objc func connected ( sender: UIButton){
        let buttonTag = sender.tag
        dashboardView.attributes = attributes
        let dashboardNavVC = UINavigationController(rootViewController: dashboardView)
        dashboardNavVC.setNavigationBarHidden(true, animated: false)
        panel!.center(dashboardNavVC, afterThat:{})
        if let urlString = menuUris[buttonTag].detectedFirstLink {
            let urlStrComponent = urlString.components(separatedBy: "://")[0]
            if urlStrComponent.contains("http"){
                if let url = URL(string: urlString) {
                    if(UIApplication.shared.canOpenURL(url)){
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        showToast(urlString)
                    }
                }
            } else{
                if let url = URL(string: "http://" + urlString) {
                    if(UIApplication.shared.canOpenURL(url)){
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        showToast(urlString)
                    }
                }
            }
            
        } else {
            let uri = menuUris[buttonTag]
            showToast(uri)
        }
    }
}
