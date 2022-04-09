
import Foundation
import Photos
import UIKit

class ImageModel {
    var asset: PHAsset
    var previewImage: UIImage? = nil
    var imageRequestId: PHImageRequestID? = nil
    
    init(asset: PHAsset) {
        self.asset = asset
    }
}
