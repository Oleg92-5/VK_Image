
import UIKit

class BaseRouter: NSObject, Router {
    var navigationController: UINavigationController
    
    private var children: [Router] = []
    var finishFlow: (() -> Void)?
    
    deinit {
        print("DEALLOCATED: \(String(describing: self))")
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
}

extension BaseRouter {
    func addChild(_ router: Router) {
        guard !children.contains(where: { $0 == router }) else { return }
        
        children.append(router)
    }
    
    func removeChild(_ router: Router) {
        children.removeAll(where: { $0 == router })
    }
}
