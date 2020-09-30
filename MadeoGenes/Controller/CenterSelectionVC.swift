import UIKit
import Foundation

class CenterSelectionVC : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var logoSvgView: UIView!
    @IBOutlet weak var centertable: UITableView!
    @IBOutlet weak var SelectCenterBtn: UITableView!
    
    var attributes : Attributes?
    var users : User?
    var centerArrarys : [Centers] = []
    var meta : Meta?
    var buttonArray = [String]();
    
    lazy var welcomeView: WelcomeVC = {
        let viewController = UIStoryboard(name: Storyboard.Welcome, bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.welcomeController) as? WelcomeVC ?? WelcomeVC()
        return viewController
    }()
    lazy var dashboardView: DashboardVC = {
        let viewController = UIStoryboard(name: Storyboard.Dashboard, bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.dashboardViewController) as? DashboardVC ?? DashboardVC()
        return viewController
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        Share.shared.displayLogo((attributes?.logoUrl)!) { (svg, img, svgview) in
            if let svg = svg {
                if svg {
                    self.logoImage.isHidden = true
                    self.logoSvgView.addSubview(svgview!)
                } else {
                    self.logoSvgView.isHidden = true
                    self.logoImage.image = img
                }
            } else {
                showToast((self.attributes?.message)!)
            }
        }
        DispatchQueue.main.async {
            self.getCenters()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttonArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SelectCenterTableCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SelectCenterTableCell
        let buttonTitle = buttonArray[indexPath.row]
        cell.button.setTitle(buttonTitle, for: .normal)
        cell.button.setTitle(buttonTitle, for: .highlighted)
        cell.button.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        cell.button.tag = indexPath.row
        return cell
    }
    
    @objc func connected( sender: UIButton)
     {
        let buttonTag = sender.tag
        Share.shared.processUnitCenter(attributes:self.attributes!, users:self.users!, centers: self.centerArrarys[buttonTag])
    }
}
extension CenterSelectionVC {
    func initializeView(){
        self.centertable.backgroundColor = UIColor(named: "systembackground")
        self.centertable.rowHeight = 80
    }
    
    func getCenters() {
        for array in self.centerArrarys {
            self.buttonArray.append((array.name)!)
        }
        self.centertable.reloadData()
        initializeView()
    }
}
