
import Foundation

enum SignUpError: LocalizedError {
    case userExists
    
    var errorDescription: String? {
        switch self {
        case .userExists:
            return "errorDescriptionUserExists".localized
        }
    }
}
