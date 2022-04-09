
import UIKit

extension AppRouter {
    enum Route {
        case authorization(navigationController: UINavigationController, delegate: AuthRouterDelegate)
        case main(navigationController: UINavigationController, delegate: MainRouterDelegate)
        
        var instance: Router {
            switch self {
            case let .authorization(navigationController, delegate):
                let router = AuthRouter(navigationController: navigationController)
                router.delegate = delegate
                
                return router
                
            case let .main(navigationController, delegate):
                let router = MainRouter(navigationController: navigationController)
                router.delegate = delegate
                
                return router
            }
        }
    }
}
