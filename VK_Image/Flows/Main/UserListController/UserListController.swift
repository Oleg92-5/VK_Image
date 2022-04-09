
import UIKit

class UserListController: ViewController<UserListViewModel>, UITableViewDelegate {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    let data = UserService()
    var dataUser: [UserDetails] = []
    
    weak var navigationDelegate: UserListControllerNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        dataUser = data.users
        dataUser = dataUser.sorted(by: { $0.login < $1.login })
        
        setup()
    }
}

//Private
private extension UserListController {
    func setup() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension UserListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataUser.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTableViewCell
        cell.update(user: dataUser[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70.0
    }
}
