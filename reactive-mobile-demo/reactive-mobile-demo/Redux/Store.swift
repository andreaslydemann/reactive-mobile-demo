
import RealmSwift
import ReSwift
import ReSwiftThunk

let store = Store(
    reducer: mainReducer,
    state: loadAppState(),
    middleware: [createThunksMiddleware()])

fileprivate func loadAppState() -> AppState {
    var state = AppState()

    // We can derive all the relevant app state by just checking if there is a saved user
    let realm = try! Realm()
    let users = realm.objects(User.self)
    if let user = users.first {
        state.authState.currentUserId = user.id
    }

    return state
}
