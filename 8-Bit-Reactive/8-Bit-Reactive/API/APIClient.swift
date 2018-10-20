
import Siesta
import RealmSwift

class APIClient: Service {
    static let shared = APIClient()

    /* API Endpoints */
    private var gameSession: Resource { return resource("/game_session") }
    private var sessionUser: Resource { return gameSession.child("user") }
    private var greenBugs: Resource { return gameSession.child("green_bugs") }
    private var scoreBoard: Resource { return gameSession.child("score_board") }
    private var submitScore: Resource { return gameSession.child("submit_score") }

    init() {
        super.init(baseURL: "http://172.20.10.3:3000")
        setupObservers()
    }

    /* MARK: - API Client Functions */
    func getScoreBoard() {
        scoreBoard.loadIfNeeded()
    }

    func fetchGreenBugConfig(_ score: Int) {
        greenBugs.withParam("score", String(describing:score)).loadIfNeeded()
    }

    func syncSessionUser(_ name: String) {
        sessionUser.withParam("name", name).loadIfNeeded()
    }

    func submitScore(_ name: String, score: Int) {
        submitScore.request(.post, json: ["name": name, "score": String(describing: score)])
            .onSuccess { (response) in UserHighScore(value: response.jsonDict).save() }
            .onFailure { (error) in print("Error submitting score! \(error)") }
    }

    /* MARK: - Realm Observers */
    private func setupObservers() {
        scoreBoard.addObserver(owner: self) { resource, event in
            if case .newData = event {
                let scoreBoard = resource.jsonArray
                let highScores = scoreBoard.map { UserHighScore(value: ($0 as! [AnyHashable: Any])) }
                highScores.forEach { $0.save() }
            }
        }

        sessionUser.addObserver(owner: self) { resource, event in
            if case .newData = event {
                User(value:resource.jsonDict).save()
            }
        }

        greenBugs.addObserver(owner: self) { resource, event in
            if case .newData = event {
                let bugConfig = resource.jsonDict
                if let greenBugs = bugConfig["green_bugs"] as? Int {
                    GameSessionManager.shared.greenBugCount = greenBugs
                }
            }
        }
    }
}
