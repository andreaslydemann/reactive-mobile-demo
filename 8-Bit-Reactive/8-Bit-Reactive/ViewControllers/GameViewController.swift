
import UIKit
import SpriteKit
import ARKit

class GameViewController: UIViewController, ARSKViewDelegate {
    
    @IBOutlet var sceneView: ARSKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self

        sceneView.showsFPS = true
        sceneView.showsNodeCount = true

        if let scene = SKScene(fileNamed: "GameScene") {
            sceneView.presentScene(scene)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // MARK: - ARSKViewDelegate
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        guard let anchor = anchor as? Anchor else { return nil }
        return SKSpriteNode(imageNamed: anchor.type.rawValue)
//
//        let labelNode = SKLabelNode(text: "👾")
//        labelNode.horizontalAlignmentMode = .center
//        labelNode.verticalAlignmentMode = .center
//        return labelNode;
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        print("Session failed with error: \(error)")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        print("Session interrupted. How rude!")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        print("Session interruption ended. Well it's about time!")
    }
}
