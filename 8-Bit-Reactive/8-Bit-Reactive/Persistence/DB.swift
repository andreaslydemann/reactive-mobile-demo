
import RealmSwift

class DB {
    private static var realm = try! Realm()

    class func findAll<T:Object>(_ type: T.Type) -> Results<T>  {
        return DB.realm.objects(type)
    }

    class func destroy(_ obj: Object) {
        if realm.isInWriteTransaction {
            DB.realm.delete(obj)
        } else {
            try! DB.realm.write {
                DB.realm.delete(obj)
            }
        }
    }

    class func save(_ obj: Object) {
        if realm.isInWriteTransaction {
            DB.realm.add(obj, update: true)
        } else {
            try! DB.realm.write {
                DB.realm.add(obj, update: true)
            }
        }
    }
}
