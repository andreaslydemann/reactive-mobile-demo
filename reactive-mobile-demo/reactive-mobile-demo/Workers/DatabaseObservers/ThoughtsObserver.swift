
import RealmSwift

class ThoughtsObserver: Worker {
    private var notificationToken: NotificationToken? = nil
    private static let sharedObserver = { return ThoughtsObserver() }

    func run() {}

    init() {
        startObservingDatabase()
    }

    deinit {
        self.notificationToken?.invalidate()
    }
    
    func startObservingDatabase() {
        let realm = try! Realm()
        let query = realm.objects(Thought.self).sorted(byKeyPath: "timestamp", ascending: false)

        let token = query.observe { (changes: RealmCollectionChange) in
            switch changes {

            case .initial(let results):
                let payload: LoadedThoughtsPayload = .initial(thoughts: results.map { $0 })
                store.dispatch(LoadedThoughts(payload: payload))
                break

            case .update(let results, let deletions, let insertions, let modifications):
                let payload: LoadedThoughtsPayload = .update(thoughts: results.map { $0 },
                                                             deletions: deletions,
                                                             insertions: insertions,
                                                             modifications: modifications)
                store.dispatch(LoadedThoughts(payload: payload))
                break

            case .error(let error):
                store.dispatch(LoadedThoughts(payload: .error(error)))
            }
        }

        self.notificationToken = token
    }
}
