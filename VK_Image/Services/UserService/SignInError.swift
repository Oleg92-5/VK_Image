
import Foundation

enum SignInError: LocalizedError {
    case invalidCredentials
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "errorDescriptionInvalidCredentials".localized
        }
    }
}
