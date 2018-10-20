
import UIKit

class User: GameObject {
    static let DefaultMaxHealth: Int = 3

    @objc dynamic var name: String = ""
    @objc dynamic var score: Int = 0
    @objc dynamic var health: Int = User.DefaultMaxHealth
    @objc dynamic var high_score: Int = 0 // Forgive the snake casing

    func destroy() {
        DB.destroy(self)
    }

    override static func primaryKey() -> String? {
        return "name"
    }
}
