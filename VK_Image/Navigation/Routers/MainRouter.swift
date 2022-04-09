
import UIKit

class MainRouter: BaseRouter {
    weak var delegate: MainRouterDelegate?
    
    override func start() {
        let controller = Route.photoList(navigationDelegate: self).instance
        navigationController.setViewControllers([controller], animated: true)
    }
}

//PhotoListController navigation delegate
extension MainRouter: PhotoListControllerNavigationDelegate {
    func photoListControllerOpenUsepList() {
        let controller = Route.userList(navigationDelegate: self).instance
        navigationController.pushViewController(controller, animated: true)
    }
    
    func photoListControllerDidSignOut() {
        delegate?.mainRouterDidSignOut()
        finishFlow?()
    }
    
    func photoListControllerOpenDetailView() {
        let controller = Route.detail(navigationDelegate: self).instance
        navigationController.pushViewController(controller, animated: true)
    }
}

//UserListController navigation delegate
extension MainRouter: UserListControllerNavigationDelegate {

}

//DetailViewController navigation delegate
extension MainRouter: DetailViewControllerNavigationDelegate {

}
