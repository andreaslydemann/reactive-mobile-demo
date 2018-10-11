
import RealmSwift

class DB {
    private static var realm = try! Realm()

    class func destroy(_ obj: Object) {
        DB.realm.delete(obj)
    }

    class func save(_ obj: Object) {
        DB.realm.add(obj, update: true)
    }
}
