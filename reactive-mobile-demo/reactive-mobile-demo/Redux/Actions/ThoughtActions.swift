
import ReSwift
import ReSwiftThunk

enum ThoughtsRequestPayload {
    case loading
    case error(String)
    case success
}

enum LoadedThoughtsPayload {
    case initial(thoughts: [Thought])
    case update(thoughts: [Thought], deletions: [Int], insertions: [Int], modifications: [Int])
    case error(Error)
}

struct FetchThoughts: Action {
    let payload: ThoughtsRequestPayload
}

struct CreateThought: Action {
    let payload: ThoughtsRequestPayload
}

struct LoadedThoughts: Action {
    let payload: LoadedThoughtsPayload
}

func fetchThoughtsAction() -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in
        dispatch(FetchThoughts(payload: .loading))

        guard let token = getState()?.authState.jwtToken() else {
            dispatch(FetchThoughts(payload: .error("User is not logged in")))
            return
        }

        SharedAPI.fetchThoughts(token: token)
            .onSuccess({ data in
                data.jsonArray.forEach { Thought(value: $0).save() }
                dispatch(FetchThoughts(payload: .success))
            })
            .onFailure({ error in
                dispatch(FetchThoughts(payload: .error(error.userMessage)))
            })
    }
}

func createThoughtAction(text: String) -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in
        dispatch(CreateThought(payload: .loading))

        guard let token = getState()?.authState.jwtToken() else {
            dispatch(FetchThoughts(payload: .error("User is not logged in")))
            return
        }

        guard let user = getState()?.authState.currentUser() else {
            dispatch(FetchThoughts(payload: .error("User is not logged in")))
            return
        }

        // Persist the thought locally
        Thought(value: ["text" : text, "by" : user.username, "timestamp": Date()]).save()

        SharedAPI.createThought(token: token, text: text)
            .onSuccess({ data in
                dispatch(CreateThought(payload: .success))
            })
            .onFailure({ error in
                dispatch(CreateThought(payload: .error(error.userMessage)))
            })
    }
}
