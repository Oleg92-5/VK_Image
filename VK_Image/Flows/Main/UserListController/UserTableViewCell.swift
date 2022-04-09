
import UIKit

class UserTableViewCell: UITableViewCell {
    private lazy var avatarUser: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.image = UIImage(named: "avatar")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Login"
        label.font = .systemFont(ofSize: 20.0, weight: .heavy)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "cell")
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.backgroundColor = .systemBackground
        
        self.addSubview(avatarUser)
        self.addSubview(loginLabel)
        
        var constraints = [NSLayoutConstraint]()
        
        //avatarUser
        constraints.append(avatarUser.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0))
        constraints.append(avatarUser.centerYAnchor.constraint(equalTo: self.centerYAnchor))
        constraints.append(avatarUser.heightAnchor.constraint(equalToConstant: 60.0))
        constraints.append(avatarUser.widthAnchor.constraint(equalToConstant: 60.0))
        
        //loginLabel
        constraints.append(loginLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        constraints.append(loginLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor))

        NSLayoutConstraint.activate(constraints)
    }
    
    func update(user: UserDetails) {
        loginLabel.text = user.login
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarUser.layer.cornerRadius = avatarUser.frame.width / 2
    }
}
