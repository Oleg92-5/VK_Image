
import UIKit

extension UIColor {
    var image: UIImage {
        let imageRenderer = UIGraphicsImageRenderer(size: .init(width: 1.0, height: 1.0))
        return imageRenderer.image { ctx in
            self.setFill()
            ctx.fill(.init(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        }
    }
}
