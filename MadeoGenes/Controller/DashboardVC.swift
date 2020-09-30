import UIKit
import FAPanels

class DashboardVC : UIViewController, FAPanelStateDelegate {
    @IBOutlet weak var logoSvgView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var NotificationBtn: UIButton!
    @IBOutlet weak var newsTable: UITableView!
    var attributes : Attributes?
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
        self.initializeView()
        newsTable.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func openMenuAction(_ sender: Any) {
        panel?.openLeft(animated: true)
    }
    
    @IBAction func receiveNotifications(_ sender: Any) {
        showToast("Show Notification")
    }

}
extension DashboardVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NewsCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NewsCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newsTable.deselectRow(at: indexPath, animated: false)
        panel!.configs.bounceOnCenterPanelChange = true
    }
    
    func initializeView(){
        panel!.delegate = self
    }
}
