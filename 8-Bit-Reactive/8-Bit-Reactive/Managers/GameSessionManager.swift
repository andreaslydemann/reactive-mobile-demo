
import UIKit

class GameSessionManager: NSObject {
    static var shared = GameSessionManager()
    private var currentUser: User? = nil

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

    func startSession(forUser user: User) {
        self.clearSession()
        self.currentUser = user
        DB.transaction {
            user.health = User.DefaultMaxHealth
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
