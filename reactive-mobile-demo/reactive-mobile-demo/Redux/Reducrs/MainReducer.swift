import ReSwift

func mainReducer(action: Action, state: AppState?) -> AppState {

    /* Logout clears the entire app state */
    if AuthProgress.isLogout(action) {
        return AppState()
    }

    /* Otherwise, recalculate as normal */
    return AppState(
        authState: authReducer(action: action, state: state),
        thoughtsState: thoughtsReducer(action: action, state: state)
    )
}
