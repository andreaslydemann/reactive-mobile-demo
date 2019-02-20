
import ReSwift

struct AppState: StateType, Equatable {
    var authState = AuthState()
    var thoughtsState = ThoughtsState()
}
