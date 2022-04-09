
import UIKit

extension AuthRouter {
    enum Route {
        case signIn(navigationDelegate: SignInControllerNavigationDelegate)
        case signUp(navigationDelegate: SignUpControllerNavigationDelegate)
        
        var instance: UIViewController {
            switch self {
            case let .signIn(navigationDelegate):
                let viewModel = SignInViewModel()
                let controller = SignInController(viewModel: viewModel)
                controller.navigationDelegate = navigationDelegate
                
                return controller
                
            case let .signUp(navigationDelegate):
                let viewModel = SignUpViewModel()
                let controller = SignUpController(viewModel: viewModel)
                controller.navigationDelegate = navigationDelegate
                
                return controller
            }
        }
    }
}
