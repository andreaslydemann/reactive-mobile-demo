
import Darwin
import SpriteKit
import ARKit

class GameScene: SKScene {
    static let AddPurpleBugInterval: TimeInterval = 1
    static let AddGreenBugInterval: TimeInterval = 5
    static let BugApproachDuration = 4.0
    static let BugScaleMax: CGFloat = 2.0
    static let BugPauseDuration = 1.0
    static let BugRandXRange: Float = 3.0
    static let BugStartZPosition: Float = 5.0
    private var addPurpleBugTimer:Timer?
    private var addGreenBugTimer:Timer?
    
    override func didMove(to view: SKView) {
        addPurpleBugTimer = Timer.scheduledTimer(withTimeInterval: GameScene.AddGreenBugInterval, repeats: true, block: { (timer) in
            guard   let sceneView = self.view as? ARSKView,
                    let currentFrame = sceneView.session.currentFrame else { return }
            self.addBug(currentFrame, sceneView: sceneView)
        });

        // Fire once immediately
        addPurpleBugTimer?.fire()

        addGreenBugTimer = Timer.scheduledTimer(withTimeInterval: GameScene.AddPurpleBugInterval, repeats: true, block: { (timer) in
            guard   let sceneView = self.view as? ARSKView,
                let currentFrame = sceneView.session.currentFrame else { return }

            for _ in (0...GameSessionManager.shared.greenBugCount) {
                self.addBug(currentFrame, sceneView: sceneView, type: .greenBug)
            }
        });
    }

    override func update(_ currentTime: TimeInterval) {
        guard   let sceneView = self.view as? ARSKView,
                let currentFrame = sceneView.session.currentFrame else { return }

        shadeSprites(currentFrame)
        startBugAttackSequence(sceneView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            let hit = nodes(at: location)
            if let bug = hit.first {
                bug.removeAllActions()
                bug.run(
                    .group([
                        .run {
                            self.run(Sounds.Splat);
                            GameSessionManager.shared.increaseScore()
                        },
                        .removeFromParent()
                    ])
                )
            }
        }
    }

    private func addBug(_ currentFrame: ARFrame, sceneView: ARSKView, type: AnchorType = .purpleBug) {
        var translation = matrix_identity_float4x4

        /* Random X range w/in params; Random range of Y -0.5, 0.5, and Z of -3.0 */
        translation.columns.3.x = Float.random(in: -GameScene.BugRandXRange...GameScene.BugRandXRange)
        translation.columns.3.y = Float(drand48() - 0.5)
        translation.columns.3.z = GameScene.BugStartZPosition

        let transform = simd_mul(currentFrame.camera.transform, translation)

        let anchor = Anchor(transform: transform)
        anchor.type = type
        sceneView.session.add(anchor: anchor)
    }

    private func startBugAttackSequence(_ sceneView: ARSKView) {
        for node in children {
            if let bug = node as? SKSpriteNode, !bug.hasActions() {
                bug.run(
                    .sequence([
                        Sounds.Buzz,
                        .scale(to: GameScene.BugScaleMax, duration: GameScene.BugApproachDuration),
                        .run({ bug.setScale(GameScene.BugScaleMax) }),
                        .wait(forDuration: GameScene.BugPauseDuration),
                        .run({
                            self.run(Sounds.Ouch)
                            GameSessionManager.shared.doDamage()
                        }),
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
