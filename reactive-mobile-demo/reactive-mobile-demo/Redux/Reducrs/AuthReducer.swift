
import ReSwift

func authReducer(action: Action, state: AppState?) -> AuthState {
    switch action {
        case let authProgress as AuthProgress:
            return authProgressReducer(authProgress: authProgress, state: state)

        default:
            return state?.authState ?? AuthState()
    }
}

fileprivate
func authProgressReducer(authProgress: AuthProgress, state: AppState?) -> AuthState {
    let oldAuthState = state?.authState ?? AuthState()
    var newAuthState = AuthState()

    newAuthState.jwtToken = oldAuthState.jwtToken
    newAuthState.currentUser = oldAuthState.currentUser

    switch authProgress.payload {
        case .error(let msg):
            newAuthState.authError = msg
            break

        case .success(let user, let token):
            newAuthState.currentUser = user
            newAuthState.jwtToken = token
            newAuthState.authError = nil
            break

        case .loading:
            newAuthState.loading = true
            break
    }

    return newAuthState
}
