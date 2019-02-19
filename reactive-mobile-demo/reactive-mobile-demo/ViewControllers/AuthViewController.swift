import UIKit
import ReSwift

class AuthViewController: UIViewController, StoreSubscriber, UITextFieldDelegate {
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loadingSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Ensure password field stays blank
        self.passwordTextField.text = ""

        store.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if store.state.authState.loggedIn() {
            self.goToThoughtsList()
        }
    }

    func newState(state: AppState) {
        let authState = state.authState

        if authState.loading {
            self.loadingSpinner.startAnimating()
        } else {
            self.loadingSpinner.stopAnimating()
        }

        if let error = authState.authError {
            // Auth Failure
            alertError(error)

        } else if authState.loggedIn() {
            // Auth Success
            goToThoughtsList()
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        let username = self.usernameTextField.text!
        let password = self.passwordTextField.text!
        let action = loginAction(username: username, password: password)
        store.dispatch(action)
    }

    @IBAction func registerPressed(_ sender: Any) {
        let username = self.usernameTextField.text!
        let password = self.passwordTextField.text!
        let action = createUserAction(username: username, password: password)
        store.dispatch(action)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func alertError(_ message: String) {
        let alertController = UIAlertController(title: "An Error Occurred",
                                                message: message,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }

    func goToThoughtsList() {
        self.performSegue(withIdentifier: "showThoughtsSegue", sender: self)
    }

    @IBAction func logoutSegue(segue: UIStoryboardSegue) {
        store.dispatch(createLogoutAction())
    }
}
