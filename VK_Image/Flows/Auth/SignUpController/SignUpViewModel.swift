
import Foundation
import Combine

class SignUpViewModel: ObservableObject {
    //Output
    @Published private(set) var signUpButtonEnabled: Bool = false
    @Published private(set) var loginValidationError: String?
    @Published private(set) var passwordValidationError: String?
    @Published private(set) var errorAlertMessage: String?
    @Published private(set) var signUpDidFinish: Void = ()
    
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
extension SignUpViewModel {
    func loginDidChange(_ login: String) {
        self.login = login
    }
    
    func passwordDidChange(_ password: String) {
        self.password = password
    }
    
    func signUpButtonTrigger() {
        guard isValidLogin, isValidPassword else { return }
        
        do {
            try UserService.sharedInstance.signUp(withCredentials: .init(login: login, password: password))
            signUpDidFinish = ()
        } catch {
            errorAlertMessage = error.localizedDescription
        }
    }
}

//Private
extension SignUpViewModel {
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
        
        signUpButtonEnabled = isValidLogin && isValidPassword
    }
}
