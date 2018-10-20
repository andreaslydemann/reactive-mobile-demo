
import UIKit

class GameSessionManager: NSObject {
    static var shared = GameSessionManager()
    private var currentUser: User? = nil

    /* Game Config */
    var greenBugCount = 0

    func initialize() {
        /* Destroy all users */
        DB.findAll(User.self).forEach( { $0.destroy() } )
    }

    func increaseScore(by increment: Int = 1) {
        if let user = self.currentUser {
            DB.transaction {
                user.score += increment
                if user.score > user.high_score {
                    user.high_score = user.score
                }
            }
        }
    }

    func doDamage(_ amount: Int = 1) {
        if let user = self.currentUser {
            DB.transaction {
                user.health = max(user.health - amount, 0)
            }
        }
    }

    func registerUser(_ name: String) {
        /*
            Depending on the application needs, we could instead choose to await the callback of
            the API call and bubble up an appropriate error. However, for this app,
            we'll just register the user locally and attempt to synchronize the user with
            the server in the background.
         */
        APIClient.shared.syncSessionUser(name)
        User(value: ["name" : name]).save()
    }

    func startSession(forUser user: User) {
        /* Destroy any other user that may exist */
        DB.findAll(User.self).forEach { if $0.name != user.name { $0.destroy() } }

        self.currentUser = user
        DB.transaction {
            user.health = User.DefaultMaxHealth
        }

        /* Reset game config */
        self.greenBugCount = 0
    }

    func highestScore() -> Int {
        let scores = DB.findAll(UserHighScore.self).sorted(byKeyPath: "score")
        if let highest = scores.last {
            return highest.score
        }
        return 0
    }

    func submitScore() {
        if let user = self.currentUser {
            // Ensure user score is saved locally if necessary
            self.updateLocalUserHighScore()

            // Submit score to server and fetch green bug config (which varies based on score)
            APIClient.shared.submitScore(user.name, score: user.score)
            APIClient.shared.fetchGreenBugConfig(user.score)
        }
    }

    func updateLocalUserHighScore() {
        if let user = self.currentUser {
            let pred = NSPredicate(format: "name = %@", user.name)

            if let userHighScore = DB.findAll(UserHighScore.self).filter(pred).first {
                if user.score >= userHighScore.score {
                    DB.transaction { userHighScore.score = user.score }
                }
            } else {
                UserHighScore(value: ["name" : user.name, "score" : user.score ]).save()
            }
        }
    }

    func getCurrentUser() -> User? {
        return currentUser
    }

    func clearSession() {
        DB.findAll(User.self).forEach { $0.destroy() }  // Destroy existing user(s)
        self.currentUser = nil
    }
}
