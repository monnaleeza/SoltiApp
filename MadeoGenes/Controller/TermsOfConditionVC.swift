import UIKit
import LSDialogViewController

protocol StateDelegate {
    func afterback()
    func afteraccept()
    func dismissDialog()
}
class TermsOfConditionVC: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var textTV: UITextView!
    @IBOutlet weak var acceptBtn: UIButton!
    var users : User?
    var centerWelcome : CenterWelcome?
    var centerLegal : CenterLegal?
    var delegate : StateDelegate?
    var welcomedelegate : WelcomeVC?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.initializeView()
    }
    @IBAction func back_arrow_tap(_ sender: UITapGestureRecognizer) {
        self.delegate?.afterback()
        self.delegate?.dismissDialog()
    }
    @IBAction func acceptActtion(_ sender: Any) {
        let endpoint = "\(ServerURL.recordURL)\(String(format: EndPoint.legalaccepted))"
        WebServices.shared.getInforByToken((self.users?.token)!,endpoint: endpoint,method:"put") { (success, statusCode, response, detail, message) in
           if success {
            self.delegate?.afteraccept()
            self.delegate?.dismissDialog()
           }else{
               showToast(message ?? "")
           }
        }
    }
}
extension TermsOfConditionVC {
    func initializeView(){
        view.bounds.size.height = UIScreen.main.bounds.size.height - 30
        view.bounds.size.width = UIScreen.main.bounds.size.width - 30
        let date = self.centerLegal?.updatedAt!.dateformat()
        dateLbl.text = "Last Update:\(date!)"
        textTV.attributedText = self.centerLegal?.text?.htmlToAttributedString
        acceptBtn.layer.cornerRadius = 20
        acceptBtn.layer.borderWidth = 1.0
        acceptBtn.layer.borderColor = UIColor(named: "background")?.cgColor
        acceptBtn.setTitle(self.centerWelcome?.actionButton?.text,for: .normal)
    }
}
