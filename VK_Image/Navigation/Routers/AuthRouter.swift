
import UIKit

class AuthRouter: BaseRouter {
    weak var delegate: AuthRouterDelegate?
    
    override func start() {
        let controller = Route.signIn(navigationDelegate: self).instance
        navigationController.setViewControllers([controller], animated: true)
    }
}

//SignInController navigation delegate
extension AuthRouter: SignInControllerNavigationDelegate {
    func signInControllerOpenSignUp() {
        let controller = Route.signUp(navigationDelegate: self).instance
        navigationController.pushViewController(controller, animated: true)
    }
    
    func signInControllerDidFinishSignIn() {
        delegate?.authRouterDidFinishAuthorization()
        finishFlow?()
    }
}

//SignUpController navigation delegate
extension AuthRouter: SignUpControllerNavigationDelegate {
    func signUpControllerDidFinishSignUp() {
        delegate?.authRouterDidFinishAuthorization()
        finishFlow?()
    }
}
