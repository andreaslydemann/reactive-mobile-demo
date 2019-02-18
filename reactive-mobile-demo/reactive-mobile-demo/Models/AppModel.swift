
import Foundation
import RealmSwift

class AppModel: Object {
    @discardableResult
    func save() -> Self {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self, update: true)
        }
        return self
    }
}
