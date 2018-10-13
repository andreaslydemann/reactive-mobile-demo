
import UIKit

class User: GameObject {
    static let DefaultMaxHealth = 3

    @objc dynamic var name = ""
    @objc dynamic var score = 0
    @objc dynamic var health = User.DefaultMaxHealth
    @objc dynamic var high_score = 0 // Forgive the snake casing

    func destroy() {
        DB.destroy(self)
    }

    override static func primaryKey() -> String? {
        return "name"
    }
}
