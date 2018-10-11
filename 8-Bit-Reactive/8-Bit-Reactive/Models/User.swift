
import UIKit

class User: GameObject {
    @objc dynamic var name = ""
    @objc dynamic var score = 0

    func destroy() {
        
    }

    override static func primaryKey() -> String? {
        return "name"
    }
}
