
import UIKit

class ThoughtsViewController: UIViewController {
    @IBOutlet var newThoughtTextfield: UITextField!
    @IBOutlet var thoughtsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func logoutPressed(_ sender: Any) {
    }
    @IBAction func postThoughtPressed(_ sender: Any) {
    }

    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
    }
}
