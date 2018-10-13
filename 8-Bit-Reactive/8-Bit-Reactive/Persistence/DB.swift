
import RealmSwift

class DB: NSObject {
    static var shared = DB()
    static private let schemaVersion:UInt64 = 2
    private let realm: Realm;

    override init() {
        let config = Realm.Configuration(
            schemaVersion: DB.schemaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < DB.schemaVersion) {
                    // Nothing to do!
                }
        })
        Realm.Configuration.defaultConfiguration = config
        realm = try! Realm()

        super.init()
    }

    class func transaction(_ block: () -> Void) {
        if DB.shared.realm.isInWriteTransaction {
            block()
        } else {
            try! DB.shared.realm.write(block)
        }
    }

    class func findAll<T:Object>(_ type: T.Type) -> Results<T>  {
        return DB.shared.realm.objects(type)
    }

    class func destroy(_ obj: Object) {
        if DB.shared.realm.isInWriteTransaction {
            DB.shared.realm.delete(obj)
        } else {
            try! DB.shared.realm.write {
                DB.shared.realm.delete(obj)
            }
        }
    }

    class func save(_ obj: Object) {
        if DB.shared.realm.isInWriteTransaction {
            DB.shared.realm.add(obj, update: true)
        } else {
            try! DB.shared.realm.write {
                DB.shared.realm.add(obj, update: true)
            }
        }
    }
}
