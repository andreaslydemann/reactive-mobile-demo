import ReSwift

func mainReducer(action: Action, state: AppState?) -> AppState {
    return AppState(
        authState: authReducer(action: action, state: state),
        thoughts: thoughtsReducer(action: action, state: state)
    )
}
