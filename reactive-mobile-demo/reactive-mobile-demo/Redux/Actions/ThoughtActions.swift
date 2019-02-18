
import ReSwift
import ReSwiftThunk

enum ThoughtsRequestPayload {
    case loading
    case error(String)
    case success
}

enum LoadedThoughtsPayload {
    case initial(thoughtIds: [Int])
    case update(thoughtIds: [Int], deletions: [Int], insertions: [Int], modifications: [Int])
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

func fetchThoughtsAction(filter: String?) -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in
        dispatch(FetchThoughts(payload: .loading))

        guard let token = getState()?.authState.jwtToken else {
            dispatch(FetchThoughts(payload: .error("User is not logged in")))
            return
        }

        SharedAPI.fetchThoughts(token: token, filter: filter)
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

        guard let token = getState()?.authState.jwtToken else {
            dispatch(CreateThought(payload: .error("User is not logged in")))
            return
        }
        SharedAPI.createThought(token: token, text: text)
            .onSuccess({ data in
                Thought(value: data.jsonDict).save()
                dispatch(CreateThought(payload: .success))
            })
            .onFailure({ error in
                dispatch(CreateThought(payload: .error(error.userMessage)))
            })
    }
}
