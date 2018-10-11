
import RealmSwift

class UserHighScore: Object, Codable {
    @objc dynamic var name = ""
    @objc dynamic var highScore = 0
}
