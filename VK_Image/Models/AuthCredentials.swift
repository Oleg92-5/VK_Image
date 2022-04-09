
import Foundation

struct AuthCredentials: Codable {
    var login: String
    var password: String
}

struct UserDetails: Codable {
    var login: String
    var password: String
    var avatarUrl: URL?
}
