import UIKit
import WebKit
import Foundation
import YouTubePlayer
import SDWebImage
import LSDialogViewController

class WelcomeVC: UIViewController,StateDelegate, YouTubePlayerDelegate {
    func afterback() {
        checkBoxButton.isSelected = !checkBoxButton.isSelected
        isChecked = false
    }
    
    func afteraccept() {
        acceptButton.layer.cornerRadius = 20
        acceptButton.layer.borderWidth = 1.0
        acceptButton.layer.borderColor = UIColor(named: "background")?.cgColor
        acceptButton.setTitle(self.centerWelcome?.actionButton?.text,for: .normal)
        acceptButton.isEnabled = true
        acceptButton.backgroundColor = UIColor(named: "background")
    }
    func dismissDialog() {
        dismissDialogViewController()
    }
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var readmoreBtn: UIButton!
    @IBOutlet weak var youtubePlayer: YouTubePlayerView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    var didLoadVideo = false
    
    var attributes : Attributes?
    var users : User?
    var centerWelcome :CenterWelcome?
    var centerLegal : CenterLegal?
    
    let button = UIButton(type: .custom)
    private var isChecked = false
    
    lazy var termsofconditionview: TermsOfConditionVC = {
        let viewController = UIStoryboard(name: Storyboard.Welcome, bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.termsofconditionController) as? TermsOfConditionVC ?? TermsOfConditionVC()
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.getCenterWelcome()
            self.getCenterLegal()
        }
    }
    @IBAction func checkMarkTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            self.isChecked = !self.isChecked
            if self.isChecked {
                self.termsofconditionview.delegate = self
                self.termsofconditionview.users = self.users
                self.termsofconditionview.centerWelcome = self.centerWelcome
                self.termsofconditionview.centerLegal = self.centerLegal
                self.presentDialogViewController(self.termsofconditionview, animationPattern: .fadeInOut)
            }
            UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
            }, completion: nil)
        }
    }
    @IBAction func readmoreAction(_ sender: UIButton) {
        if let urlStr = centerWelcome?.readMore?.url {
            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        let endpoint = "\(ServerURL.recordURL)\(String(format: EndPoint.welcomeaccepted))"
        WebServices.shared.getInforByToken((self.users?.token)!,endpoint: endpoint,method:"put") { (success, statusCode, response, detail, message) in
           if success {
            Share.shared.saveInfor(users: self.users!)
            Share.shared.createFAPanel(attributes: self.attributes!, users: self.users!)
           }else{
               showToast(message ?? "")
           }
        }
    }
    
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
    }
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
    }
    func playerQualityChanged(_ videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {
    }
}

extension WelcomeVC {
    func initializeView(){
        titleLbl.text = self.centerWelcome?.title
        textLbl.text = self.centerWelcome?.text
        readmoreBtn.setTitle(self.centerWelcome?.readMore?.text, for: .normal)
        checkBoxButton.setImage(UIImage(systemName: "square"), for: .normal)
        checkBoxButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        acceptButton.layer.cornerRadius = 20
        acceptButton.setTitle(self.centerWelcome?.actionButton?.text,for: .normal)
        acceptButton.isEnabled = false
        acceptButton.backgroundColor = UIColor.lightGray
        
        if self.centerWelcome?.media?.type == "YOUTUBE" {
            youtubePlayer.isHidden = false
            imageView.isHidden = true
            let youtubeUrl = URL(string: (self.centerWelcome?.media?.url)!)
            youtubePlayer.delegate = self
            youtubePlayer.playerVars = [
                            "playsinline": "1"
                        ] as YouTubePlayerView.YouTubePlayerParameters
            youtubePlayer.loadVideoURL(youtubeUrl!)
        } else {
            youtubePlayer.isHidden = true
            imageView.isHidden = false
            imageView.sd_setImage(with: URL(string: (self.centerWelcome?.media?.url!)!), placeholderImage: nil, options: .refreshCached) { (image, error, type, url) in
            }
        }
    }
    func getCenterWelcome(){
            let endpoint = "\(ServerURL.baseURL)\(String(format: EndPoint.centerwelcome))"
            WebServices.shared.getInforByToken((self.users?.token)!,endpoint: endpoint,method:"get") { (success, statusCode, response, detail, message) in
           if success {
               let dict = response as! NSDictionary
               self.centerWelcome = dict.centerWelcomeModel()
               self.initializeView()
           }else{
               showToast(message ?? "")
           }
        }
    }
    func getCenterLegal(){
        let endpoint = "\(ServerURL.baseURL)\(String(format: EndPoint.centerlegal))"
        WebServices.shared.getInforByToken((self.users?.token)!,endpoint: endpoint,method:"get") { (success, statusCode, response, detail, message) in
           if success {
               let dict = response as! NSDictionary
               self.centerLegal = dict.centerLegalModel()
           }else{
               showToast(message ?? "")
           }
        }
    }
}
