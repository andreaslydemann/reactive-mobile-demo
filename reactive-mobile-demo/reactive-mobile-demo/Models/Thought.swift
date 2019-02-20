
import RealmSwift

class Thought: AppModel {
    @objc dynamic var text: String = ""
    @objc dynamic var by: String = ""
    @objc dynamic var timestamp: Date = Date()
    @objc dynamic var id: String = UUID().uuidString

    override class func primaryKey() -> String {
        return "id"
    }

    class func find(by: String, text: String) -> Thought? {
        let realm = try! Realm()
        return realm.objects(Thought.self)
            .filter("text ==[c] %@ AND by ==[c] %@", text, by)
            .first
    }
}
