
import ReSwift
import UIKit

class ThoughtsViewController: UIViewController, StoreSubscriber, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var newThoughtTextfield: UITextField!
    @IBOutlet var thoughtsTable: UITableView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store.subscribe(self) { sub in
            return sub.select { state in return state.thoughtsState }.skipRepeats()
        }
        sharedThoughtsObserver.run()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        store.unsubscribe(self)
        sharedThoughtsObserver.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.thoughtsTable.delegate = self
        self.thoughtsTable.dataSource = self
    }

    func newState(state: ThoughtsState) {
        setHeaderLabel()

        guard let loadedThoughts = state.loadedThoughtsPayload else {
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
            self.headerLabel.text = "\(user.username)'s Feed"
        }
    }

    @IBAction func postThoughtPressed(_ sender: Any) {
        self.newThoughtTextfield.resignFirstResponder()

        let action = createThoughtAction(text: self.newThoughtTextfield.text!)
        store.dispatch(action)

        self.newThoughtTextfield.text = ""
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.state.thoughtsState.thoughts().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "thoughtCell")

        let thought = store.state.thoughtsState.thoughts()[indexPath.row]

        cell.textLabel?.text = thought.text
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "\(thought.by): \(thought.timestamp.toFriendlyFormat())"
        cell.backgroundColor = UIColor.colorForString(thought.by)

        return cell
    }
}
