import UIKit
class LoginVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var viewTap: UIView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var forgotPasswordbtn: UIButton!
    @IBOutlet weak var looginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var userTextField: UITextField!
    
    @IBOutlet weak var mainLbl: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var logoSvgView: UIView!
    
    @IBOutlet weak var userLbl: UILabel!
    let button = UIButton(type: .custom)
    
    @IBOutlet weak var poweredByLabel: UILabel!
    @IBOutlet weak var passwordLbl: UILabel!
    
    var attributes : Attributes?
    var platforms : Platforms?
    var users : User?
    var centers : Centers?
    var centerArrays : [Centers] = []
    var meta : Meta?
    var loadingView : LoadingView?
    
    lazy var forgotView: ForgotPasswordVC = {
        let viewController = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.forgotViewController) as? ForgotPasswordVC ?? ForgotPasswordVC()
        return viewController
    }()
    
    lazy var centerSelectionView: CenterSelectionVC = {
        let viewController = UIStoryboard(name: Storyboard.CenterSelection, bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.centerSelectionController) as? CenterSelectionVC ?? CenterSelectionVC()
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView = LoadingView(view)
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
        userTextField.delegate = self
        passwordField.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField == self.userTextField) {
            if userTextField.text!.isEmpty {
                showToast(AlertMessage.enter_email)
                self.userTextField.becomeFirstResponder()
                return false
            } else if !userTextField.text!.isValidEmail() {
                showToast(AlertMessage.invalid_email)
                self.userTextField.becomeFirstResponder()
                return false
            }
            self.passwordField.becomeFirstResponder()
        } else if (textField == self.passwordField) {
            if passwordField.text!.isEmpty {
                showToast(AlertMessage.enter_password)
                self.passwordField.becomeFirstResponder()
                return false
            }
        }
        return true
    }
    
    
    @IBAction func forgot_btn_click(_ sender: UIButton) {
        self.view.endEditing(true)
        forgotView.attributes = attributes
        forgotView.platforms = platforms
        self.navigationController?.pushViewController(forgotView, animated: true)
    }
    
    @IBAction func signup_btn_click(_ sender: UIButton) {
        if let urlStr = attributes?.website {
            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func login_btn_click(_ sender: UIButton) {
        actionLogin()
    }
    func actionLogin() {
        if userTextField.text!.isEmpty {
            showToast(AlertMessage.enter_email)
        }else if !userTextField.text!.isValidEmail() {
            showToast(AlertMessage.invalid_email)
        }else if passwordField.text!.isEmpty {
            showToast(AlertMessage.enter_password)
        }else{
            self.view.endEditing(true)
            loadingView?.startAnimation()
            WebServices.shared.loginData(userTextField.text!, password: passwordField.text!) { (success, statusCode, response, detail, message) in
                if success {
                    let dict = response as! NSDictionary
                    self.users = dict.userModel()
                    self.getCenters()
                }else{
                    self.loadingView?.stopAnimation()
                    showToast(message ?? "")
                }
            }
        }
    }
}

extension LoginVC {
    func initializeView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        viewTap.addGestureRecognizer(tap)
        userTextField.layer.cornerRadius = 5
        userTextField.layer.shadowOpacity = 0.4
        userTextField.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        userTextField.layer.shadowRadius = 4.0
        let shadowRect: CGRect = userTextField.bounds.insetBy(dx: 0, dy: 4)
        userTextField.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        addPedding(userTextField)

        passwordField.layer.cornerRadius = 5
        passwordField.layer.shadowOpacity = 0.4
        passwordField.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        passwordField.layer.shadowRadius = 4.0
        let shadowRect1: CGRect = passwordField.bounds.insetBy(dx: 0, dy: 4)
        passwordField.layer.shadowPath = UIBezierPath(rect: shadowRect1).cgPath
        addPedding(passwordField)
        
        let image = UIImage(systemName: "eye")
        image!.withTintColor(UIColor(named: "background")!)
        
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 2, left: -24, bottom: 2, right: 10)
        button.frame = CGRect(x: passwordField.frame.size.width - 25, y: 5, width: 15, height: 40)
        button.tintColor = UIColor(named: "background")
        button.addTarget(self, action: #selector(passwordButtonClick), for: .touchUpInside)
        button.tintColor = UIColor(named: "background")
        passwordField.rightView = button
        passwordField.rightViewMode = .always
        
        registerButton.layer.cornerRadius = 20
        registerButton.layer.borderWidth = 1.0
        registerButton.layer.borderColor = UIColor(named: "background")?.cgColor
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        hideKeyboardWhenTappedAround()
    }
    
    func getCenters() {
        let endpoint = "\(ServerURL.baseURL)\(String(format: EndPoint.centers))"
        WebServices.shared.getInforByToken((self.users?.token)!,endpoint: endpoint,method:"get") { (success, statusCode, response, detail, message) in
            if success {
                let arrays = response as! NSArray
                switch arrays.count {
                case 0:
                    print("error, show snackbar with error")
                    self.loadingView?.stopAnimation()
                case 1:
                    let dict = arrays[0] as! NSDictionary
                    self.centers = dict.centerModel()
                    Share.shared.processUnitCenter(attributes: self.attributes!,users:self.users!, centers: self.centers!)
                    self.loadingView?.stopAnimation()
                default:
                    UserDefaults.standard.set(true, forKey: "isChange")
                    self.loadingView?.stopAnimation()
                    for array in arrays {
                        self.centerArrays.append((array as! NSDictionary).centerModel()!)
                    }
                    self.centerSelectionView.centerArrarys = self.centerArrays
                    self.centerSelectionView.users = self.users
                    self.centerSelectionView.attributes = self.attributes
                    self.navigationController?.pushViewController(self.centerSelectionView, animated: true)
                }
            }else{
                self.loadingView?.stopAnimation()
                showToast(message ?? "")
            }
        }
    }
    
    @objc func passwordButtonClick(){
        if button.imageView?.image == UIImage(systemName: "eye"){
            let image = UIImage(systemName: "eye.fill")
            image!.withTintColor(UIColor(named: "background")!)
            
            button.setImage(image, for: .normal)
            passwordField.isSecureTextEntry = false
        }else{
            let image = UIImage(systemName: "eye")
            image!.withTintColor(UIColor(named: "background")!)
            
            button.setImage(image, for: .normal)
            passwordField.isSecureTextEntry = true
        }
    }
    func addPedding(_ textField: UITextField) {
        let pendingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftView = pendingView
        textField.leftViewMode = .always
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
     let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
       view.endEditing(true)
    }
}
