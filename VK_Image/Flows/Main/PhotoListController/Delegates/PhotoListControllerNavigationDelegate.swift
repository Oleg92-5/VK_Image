
import Foundation

protocol PhotoListControllerNavigationDelegate: AnyObject {
    func photoListControllerOpenUsepList()
    func photoListControllerDidSignOut()
    func photoListControllerOpenDetailView()
}

