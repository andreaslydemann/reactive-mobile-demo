
import ReSwift

enum LoginState {
    case none
    case error(String)
    case success(user: User, token: String)
    case loading
}

struct AuthState: StateType {
    var loginState: LoginState = .none
    var currentUser: User? = nil
}
