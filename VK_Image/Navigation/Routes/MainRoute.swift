
import UIKit

extension MainRouter {
    enum Route {
        case photoList(navigationDelegate: PhotoListControllerNavigationDelegate)
        case userList(navigationDelegate: UserListControllerNavigationDelegate)
        case detail(navigationDelegate: DetailViewControllerNavigationDelegate)
        
        var instance: UIViewController {
            switch self {
            case let .photoList(navigationDelegate):
                let viewModel = PhotoListViewModel()
                let controller = PhotoListController(viewModel: viewModel)
                controller.navigationDelegate = navigationDelegate
                
                return controller
                
            case let .userList(navigationDelegate):
                let viewModel = UserListViewModel()
                let controller = UserListController(viewModel: viewModel)
                controller.navigationDelegate = navigationDelegate
                
                return controller
                
            case let .detail(navigationDelegate):
                let viewModel = DetailViewModel()
                let controller = DetailViewController(viewModel: viewModel)
                controller.navigationDelegate = navigationDelegate
                
                return controller
            }
        }
    }
}
