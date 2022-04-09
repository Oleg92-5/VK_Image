
import UIKit

class ViewController<ViewModel>: UIViewController {
    var viewModel: ViewModel
    
    var isNavigationBarHidden: Bool {
        return false
    }
    
    //Lifecycle
    deinit {
        print("DEALLOC: \(String(describing: self))")
    }
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You should instantiate this class using code only")
    }
    
    //Overriden
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: false)
    }
    
    //Base methods
    func subscribe() {
        
    }
}
