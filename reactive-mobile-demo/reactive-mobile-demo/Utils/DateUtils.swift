
import Foundation

extension Date {
    func toFriendlyFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, HH:mm"
        return formatter.string(from: self)
    }
}
