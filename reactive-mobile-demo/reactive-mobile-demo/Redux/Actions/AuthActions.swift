
import RealmSwift
import ReSwift
import ReSwiftThunk

enum AuthProgressPayload {
    case error(String)
    case success(user: User)
    case loading
    case logout
}

struct AuthProgress: Action {
    let payload: AuthProgressPayload
}

func createLogoutAction() -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in

        // Crude way to logout - flush the whole database
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        
        dispatch(AuthProgress(payload: .logout))
    }
}

func createUserAction(username: String, password: String) -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in
        SharedAPI.signUp(username: username, password: password)
            .onSuccess { data in
                authSuccess(json: data.jsonDict, username: username, dispatch: dispatch)
            }
            .onFailure { error in
                let errorMsg = error.entity?.jsonDict["error"] as? String ?? error.userMessage
                dispatch(AuthProgress(payload: .error(errorMsg)))
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
                let errorMsg = error.entity?.jsonDict["error"] as? String ?? error.userMessage
                dispatch(AuthProgress(payload: .error(errorMsg)))
        }
    };
}

fileprivate
func authSuccess(json: [String: Any], username: String, dispatch: DispatchFunction) {
    guard let token = json["auth_token"] as? String else {
        dispatch(AuthProgress(payload: .error("No token received")))
        return
    }

    guard let id = json["user_id"] as? Int else {
        dispatch(AuthProgress(payload: .error("No userId received")))
        return
    }

    let user: User = User(value: ["username": username, "id": id, "jwtToken": token]).save()
    dispatch(AuthProgress(payload: .success(user: user)))
}
