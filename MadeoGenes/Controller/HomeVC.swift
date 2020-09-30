import UIKit
import SwiftSVG

class HomeVC: UIViewController {
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var logoSvgView: UIView!
    @IBOutlet weak var checkemailView: UIView!
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
        
        initializeView()
    }
    @IBAction func continueAction(_ sender: Any) {
        self.navigationController?.popToViewController(navigationController!.viewControllers[1], animated: true)
    }
}
extension HomeVC {
    func initializeView() {
        let checkemail = UIView(SVGNamed: "checkemail") { (svgLayer) in
            svgLayer.resizeToFit(self.checkemailView.bounds)
        }
        self.checkemailView.addSubview(checkemail)
    }
}
