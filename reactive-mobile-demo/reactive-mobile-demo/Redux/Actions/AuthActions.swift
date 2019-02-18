
import ReSwift
import ReSwiftThunk

enum AuthProgressPayload {
    case error(String)
    case success(user: User, token: String)
    case loading
}

struct AuthProgress: Action {
    let payload: AuthProgressPayload
}

func createUserAction(username: String, password: String) -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in
        SharedAPI.signUp(username: username, password: password)
            .onSuccess { data in
                authSuccess(json: data.jsonDict, username: username, dispatch: dispatch)
            }
            .onFailure { error in
                dispatch(AuthProgress(payload: .error(error.userMessage)))
        }
    }
}

func loginAction(username: String, password: String) -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in
        dispatch(AuthProgress(payload: .loading))

        SharedAPI.login(username: username, password: password)
            .onSuccess { data in
                authSuccess(json: data.jsonDict, username: username, dispatch: dispatch)
            }
            .onFailure { error in
                dispatch(AuthProgress(payload: .error(error.userMessage)))
        }
    };
}

fileprivate
func authSuccess(json: [String: Any], username: String, dispatch: DispatchFunction) {
    guard let token = json["auth_token"] as? String else {
        dispatch(AuthProgress(payload: .error("No token received")))
        return
    }

    let user: User = User(value: ["username" : username]).save()
    dispatch(AuthProgress(payload: .success(user: user, token: token)))
}
