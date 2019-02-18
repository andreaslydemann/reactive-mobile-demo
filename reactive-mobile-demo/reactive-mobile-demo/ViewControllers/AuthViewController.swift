import UIKit
import ReSwift

class AuthViewController: UIViewController, StoreSubscriber {
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }

    func newState(state: AppState) {

    }

    func alert(_ message: String) {
        /// TODO
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        guard let username = self.usernameTextField.text,
            let password = self.passwordTextField.text else {
            alert("Neither username nor password can be blank")
            return
        }

        store.dispatch(loginAction(username: username, password: password))
    }

    @IBAction func registerPressed(_ sender: Any) {
        guard let username = self.usernameTextField.text,
            let password = self.passwordTextField.text else {
            alert("Neither username nor password can be blank")
        }

        store.dispatch(loginAction(username: username, password: password))
    }
}
