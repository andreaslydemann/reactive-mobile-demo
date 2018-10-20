
import Darwin
import SpriteKit
import ARKit

class GameScene: SKScene {
    static let AddBugInterval: TimeInterval = 1
    static let BugApproachDuration = 3.0
    static let BugScaleMax: CGFloat = 2.0
    static let BugPauseDuration = 0.5
    static let BugRandXRange: Float = 5.0
    private var addBugTimer:Timer?
    
    override func didMove(to view: SKView) {
        addBugTimer = Timer.scheduledTimer(withTimeInterval: GameScene.AddBugInterval, repeats: true, block: { (timer) in
            guard   let sceneView = self.view as? ARSKView,
                    let currentFrame = sceneView.session.currentFrame else { return }
            self.addBug(currentFrame, sceneView: sceneView)
        });
        addBugTimer?.fire()
    }

    
    override func update(_ currentTime: TimeInterval) {
        guard   let sceneView = self.view as? ARSKView,
                let currentFrame = sceneView.session.currentFrame else { return }

        shadeSprites(currentFrame)
        moveBugsCloser(sceneView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sceneView = self.view as? ARSKView else { return }

        if let location = touches.first?.location(in: self) {
            let hit = nodes(at: location)
            if let bug = hit.first {
                bug.removeAllActions()
                bug.run(
                    .group([
                        .run { GameSessionManager.shared.increaseScore() },
                        .removeFromParent()
                    ])
                )
            }
        } else {
            if let currentFrame = sceneView.session.currentFrame {
                var translation = matrix_identity_float4x4
                translation.columns.3.z = -3
                let transform = simd_mul(currentFrame.camera.transform, translation)

                let anchor = Anchor(transform: transform)
                sceneView.session.add(anchor: anchor)
            }
        }
    }

    private func addBug(_ currentFrame: ARFrame, sceneView: ARSKView) {
        var translation = matrix_identity_float4x4

        /* Random X range w/in params; Random range of Y -0.5, 0.5, and Z of -3.0 */
        translation.columns.3.x = Float.random(in: -GameScene.BugRandXRange...GameScene.BugRandXRange)
        translation.columns.3.y = Float(drand48() - 0.5)
        translation.columns.3.z = -3

        let transform = simd_mul(currentFrame.camera.transform, translation)

        let anchor = Anchor(transform: transform)
        anchor.type = .purpleBug
        sceneView.session.add(anchor: anchor)
    }

    private func moveBugsCloser(_ sceneView: ARSKView) {
        for node in children {
            if let bug = node as? SKSpriteNode, !bug.hasActions() {
                bug.run(
                    .sequence([
                        .scale(to: GameScene.BugScaleMax, duration: GameScene.BugApproachDuration),
                        .run({ bug.setScale(GameScene.BugScaleMax) }),
                        .wait(forDuration: GameScene.BugPauseDuration),
                        .group([
                            .run({ GameSessionManager.shared.doDamage() }),
                            .playSoundFileNamed("", waitForCompletion: false)
                        ]),
                        .removeFromParent()
                    ])
                )
            }
        }
    }

    private func shadeSprites(_ currentFrame: ARFrame) {
        guard let lightEstimate = currentFrame.lightEstimate else { return }

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
