
import ReSwift

struct ThoughtsState: StateType, Equatable {
    var lastError: String?
    var loadedThoughtsPayload: LoadedThoughtsPayload?

    init(lastError: String? = nil, payload: LoadedThoughtsPayload? = nil) {
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
