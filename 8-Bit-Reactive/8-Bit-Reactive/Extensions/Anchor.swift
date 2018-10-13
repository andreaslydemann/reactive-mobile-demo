
import ARKit

enum AnchorType: String {
    case greenBug
    case purpleBug
}

class Anchor: ARAnchor {
    var type: AnchorType = .purpleBug
}
