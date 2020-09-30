import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var newsImg: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated : animated)
    }
}
