
import Siesta

class API: Service {
    init() {
        super.init(baseURL: "http://52.136.224.178")
    }

    var login:      Resource { return resource("/users/authenticate") }
    var users:      Resource { return resource("/users") }
    var thoughts:   Resource { return resource("/thoughts") }

    func signUp(username: String, password: String) {
        auth(resource: users, username: username, password: password)
    }

    func login(username: String, password: String) {
        auth(resource: login, username: username, password: password)
    }

    func auth(resource: Resource, username: String, password: String) {
        store.dispatch(AuthProgress(loginState: .loading))

        resource.request(.post, json: ["username": username, "password": password])
            .onSuccess { _ in

                let json = resource.jsonDict
                guard let token = json["auth_token"] as? String else {
                    store.dispatch(AuthProgress(loginState: .error("No token received")))
                    return
                }

                let user: User = User(value: ["username" : username]).save()
                store.dispatch(AuthProgress(loginState: .success(user: user, token: token)))
            }
            .onFailure { error in
                store.dispatch(AuthProgress(loginState: .error(error.userMessage)))
        }
    }
}

let SharedAPI = API()
