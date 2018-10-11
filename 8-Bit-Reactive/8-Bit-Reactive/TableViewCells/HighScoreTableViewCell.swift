
import UIKit

class HighScoreTableViewCell: UITableViewCell {

    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var indexLabel: UILabel!

    func fill(_ userHighScore: UserHighScore, index:UInt) {
        self.nameLabel.text = userHighScore.name
        self.scoreLabel.text = String(describing: userHighScore.score)
        self.indexLabel.text = "#\(index + 1)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
