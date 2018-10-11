
import Darwin
import SpriteKit
import ARKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        // Setup your scene here
    }
    
    override func update(_ currentTime: TimeInterval) {
        shadeSprites()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sceneView = self.view as? ARSKView else { return }

        if let currentFrame = sceneView.session.currentFrame {
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -3
            let transform = simd_mul(currentFrame.camera.transform, translation)

            let anchor = Anchor(transform: transform)
            if Int.random(in: 0...1) == 0 {
                anchor.type = .greenBug
            } else {
                anchor.type = .purpleBug
            }
            sceneView.session.add(anchor: anchor)
        }
    }

    func shadeSprites() {
        guard   let sceneView = self.view as? ARSKView,
                let currentFrame = sceneView.session.currentFrame,
                let lightEstimate = currentFrame.lightEstimate else { return }

        let neutralIntensity: CGFloat = 1000
        let ambientIntensity = min(lightEstimate.ambientIntensity,
                                   neutralIntensity)
        let blendFactor = 1 - (ambientIntensity / neutralIntensity)

        for node in children {
            if let bug = node as? SKSpriteNode {
                bug.color = .black
                bug.colorBlendFactor = blendFactor
            }
        }
    }
}
