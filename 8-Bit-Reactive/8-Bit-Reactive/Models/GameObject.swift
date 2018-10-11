
import RealmSwift

class GameObject: Object, Codable {
    class func fromJson(_ jsonData: Data) -> Self {
        let jsonDecoder = JSONDecoder()
        return try! jsonDecoder.decode(self, from: jsonData)
    }

    func save() -> Self {
        DB.save(self)
        return self
    }
}
