import RealmSwift

class User: AppModel {
    @objc dynamic var id: Int = -1
    @objc dynamic var jwtToken: String = ""
    @objc dynamic var username: String = ""

    override static func primaryKey() -> String {
        return "id"
    }
}
