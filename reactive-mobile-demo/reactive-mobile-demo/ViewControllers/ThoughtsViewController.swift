
import ReSwift
import UIKit

class ThoughtsViewController: UIViewController, StoreSubscriber, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var newThoughtTextfield: UITextField!
    @IBOutlet var thoughtsTable: UITableView!
    var fetchNewThoughtsTimer: Timer? = nil

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

        guard let loadedThoughts = state.thoughtsState.loadedThoughtsPayload else {
            return
        }
        
        switch loadedThoughts {
            case .initial(_):
                self.thoughtsTable.reloadData()
                break

            case .update(_, let deletions, let insertions, let modifications):
                self.thoughtsTable.beginUpdates()

                let insertionIndexes = insertions.map { IndexPath(row: $0, section: 0) }
                let deletionIndexes = deletions.map { IndexPath(row: $0, section: 0)}
                let modificationIndexes = modifications.map { IndexPath(row: $0, section: 0) }

                self.thoughtsTable.insertRows(at: insertionIndexes, with: .automatic)
                self.thoughtsTable.deleteRows(at: deletionIndexes, with: .automatic)
                self.thoughtsTable.reloadRows(at: modificationIndexes, with: .automatic)

                self.thoughtsTable.endUpdates()
                break

            default:
                break
        }
    }

    func setHeaderLabel() {
        if let user = store.state.authState.currentUser() {
            self.headerLabel.text = "\(user.username)'s Chitter"
        }
    }

    @IBAction func postThoughtPressed(_ sender: Any) {
        self.newThoughtTextfield.resignFirstResponder()

        let action = createThoughtAction(text: self.newThoughtTextfield.text!)
        store.dispatch(action)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.state.thoughtsState.thoughts().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "thoughtCell")

        let thought = store.state.thoughtsState.thoughts()[indexPath.row]
        cell.textLabel?.text = "\(thought.by): \(thought.text)"
        cell.detailTextLabel?.text = "\(thought.timestamp)"

        return cell
    }
}
