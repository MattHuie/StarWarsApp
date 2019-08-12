import UIKit

class PlanetsTableViewCell: UITableViewCell {

    @IBOutlet weak var planetNameLabel: UILabel!
    @IBOutlet weak var planetClimateLabel: UILabel!
    @IBOutlet weak var planetPopulationLabel: UILabel!
    @IBOutlet weak var planetCreatedLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
