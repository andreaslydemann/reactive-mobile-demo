
import ReSwift

struct AuthState: StateType {
    var loading: Bool = false
    var authError: String? = nil
    var currentUserId: Int? = nil

    func loggedIn() -> Bool {
        return jwtToken() != nil
    }

    func jwtToken() -> String? {
        if let user = currentUser() {
            return user.jwtToken
        }
        return nil
    }

    func currentUser() -> User? {
        if let userId = self.currentUserId {
            return User.find(userId)
        }
        return nil
    }
}
