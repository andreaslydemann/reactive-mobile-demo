
import RealmSwift

class UserHighScore: GameObject {
    @objc dynamic var name = ""
    @objc dynamic var score = 0

    override static func primaryKey() -> String? {
        return "name"
    }

    override static func indexedProperties() -> [String] {
        return ["score"]
    }
}
