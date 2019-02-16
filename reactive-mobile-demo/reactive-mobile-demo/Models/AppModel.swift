
import RealmSwift

class AppModel: Object {
    func save() -> Self {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self, update: true)
        }
        return self
    }
}
