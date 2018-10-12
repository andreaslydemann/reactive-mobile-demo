
import Siesta
import RealmSwift

class APIClient: Service {
    static let shared = APIClient()

    /* API Endpoints */
    private var gameSession: Resource { return resource("/game_session") }
    private var startSession: Resource { return gameSession.child("start") }
    private var greenBugs: Resource { return gameSession.child("green_bugs") }
    private var scoreBoard: Resource { return gameSession.child("score_board") }
    private var submitScore: Resource { return gameSession.child("submit_score") }

    init() {
        super.init(baseURL: "http://192.168.56.109:3000")
        setupObservers()
    }

    /* API Client Functions */
    func getScoreBoard() {
        scoreBoard.loadIfNeeded()?
            .onFailure { error in print("Error fetching score board! \(error)") }
    }

    func startSession(_ name: String) {
        startSession.request(.post, json: ["name": name])
            .onFailure { error in print("Error starting session! \(error)") }
    }

    func fetchGreenBugConfig(_ score: UInt) {
        greenBugs.withParam("score", String(describing:score)).loadIfNeeded()?
            .onFailure { error in print("Error fetching green bug config! \(error)") }
    }

    func submitScore(_ name: String, score: UInt) {
        submitScore.request(.post, json: ["name": name, "score": String(describing: score)])
            .onFailure { error in print("Error submitting score! \(error)") }
    }

    private func setupObservers() {
        scoreBoard.addObserver(owner: self) { resource, event in
            if case .newData = event {
                let scoreBoard = resource.jsonArray
                let highScores = scoreBoard.map { UserHighScore(value: ($0 as! [AnyHashable: Any])) }
                highScores.forEach { $0.save() }
            }
        }

        greenBugs.addObserver(owner: self) {
            [weak self] resource, event in
            if case .newData = event {
                let greenBugConfig = resource.jsonDict
            }
        }

        startSession.addObserver(owner: self) {
            [weak self] resource, event in
            if case .newData = event {
                let sessionConfig = resource.jsonDict
            }
        }

        submitScore.addObserver(owner: self) {
            [weak self] resource, event in
            if case .newData = event {
                let submissionResult = resource.jsonDict
            }
        }
    }
}
