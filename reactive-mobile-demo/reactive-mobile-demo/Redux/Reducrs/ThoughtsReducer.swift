
import ReSwift

func thoughtsReducer(action: Action, state: AppState?) -> ThoughtsState {
    switch action {
        case let fetchThoughts as FetchThoughts:
            return thoughtsRequestActionReducer(payload: fetchThoughts.payload, state: state)

        case let createThought as CreateThought:
            return thoughtsRequestActionReducer(payload: createThought.payload, state: state)

        case let loadedThoughts as LoadedThoughts:
            return ThoughtsState(payload: loadedThoughts.payload)

        default:
            return state?.thoughtsState ?? ThoughtsState()
    }
}

fileprivate
func thoughtsRequestActionReducer(payload: ThoughtsRequestPayload, state: AppState?) -> ThoughtsState {
    
    switch payload {
        case .error(let msg):
            print("Error making thoughts request: \(msg)")
            break

        case .success:
            print("Thoughts request successful")
            break

        case .loading:
            print("Thoughts request loading...")
            break
    }

    return state?.thoughtsState ?? ThoughtsState()
}
