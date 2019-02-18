
import ReSwift

func thoughtsReducer(action: Action, state: AppState?) -> ThoughtsState {
    switch action {
        case let fetchThoughts as FetchThoughts:
            return thoughtsRequestActionReducer(payload: fetchThoughts.payload, state: state)

        case let createThought as CreateThought:
            return thoughtsRequestActionReducer(payload: createThought.payload, state: state)

        case let loadedThoughts as LoadedThoughts:
            return loadedThoughtsReducer(action: loadedThoughts, state: state)

        default:
            return state?.thoughtsState ?? ThoughtsState()
    }
}

fileprivate
func thoughtsRequestActionReducer(payload: ThoughtsRequestPayload, state: AppState?) -> ThoughtsState {
    var newThoughtsState = ThoughtsState()

    switch payload {
        case .error(let msg):
            newThoughtsState.lastError = msg
            break

        case .success:
            break

        case .loading:
            newThoughtsState.loading = true
    }

    return newThoughtsState
}

fileprivate
func loadedThoughtsReducer(action: LoadedThoughts, state: AppState?) -> ThoughtsState {
    var newThoughtsState = ThoughtsState()

    switch action.payload {
        case .initial(let thoughtIds):
            newThoughtsState.thoughtIds = thoughtIds
            break

        case .update(let thoughtIds, let deletions, let insertions, let modifications):
            newThoughtsState.thoughtIds = thoughtIds
            newThoughtsState.deletionIndexes = deletions
            newThoughtsState.insertionIndexes = insertions
            newThoughtsState.modificationIndexes = modifications
            break

        case .error(let error):
            newThoughtsState = state?.thoughtsState ?? ThoughtsState()
            newThoughtsState.lastError = error.localizedDescription
            break
    }

    return newThoughtsState
}
