
import UIKit
import Photos
import Combine

class PhotoListController: ViewController<PhotoListViewModel>, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    private lazy var layoutConfiguration: UICollectionViewCompositionalLayoutConfiguration = {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.contentInsetsReference = .none
        return config
    }()
    
    private lazy var collectionLayout: UICollectionViewCompositionalLayout = {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [unowned self] idx, env in
            let numberOfColumns: CGFloat
            if env.traitCollection.horizontalSizeClass == .compact {
                numberOfColumns = 3
            } else {
                numberOfColumns = 5
            }
            
            let itemSizeFraction = 1 / numberOfColumns
            let insets = self.itemSpacing / 2.0
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(itemSizeFraction), heightDimension: .fractionalHeight(1)))
            item.contentInsets = .init(top: insets, leading: insets, bottom: insets, trailing: insets)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(itemSizeFraction)), subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }, configuration: layoutConfiguration)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        collection.alwaysBounceVertical = false
        collection.showsHorizontalScrollIndicator = false
        collection.clipsToBounds = false
        collection.register(CellPhotoListController.self, forCellWithReuseIdentifier: "Cell")
        return collection
    }()
    
    private lazy var userButton: UIBarButtonItem = {
        let button = createBarButtom(selector: #selector(openUserList(_:)), image: "person.3.fill", color: .systemBlue)
        return button
    }()
    
    private lazy var logoutButton: UIBarButtonItem = {
        let button = createBarButtom(selector: #selector(logoutAction(_:)), image: "person.fill.xmark", color: .systemBlue)
        return button
    }()
    
    
    private let itemSpacing: CGFloat = 2.0
    private var cancellables: Set<AnyCancellable> = .init()
    
    weak var navigationDelegate: PhotoListControllerNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        viewModel.viewDidLoadTrigger()
    }
    
    override func subscribe() {
        
        viewModel.$imageToOpen
            .dropFirst()
            .compactMap({ $0 })
            .receive(on: RunLoop.main)
            .sink { [weak self] images in
                self!.openImageDetails(imageModel: images)
            }
            .store(in: &cancellables)
        
        viewModel.$imageToOpen
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [unowned self] _ in
                navigationDelegate?.photoListControllerOpenDetailView()
            }
            .store(in: &cancellables)
        
        viewModel.$openUserList
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [unowned self] _ in
                navigationDelegate?.photoListControllerOpenUsepList()
            }
            .store(in: &cancellables)
        
        viewModel.$signOut
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [unowned self] _ in
                
                self.navigationDelegate?.photoListControllerDidSignOut()
            }
            .store(in: &cancellables)
        
        viewModel.$images
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [unowned self] _ in
                
                self.updateCollection()
            }
            .store(in: &cancellables)
        
        viewModel.$itemIndexToReload
            .dropFirst()
            .compactMap({ $0 })
            .sink { [unowned self] idx in
                
                DispatchQueue.main.async {
                    self.updateItemAtIndex(idx)
                }
            }
            .store(in: &cancellables)
    }
}

//Private
private extension PhotoListController {
    func setup() {
        view.addSubview(collectionView)
        
        navigationItem.rightBarButtonItem = userButton
        navigationItem.leftBarButtonItem = logoutButton
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//UICollectionViewDelegate
extension PhotoListController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CellPhotoListController
        cell.update(withModel: viewModel.images[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.imageTapTrigger(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.willDisplayItemAtIndexTrigger(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.didEndDisplayingItemAtIndexTrigger(index: indexPath.item)
    }
}

//Actions
extension PhotoListController {
    @objc func openUserList(_ sender: Any) {
        view.endEditing(true)
        viewModel.openUserTrigger()
    }
    
    @objc func logoutAction(_ sender: Any) {
        view.endEditing(true)
        viewModel.signOutTrigger()
    }
}

//Update
extension PhotoListController {
    
    func updateCollection() {
        collectionView.performBatchUpdates {
            collectionView.reloadSections([0])
        }
    }
    
    func updateItemAtIndex(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        guard collectionView.indexPathsForVisibleItems.contains(where: { $0 == indexPath }) else { return }
        
        let visibleCells = collectionView.visibleCells.reduce(into: [IndexPath: UICollectionViewCell]()) { partialResult, cell in
            guard let indexPath = collectionView.indexPath(for: cell) else { return }
            partialResult[indexPath] = cell
        }
        
        guard let cell = visibleCells[indexPath] as? CellPhotoListController else { return }
        cell.update(withModel: viewModel.images[index])
    }
    
    func openImageDetails(imageModel: ImageModel) {
        let imageModel = imageModel
        let viewModel = DetailViewModel()
        let controller = DetailViewController(viewModel: viewModel)
        controller.imageView.image = imageModel.previewImage

    }
}
