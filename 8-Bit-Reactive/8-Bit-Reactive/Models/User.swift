
/*
    Singleton User object
 */

import RealmSwift

class User: GameObject {
    static let SessionUserID = "com.8-bit.user-id"

    static let DefaultMaxHealth: Int = 3

    @objc dynamic var id: String = User.SessionUserID
    @objc dynamic var name: String = ""
    @objc dynamic var score: Int = 0
    @objc dynamic var health: Int = User.DefaultMaxHealth
    @objc dynamic var high_score: UserHighScore? = nil

    func destroy() {
        DB.destroy(self)
    }

    override static func primaryKey() -> String? {
        return "id"
    }

    class func current() -> Results<User> {
        return DB.findAll(User.self).filter("id = %@", SessionUserID)
    }
}
