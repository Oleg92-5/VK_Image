
import Foundation

class UserService {
    static let sharedInstance = UserService()
    
    private let currentUserKey = "_c_current_user"
    private let usersKey = "_c_users"
    
    private(set) var currentUser: UserDetails?
    private(set) var users: [UserDetails] = []
    
    private var userDefaults: UserDefaults {
        return .standard
    }
    
    var isLoggedIn: Bool {
        return currentUser != nil
    }
    
    init() {
        load()
    }
}

private extension UserService {
    func load() {
        if let encodedUsers = userDefaults.data(forKey: usersKey),
           let users = try? JSONDecoder().decode([UserDetails].self, from: encodedUsers) {
            self.users = users
        }
        
        if let encodedUser = userDefaults.data(forKey: currentUserKey),
           let user = try? JSONDecoder().decode(UserDetails.self, from: encodedUser) {
            self.currentUser = user
        }
    }
    
    func save() {
        if let encodedUsers = try? JSONEncoder().encode(users) {
            userDefaults.set(encodedUsers, forKey: usersKey)
        }
        
        if let currentUser = currentUser {
            if let encodedUser = try? JSONEncoder().encode(currentUser) {
                userDefaults.set(encodedUser, forKey: currentUserKey)
            }
        } else {
            userDefaults.removeObject(forKey: currentUserKey)
        }
    }
}

extension UserService {
    func signIn(withCredentials credentials: AuthCredentials) throws {
        guard let user = users
                .first(where: { $0.login == credentials.login && $0.password == credentials.password }) else {
                    throw SignInError.invalidCredentials
                }
        
        currentUser = user
        save()
    }
    
    func signUp(withCredentials credentials: AuthCredentials) throws {
        guard !users.contains(where: { $0.login == credentials.login }) else { throw SignUpError.userExists }
        
        let user = UserDetails(login: credentials.login, password: credentials.password, avatarUrl: nil)
        users.append(user)
        currentUser = user
        save()
    }
    
    func signOut() {
        currentUser = nil
        save()
    }
}
