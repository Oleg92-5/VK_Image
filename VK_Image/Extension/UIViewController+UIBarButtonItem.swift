
import UIKit

extension UIViewController {
    
    func createBarButtom(selector: Selector, image: String, color: UIColor) -> UIBarButtonItem {
        let image = image
        let color = color
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: image), for: .normal)
        button.tintColor = color
        button.addTarget(self, action: selector, for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }
    
}
