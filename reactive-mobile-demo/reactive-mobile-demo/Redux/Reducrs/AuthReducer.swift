
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
    newAuthState.currentUserId = oldAuthState.currentUserId

    switch authProgress.payload {
        case .error(let msg):
            newAuthState.authError = msg
            break

        case .success(let user):
            newAuthState.currentUserId = user.id
            break

        case .loading:
            newAuthState.loading = true
            break

        case .logout:
            // All info is cleared, return empty auth state
            return AuthState()
    }

    return newAuthState
}
