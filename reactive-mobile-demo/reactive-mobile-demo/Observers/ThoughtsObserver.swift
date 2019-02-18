
import RealmSwift

class ThoughtsObserver {
    var notificationToken: NotificationToken? = nil

    init() {
        let realm = try! Realm()
        let query = realm.objects(Thought.self)
            .sorted(byKeyPath: "timestamp", ascending: false)

        let token = query.observe { (changes: RealmCollectionChange) in
            switch changes {

            case .initial(let results):
                let thoughtIds: [Int] = results.map { $0.id }
                let payload: LoadedThoughtsPayload = .initial(thoughtIds: thoughtIds)
                store.dispatch(LoadedThoughts(payload: payload))
                break

            case .update(let results, let deletions, let insertions, let modifications):
                let thoughtIds: [Int] = results.map { $0.id }
                let payload: LoadedThoughtsPayload = .update(thoughtIds: thoughtIds,
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

let sharedThoughtsObserver = ThoughtsObserver()
