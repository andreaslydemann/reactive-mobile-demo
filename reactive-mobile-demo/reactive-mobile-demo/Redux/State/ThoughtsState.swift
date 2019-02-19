
import ReSwift

struct ThoughtsState: StateType {
    var loading: Bool
    var lastError: String?
    var loadedThoughtsPayload: LoadedThoughtsPayload?

    init(loading: Bool = false, lastError: String? = nil, payload: LoadedThoughtsPayload? = nil) {
        self.loading = loading
        self.lastError = lastError
        self.loadedThoughtsPayload = payload
    }

    func thoughts() -> [Thought] {
        guard let thoughtsPayload = self.loadedThoughtsPayload else {
            return []
        }
        switch thoughtsPayload {
        case .initial(let thoughts):
            return thoughts
        case .update(let thoughts, _, _, _):
            return thoughts
        default:
            return []
        }
    }
}
