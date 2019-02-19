
import ReSwift

class ThoughtsSyncWorker: StoreSubscriber, Worker  {
    private var fetchNewThoughtsTimer: Timer? = nil

    func run() {}

    init() {
        store.subscribe(self)
    }

    deinit {
        fetchNewThoughtsTimer?.invalidate()
        store.unsubscribe(self)
    }

    func newState(state: AppState) {
        if state.authState.loggedIn() {
            startPollingForThoughts()
        } else {
            fetchNewThoughtsTimer?.invalidate()
        }
    }

    func startPollingForThoughts() {
        if let alreadyPolling = self.fetchNewThoughtsTimer?.isValid, alreadyPolling {
            return
        }

        self.fetchNewThoughtsTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { _ in
            store.dispatch(fetchThoughtsAction())
        })
    }
}

let sharedThoughtsSyncWorker = ThoughtsSyncWorker()
