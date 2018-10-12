
import UIKit
import RealmSwift

class WelcomeViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var highScoreTable: UITableView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var startButton: UIButton!
    private var userNotificationToken: NotificationToken?
    private var userHighScoresToken: NotificationToken?
    private var userHighScores: [UserHighScore] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameTextField.delegate = self
        self.highScoreTable.dataSource = self
        self.highScoreTable.delegate = self
        self.highScoreTable.allowsSelection = false

        // Nuke all. Loading this page means we should be in a fresh state.
        let users = DB.findAll(User.self)
        self.userNotificationToken = users.observe(usersUpdated)

        let userHighScores = DB.findAll(UserHighScore.self)
        self.userHighScores.append(contentsOf: userHighScores)
        self.userHighScoresToken = userHighScores.observe(highScoresUpdated)
    }

    deinit {
        self.userHighScoresToken?.invalidate()
        self.userNotificationToken?.invalidate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startButton.isHidden = true
        self.nameTextField.isHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        APIClient.shared.getScoreBoard()
    }

    private func highScoresUpdated(changes: RealmCollectionChange<Results<UserHighScore>>) {
        switch changes {
        case .initial:
            self.highScoreTable.reloadData()
            break

        case .update(let userHighScores, let deletions, let insertions, let modifications):
            self.userHighScores.removeAll()
            self.userHighScores.append(contentsOf: userHighScores)
            self.highScoreTable.beginUpdates()
            self.highScoreTable.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                 with: .automatic)
            self.highScoreTable.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                 with: .automatic)
            self.highScoreTable.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                 with: .automatic)
            self.highScoreTable.endUpdates()
            break

        case .error(let error):
            print("Error receiving notifications for user high scores: \(error)")
            break
        }
    }

    private func usersUpdated(changes: RealmCollectionChange<Results<User>>) {
        switch changes {
        case .initial:
            break

        case .update(let users, _, _, _):
            if users.count == 1, let user = users.first {
                // We got a new user!
                self.startButton.setTitle("Hello \(user.name). Let's get started!", for: .normal)
                self.startButton.isHidden = false
                self.nameTextField.isHidden = true
            }
            break

        case .error(let error):
            print("Error receiving notification for user: \(error)")
            break
        }
    }

    // MARK: - UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userHighScores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HighScoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: "highScoreCell") as! HighScoreTableViewCell
        let index = indexPath.row
        let highScore = self.userHighScores[index]
        cell.fill(highScore, index: UInt(index))
        return cell
    }

    // MARK: - UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text, text.count > 0 {
            // Destroy existing user(s)
            DB.findAll(User.self).forEach { $0.destroy() }

            // Create the new user
            User(value:["name": text]).save()
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
