import UIKit
class SelectCenterTableCell: UITableViewCell {
    
    @IBOutlet weak var button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets.left = 40
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor(named: "eclipseColor"), for: .normal)
        button.setTitleColor(UIColor(named: "loganColor"), for: .highlighted)
        button.titleLabel?.font =  UIFont(name: "Lato-Bold", size: 20)
        button.layer.cornerRadius = 5
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowOpacity = 0.1
        button.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
