
import UIKit
import Combine

class SignUpController: ViewController<SignUpViewModel> {
    private lazy var logoImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.image = UIImage(named: "logo")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var registerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "registerLabel".localized
        label.font = .systemFont(ofSize: 20.0, weight: .heavy)
        return label
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "loginTextField".localized
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .next
        return textField
    }()
    
    private lazy var loginValidLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = .systemFont(ofSize: 14.0, weight: .light)
        label.textColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "passwordTextField".localized
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.returnKeyType = .go
        return textField
    }()
    
    private lazy var passwordValidLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = .systemFont(ofSize: 14.0, weight: .light)
        label.textColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        return label
    }()
    
    private lazy var registerFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [loginTextField, loginValidLabel, passwordTextField, passwordValidLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("registerButton".localized, for: .normal)
        button.tintColor = .white
        button.setBackgroundImage(#colorLiteral(red: 0.4784313725, green: 0.7294117647, blue: 0.4235294118, alpha: 1).image, for: .normal)
        button.setBackgroundImage(UIColor.gray.image, for: .disabled)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(registerButtonActinon), for: .touchUpInside)
        return button
    }()
    
    let loginValidType: String.ValidTypes = .login
    let passwordValidType: String.ValidTypes = .password
    private var cancellables: Set<AnyCancellable> = .init()
    weak var navigationDelegate: SignUpControllerNavigationDelegate?
    
    deinit {
        removeKeyboardNotificarion()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        setup()
        registerKeyboardNotificarion()
    }
    
    override func subscribe() {
        viewModel.$signUpButtonEnabled
            .receive(on: RunLoop.main)
            .sink { [unowned self] isEnabled in
                self.registrationButton.isEnabled = isEnabled
            }
            .store(in: &cancellables)
        
        viewModel.$loginValidationError
            .receive(on: RunLoop.main)
            .sink { [unowned self] error in
                
                loginValidLabel.text = error != nil ? error : ""
            }
            .store(in: &cancellables)
        
        viewModel.$passwordValidationError
            .receive(on: RunLoop.main)
            .sink { [unowned self] error in
                
                passwordValidLabel.text = error != nil ? error : ""
            }
            .store(in: &cancellables)
        
        viewModel.$errorAlertMessage
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [unowned self] error in
                
                let alertController = UIAlertController(title: "errorRegisterLogin".localized, message: error, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(action)
                present(alertController, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.$signUpDidFinish
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [unowned self] _ in
                
                self.navigationDelegate?.signUpControllerDidFinishSignUp()
            }
            .store(in: &cancellables)
    }
}

//Private
private extension SignUpController {
    func setup() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(registerLabel)
        backgroundView.addSubview(registerFieldStackView)
        backgroundView.addSubview(registrationButton)
        backgroundView.addSubview(logoImage)
        
        var constraints = [NSLayoutConstraint]()
        
        //scrolView
        constraints.append(scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        constraints.append(scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        
        //backgroundView
        constraints.append(backgroundView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor))
        constraints.append(backgroundView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor))
        constraints.append(backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor))
        constraints.append(backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor))
        
        //loginLabel
        constraints.append(registerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(registerLabel.bottomAnchor.constraint(equalTo: registerFieldStackView.topAnchor, constant: -40.0))
        
        //registerFieldStackView
        constraints.append(registerFieldStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 24.0))
        constraints.append(registerFieldStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -24.0))
        constraints.append(registerFieldStackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor))
        constraints.append(registerFieldStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor))
        
        //registrationButton
        constraints.append(registrationButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 24.0))
        constraints.append(registrationButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -24.0))
        constraints.append(registrationButton.topAnchor.constraint(equalTo: registerFieldStackView.bottomAnchor, constant: 24.0))
        constraints.append(registrationButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor))
        constraints.append(registrationButton.heightAnchor.constraint(equalToConstant: 40.0))
        
        //logoImage
        constraints.append(logoImage.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 128.0))
        constraints.append(logoImage.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor))
        constraints.append(logoImage.heightAnchor.constraint(equalToConstant: 128.0))
        constraints.append(logoImage.widthAnchor.constraint(equalToConstant: 128.0))
        
        NSLayoutConstraint.activate(constraints)
    }
}

//Actions
extension SignUpController {
    @objc func registerButtonActinon() {
        view.endEditing(true)
        viewModel.signUpButtonTrigger()
    }
}

//Keyboard
extension SignUpController {
    private func registerKeyboardNotificarion() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func removeKeyboardNotificarion() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo
        let keyboardHeight = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardHeight.height / 4)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentOffset = CGPoint.zero
    }
}

//TextField
extension SignUpController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            viewModel.signUpButtonTrigger()
            passwordTextField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let sourceString = (textField.text ?? "") as NSString
        let resultString = sourceString.replacingCharacters(in: range, with: string)
        
        switch textField {
        case loginTextField:
            viewModel.loginDidChange(resultString)
        case passwordTextField:
            viewModel.passwordDidChange(resultString)
        default:
            break
        }
        
        return true
    }
}
