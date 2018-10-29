
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
        super.init(baseURL: "http://23.96.36.192")
    }

    /* MARK: - API Client Functions */

    func syncSessionUser(_ name: String) {
        sessionUser.withParam("name", name).request(.get)
            .onSuccess { (response) in User(value:response.jsonDict).save() }
            .onFailure{ (error) in print("Error syncing user session: \(error)") }
    }

    func submitScore(_ name: String, score: Int) {
        submitScore.request(.post, json: ["name": name, "score": String(describing: score)])
            .onSuccess { (response) in UserHighScore(value: response.jsonDict).save() }
            .onFailure { (error) in print("Error submitting score! \(error)") }
    }

    func getScoreBoard() {
        scoreBoard.request(.get)
            .onSuccess { (response) in
                response.jsonArray.forEach {
                    UserHighScore(value: ($0 as! [AnyHashable: Any])).save()
                }
            }
            .onFailure { (error) in print("Error fetcing scoreboard: \(error)") }
    }

    func fetchGreenBugConfig(_ score: Int) {
        greenBugs.withParam("score", String(describing:score)).request(.get)
            .onSuccess { (response) in
                if let greenBugs = response.jsonDict["green_bugs"] as? Int {
                    GameSessionManager.shared.greenBugCount = greenBugs
                }
            }
            .onFailure { (error) in print("Error submitting score! \(error)") }
    }
}
