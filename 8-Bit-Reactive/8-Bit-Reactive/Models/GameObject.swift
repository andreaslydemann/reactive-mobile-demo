
import RealmSwift

class GameObject: Object, Codable {
    @discardableResult func save() -> Self {
        DB.save(self)
        return self
    }
}
