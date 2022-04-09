
import Foundation
import Combine

class SignInViewModel: ObservableObject {
    //Output
    @Published private(set) var signInButtonEnabled: Bool = false
    @Published private(set) var loginValidationError: String?
    @Published private(set) var passwordValidationError: String?
    @Published private(set) var openSignUp: Void = ()
    @Published private(set) var errorAlertMessage: String?
    @Published private(set) var signInDidFinish: Void = ()
    
    //Properties
    private var login: String = "" {
        didSet {
            validate()
        }
    }
    
    private var password: String = "" {
        didSet {
            validate()
        }
    }
    
    private var isValidLogin: Bool {
        return login.isValid(validType: .login)
    }
    
    private var isValidPassword: Bool {
        return password.isValid(validType: .password)
    }
}

//Input
extension SignInViewModel {
    func loginDidChange(_ login: String) {
        self.login = login
    }
    
    func passwordDidChange(_ password: String) {
        self.password = password
    }
    
    func signInButtonTrigger() {
        guard isValidLogin, isValidPassword else { return }
        
        do {
            try UserService.sharedInstance.signIn(withCredentials: .init(login: login, password: password))
            signInDidFinish = ()
        } catch {
            errorAlertMessage = error.localizedDescription
        }
    }
    
    func registerButtonTrigger() {
        openSignUp = ()
    }
}

//Private
extension SignInViewModel {
    func validate() {
        if !isValidLogin {
            loginValidationError = "loginWrongMessage".localized
        } else {
            loginValidationError = nil
        }
        if !isValidPassword {
            passwordValidationError = "passwordWrongMessage".localized
        } else {
            passwordValidationError = nil
        }
        
        signInButtonEnabled = isValidLogin && isValidPassword
    }
}
