
import UIKit

class AppRouter: BaseRouter {
    override func start() {
        let router: Router
        
        if UserService.sharedInstance.isLoggedIn {
            router = Route.main(navigationController: navigationController, delegate: self).instance
        } else {
            router = Route.authorization(navigationController: navigationController, delegate: self).instance
        }
        
        router.finishFlow = { [unowned self, unowned router] in
            self.removeChild(router)
        }
        
        addChild(router)
        router.start()
    }
}

//AuthRouter delegate
extension AppRouter: AuthRouterDelegate {
    func authRouterDidFinishAuthorization() {
        let router = Route.main(navigationController: navigationController, delegate: self).instance
        
        router.finishFlow = { [unowned self, unowned router] in
            self.removeChild(router)
        }
        
        addChild(router)
        router.start()
    }
}

//MainRouter delegate
extension AppRouter: MainRouterDelegate {
    func mainRouterDidSignOut() {
        let router = Route.authorization(navigationController: navigationController, delegate: self).instance
        
        router.finishFlow = { [unowned self, unowned router] in
            self.removeChild(router)
        }
        
        addChild(router)
        router.start()
    }
}
