
import UIKit

protocol Router: NSObject {
    var navigationController: UINavigationController { get }
    var finishFlow: (() -> Void)? { get set }
    
    func start()
}
