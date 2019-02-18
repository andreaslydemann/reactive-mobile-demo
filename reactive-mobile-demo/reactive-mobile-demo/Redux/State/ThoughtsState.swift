
import ReSwift

struct ThoughtsState: StateType {
    var loading: Bool = false
    var lastError: String? = nil
    var thoughtIds: [Int] = []
    var deletionIndexes: [Int] = []
    var insertionIndexes: [Int] = []
    var modificationIndexes: [Int] = []
}
