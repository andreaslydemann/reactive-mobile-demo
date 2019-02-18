
import ReSwift

struct AuthState: StateType {
    var loading: Bool = false
    var authError: String? = nil
    var jwtToken: String? = nil
    var currentUser: User? = nil
}
