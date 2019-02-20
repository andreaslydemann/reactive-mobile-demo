
import UIKit

extension UIColor {
    static var stringColorMap: [String: UIColor] = [:]

    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 0.1)
    }

    class func colorForString(_ text: String) -> UIColor {
        if stringColorMap[text] == nil {
            stringColorMap[text] = .random()
        }

        return stringColorMap[text]!
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
