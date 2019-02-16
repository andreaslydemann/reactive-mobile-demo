import RealmSwift

class User: AppModel {
    @objc dynamic var username: String = ""

    override static func primaryKey() -> String {
        return "username"
    }
}
