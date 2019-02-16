
import ReSwift

struct AppState: StateType {
    var authState = AuthState()
    var thoughts: [Thought] = []
}
