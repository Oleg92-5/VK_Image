
import Combine
import UIKit
import Photos

class PhotoListViewModel: ObservableObject {
    //Output
    @Published private(set) var images: [ImageModel] = []
    @Published private(set) var itemIndexToReload: Int?
    @Published private(set) var imageToOpen: ImageModel?
    @Published private(set) var openUserList: Void = ()
    @Published private(set) var signOut: Void = ()
    
    //Properties
    private lazy var imageManager = PHImageManager.default()
}

//Input
extension PhotoListViewModel {
    func viewDidLoadTrigger() {
        fetchPhotos()
    }
    
    func imageTapTrigger(index: Int) {
        guard index >= 0, index < images.count else { return }
        imageToOpen = images[index]
    }
    
    func openUserTrigger() {
        openUserList = ()
    }
    
    func signOutTrigger() {
        UserService.sharedInstance.signOut()
        signOut = ()
    }
    
    func willDisplayItemAtIndexTrigger(index: Int) {
        fetchImage(at: index)
    }
    
    func didEndDisplayingItemAtIndexTrigger(index: Int) {
        cancelFetchRequestForItemAtIndex(index)
    }
}

//Private
private extension PhotoListViewModel {
    func fetchPhotos() {
        DispatchQueue.global(qos: .background).async {
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.deliveryMode = .highQualityFormat
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            var images = [ImageModel]()
            for i in 0..<fetchResult.count {
                let asset = fetchResult.object(at: i) as PHAsset
                images.append(.init(asset: asset))
            }
            
            self.images = images
        }
    }
    
    func fetchImage(at index: Int) {
        guard index >= 0, index < images.count else { return }
        let imageModel = images[index]
        
        guard imageModel.previewImage == nil else { return }
        
        DispatchQueue.global(qos: .utility).async {
            imageModel.imageRequestId = self.imageManager.requestImage(for: imageModel.asset,
                                                                          targetSize: .init(width: 512, height: 512),
                                                                          contentMode: .aspectFill,
                                                                          options: nil,
                                                                          resultHandler: { [weak self] image, _ in
                guard let self = self, let image = image else { return }
                
                imageModel.previewImage = image
                self.itemIndexToReload = index
            })
        }
    }
    
    func cancelFetchRequestForItemAtIndex(_ index: Int) {
        guard index >= 0, index < images.count else { return }
        guard let requestId = images[index].imageRequestId else { return }

        imageManager.cancelImageRequest(requestId)
    }
}
