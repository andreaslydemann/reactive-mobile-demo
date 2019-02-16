
import ReSwift
import ReSwiftThunk

let thunksMiddleware: Middleware<AppState> = createThunksMiddleware()

let store = Store(
    reducer: mainReducer,
    state: AppState(),
    middleware: [thunksMiddleware])
