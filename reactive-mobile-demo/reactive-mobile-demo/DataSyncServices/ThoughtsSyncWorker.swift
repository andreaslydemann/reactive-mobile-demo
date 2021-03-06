
import ReSwift

class ThoughtsSyncService: StoreSubscriber  {
    private var fetchNewThoughtsTimer: Timer? = nil

    func run() {
        if store.state.authState.loggedIn() {
            startPollingForThoughts()
        }
    }

    func stop() {
        fetchNewThoughtsTimer?.invalidate()
    }

    init() {
        store.subscribe(self)
    }

    deinit {
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
        self.fetchNewThoughtsTimer?.fire()
    }
}

let sharedThoughtsSyncWorker = ThoughtsSyncService()
