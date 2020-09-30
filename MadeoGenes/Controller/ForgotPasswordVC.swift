import UIKit

class ForgotPasswordVC: UIViewController {
    @IBOutlet weak var putEmailLbl: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var logoSvgView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    var attributes : Attributes?
    var platforms : Platforms?
    lazy var homeView: HomeVC = {
        let viewController = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.homeViewController) as? HomeVC ?? HomeVC()
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
            self.initializeView()
        }
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func back_arrow_tap(_ sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func emailSendAction(_ sender: Any) {
        
        if emailTextField.text!.isEmpty{
            showToast(AlertMessage.enter_email)
        }else if !emailTextField.text!.isValidEmail() {
            showToast(AlertMessage.invalid_email)
        }else{
            self.view.endEditing(true)
            WebServices.shared.sendResetPasswordLink(emailTextField.text!, platform: (platforms?.slug)!) { (success, statusCode, response, detail, message) in
                if success {
                    self.homeView.attributes = self.attributes
                    self.navigationController?.pushViewController(self.homeView, animated: true)
                }else{
                    showToast(message ?? "")
                }
            }
        }
    }
}
extension ForgotPasswordVC {
    func initializeView(){       
        emailTextField.layer.cornerRadius = 5
        emailTextField.layer.shadowOpacity = 0.4
        emailTextField.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        emailTextField.layer.shadowRadius = 4.0
        let shadowRect: CGRect = emailTextField.bounds.insetBy(dx: 0, dy: 4)
        emailTextField.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        addPedding(emailTextField)
    }
    func addPedding(_ textField: UITextField) {
        let pendingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftView = pendingView
        textField.leftViewMode = .always
    }
}
