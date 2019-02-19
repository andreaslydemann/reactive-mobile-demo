
import ReSwift

let loggerMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            print("Action: \(action)")
            return next(action)
        }
    }
}
