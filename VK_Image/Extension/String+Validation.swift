
import Foundation

extension String {
    enum ValidTypes {
        case login
        case password
    }
    
    enum Regex: String {
        case login = "[a-zA-Z0-9]{1,10}"
        case password = "(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{8,}"
    }
    
    func isValid(validType: ValidTypes) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""
        
        switch validType {
        case .login: regex = Regex.login.rawValue
        case .password: regex = Regex.password.rawValue
        }
        
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
}
