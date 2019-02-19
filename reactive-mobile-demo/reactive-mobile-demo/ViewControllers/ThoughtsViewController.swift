
import ReSwift
import UIKit

class ThoughtsViewController: UIViewController, StoreSubscriber, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var newThoughtTextfield: UITextField!
    @IBOutlet var thoughtsTable: UITableView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store.subscribe(self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        store.unsubscribe(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.thoughtsTable.delegate = self
        self.thoughtsTable.dataSource = self
    }

    func newState(state: AppState) {
        setHeaderLabel()
    }

    func setHeaderLabel() {
        if let user = store.state.authState.currentUser() {
            self.headerLabel.text = "\(user.username)'s Chitter"
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.state.thoughtsState.thoughtIds().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "thoughtCell")
        let thoughtIds = store.state.thoughtsState.thoughtIds()
        let thoughtId = thoughtIds[indexPath.row]

        if let thought = Thought.find(thoughtId) {
            cell.textLabel?.text = "\(thought.by): \(thought.text)"
            cell.detailTextLabel?.text = "\(thought.timestamp)"
        }
        return cell
    }

    @IBAction func postThoughtPressed(_ sender: Any) {
    }
}
