
import Siesta

class API: Service {
    init() {
        super.init(baseURL: "http://52.136.224.178")
    }

    var login:      Resource { return resource("/authenticate") }
    var users:      Resource { return resource("/users") }
    var thoughts:   Resource { return resource("/thoughts") }

    func signUp(username: String, password: String) -> Request {
        return auth(resource: users, username: username, password: password)
    }

    func login(username: String, password: String) -> Request {
        return auth(resource: login, username: username, password: password)
    }

    func auth(resource: Resource, username: String, password: String) -> Request {
        return resource.request(.post, json: ["username": username, "password": password])
    }

    func fetchThoughts(token: String, filter: String?) -> Request {
        return thoughts.request(.get) {
            $0.setValue(token, forHTTPHeaderField: "Authorization")
        }
    }

    func createThought(token: String, text: String) -> Request {
        return thoughts.request(.post, json: ["text" : text]) {
            $0.setValue(token, forHTTPHeaderField: "Authorization")
        }
    }
}

let SharedAPI = API()
