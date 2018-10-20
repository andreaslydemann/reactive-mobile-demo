
import UIKit
import SpriteKit
import RealmSwift
import ARKit

class GameViewController: UIViewController, ARSKViewDelegate {
    
    @IBOutlet var sceneView: ARSKView!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var healthLabel: UILabel!
    @IBOutlet var gameOverView: UIView!

    private var currentUserNotificationToken: NotificationToken? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.delegate = self
        self.gameOverView.isHidden = true /* Hidden by default... until you lose! */

        /* Debugging Views */
        self.sceneView.showsFPS = true
        self.sceneView.showsNodeCount = true

        if let scene = SKScene(fileNamed: "GameScene") {
            self.sceneView.presentScene(scene)
        }

        self.setupObservers()
    }

    deinit {
        self.teardownObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        self.sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.sceneView.session.pause()
    }

    private func userUpdated(change: ObjectChange) {
        switch change {
        case .deleted:
            self.teardownObservers()
            break

        case .change(let changes):
            let changeNames = changes.map { $0.name }
            if changeNames.contains("score") { self.updateScoreLabel() }
            if changeNames.contains("health") { self.updateHealthLabel() }

            GameSessionManager.shared.submitScore()
            break

        case .error(let error):
            print("Error receiving updates for user: \(error)")
        }
    }

    private func updateScoreLabel() {
        guard let user = GameSessionManager.shared.getCurrentUser() else { return }
        if user.score >= GameSessionManager.shared.highestScore() {
            self.scoreLabel.text = "New High Score: \(user.score)"
        } else {
            self.scoreLabel.text = "Score: \(user.score)"
        }
    }

    private func updateHealthLabel() {
        guard let user = GameSessionManager.shared.getCurrentUser() else { return }
        self.healthLabel.text = "Health: \(user.health)"

        if user.health == 0 {
            self.gameOver()
        }
    }

    private func gameOver() {
        self.sceneView.session.pause()
        self.gameOverView.isHidden = false
        GameSessionManager.shared.submitScore()
    }
    
    // MARK: - ARSKViewDelegate
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        guard let anchor = anchor as? Anchor else { return nil }
        return SKSpriteNode(imageNamed: anchor.type.rawValue)
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

    @IBAction func goHome(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegue", sender: self)
    }

    /* MARK: - Realm Observers */
    func setupObservers() {
        if let user = GameSessionManager.shared.getCurrentUser() {
            self.currentUserNotificationToken = user.observe(userUpdated)
        }
    }

    func teardownObservers() {
        self.currentUserNotificationToken?.invalidate()
        self.currentUserNotificationToken = nil
    }
}
