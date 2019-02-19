
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

    func thoughtIds() -> [Int] {
        guard let thoughtsPayload = self.loadedThoughtsPayload else {
            return []
        }
        switch thoughtsPayload {
        case .initial(let thoughtIds):
            return thoughtIds
        case .update(let thoughtIds, _, _, _):
            return thoughtIds
        default:
            return []
        }
    }
}
