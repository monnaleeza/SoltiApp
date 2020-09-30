import UIKit

class SideMenuCell: UITableViewCell {
    @IBOutlet weak var menuSVGView: UIView!
    @IBOutlet weak var menuOption: UILabel!
    @IBOutlet weak var menuBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated : animated)
    }
}
