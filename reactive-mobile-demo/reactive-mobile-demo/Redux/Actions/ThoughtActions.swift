
import ReSwift
import ReSwiftThunk

enum ThoughtsRequestPayload {
    case loading
    case error(String)
    case success
}

enum LoadedThoughtsPayload: StateType, Equatable {
    case initial(thoughts: [Thought])
    case update(thoughts: [Thought], deletions: [Int], insertions: [Int], modifications: [Int])
    case error(Error)

    static func == (lhs: LoadedThoughtsPayload, rhs: LoadedThoughtsPayload) -> Bool {
        switch (lhs, rhs) {
        case (.initial(let t1), .initial(let t2)):
            return t1.elementsEqual(t2)

        case (.update(let t1, let d1, let i1, let m1), .update(let t2, let d2, let i2, let m2)):
            return t1.elementsEqual(t2) &&
                d1.elementsEqual(d2) &&
                i1.elementsEqual(i2) &&
                m1.elementsEqual(m2)

        case (.error(let e1), .error(let e2)):
            return e1.localizedDescription == e2.localizedDescription

        default:
            return false
        }
    }
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
                data.jsonArray.forEach {

                    let json = $0 as! [String: Any]
                    let by = json["by"] as! String
                    let text = json["text"] as! String
                    let timestampNumber = json["timestamp"] as! TimeInterval
                    let timestamp = Date(timeIntervalSince1970: timestampNumber)

                    if Thought.find(by: by, text: text) == nil {
                        let value: [String: Any] = [
                            "by": by,
                            "text": text,
                            "timestamp": timestamp
                        ]

                        Thought(value: value).save()
                    }
                }
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
        let by = user.username
        if Thought.find(by: by, text: text) == nil {
            Thought(value: ["text" : text,
                            "by" : by,
                            "timestamp": Date()]).save()
        }

        SharedAPI.createThought(token: token, text: text)
            .onSuccess({ data in
                dispatch(CreateThought(payload: .success))
            })
            .onFailure({ error in
                // This is a crude retry mechanism.
                // It would be better to use SwiftQueue or similar

                let delayTime = DispatchTime.now() + .seconds(5)
                DispatchQueue.global().asyncAfter(deadline: delayTime, execute: {
                    DispatchQueue.main.async {
                        dispatch(createThoughtAction(text: text))
                    }
                })
                dispatch(CreateThought(payload: .error(error.userMessage)))
            })
    }
}
