
import UIKit
import RealmSwift

class WelcomeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var highScoreTable: UITableView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var startButton: UIButton!
    private var userNotificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameTextField.delegate = self

        // Nuke them all. Loading this page means we should be in a fresh state.
        let allUsersResults = DB.findAll(User.self)
        allUsersResults .forEach { $0.destroy() }

        self.userNotificationToken = allUsersResults.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                break

            case .update(let users, _, _, _):
                if users.count == 1, let user = users.first {
                    // We got a new user!
                    self?.startButton.setTitle("Hello \(user.name). Let's get started!", for: .normal)
                    self?.startButton.isHidden = false
                    self?.nameTextField.isHidden = true
                }
                break

            case .error(let error):
                print("Error receiving notification for user: \(error)")
                break
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.startButton.isHidden = true
        self.nameTextField.isHidden = false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text, text.count > 0 {
            let user = User()
            user.name = text
            user.save()
        }
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
