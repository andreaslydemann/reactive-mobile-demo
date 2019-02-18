
import RealmSwift

class Thought: AppModel {
    @objc dynamic var id: Int = -1
    @objc dynamic var text: String = ""
    @objc dynamic var by: String = ""
    @objc dynamic var timestamp: Date = Date()

    override class func primaryKey() -> String {
        return "id"
    }
}
