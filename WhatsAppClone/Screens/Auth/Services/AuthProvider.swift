//
//  AuthProvider.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 17.06.24.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseDatabase

enum AuthState {
    case pending, loggedIn(UserItem), loggedOut
}

enum AuthError: Error {
    case accountCreationFailed(_ description: String)
    case failedToSaveUserInfo(_ description: String)
    case emailLoginFailed(_ description: String)
}

extension AuthError: LocalizedError {
    var errorDescription: String?{
        switch self {
        case .accountCreationFailed(let description):
            return description
        case .failedToSaveUserInfo(let description):
            return description
        case .emailLoginFailed(let description):
            return description
        }
    }
}

protocol AuthProvider {
    static var shared: AuthProvider { get }
    var authState:CurrentValueSubject<AuthState, Never> { get }
    
    func autoLogin() async
    func login(with email: String, and password: String) async throws
    func createAccount(for username: String, with email: String, and password: String) async throws
    func logout() async throws
}


final class AuthManager: AuthProvider {
    
    private init() {
        Task {
            await autoLogin()
        }
    }
    
    static let shared: AuthProvider = AuthManager()
    
    var authState = CurrentValueSubject<AuthState, Never>(.pending)
    
    func autoLogin() async {
        if Auth.auth().currentUser == nil {
            authState.send(.loggedOut)
        } else {
            fetchCurrentUserInfo()
        }
    }
    
    func login(with email: String, and password: String) async throws {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            fetchCurrentUserInfo()
            print("Successfully signed in \(authResult.user.email ?? "")")
        } catch {
            print("Failed to sign in \(error.localizedDescription)")
            throw AuthError.emailLoginFailed(error.localizedDescription)
        }
    }
    
    func createAccount(for username: String, with email: String, and password: String) async throws {
        // invoke firebase create account method: store user in firebase auth
        // store new user info into database
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = authResult.user.uid
            let newUser = UserItem(uid: uid, username: username, email: email)
            try await saveUserInfoToDatabase(user: newUser)
            
            self.authState.send(.loggedIn(newUser))
        } catch {
            print("Failed to create an account \(error.localizedDescription)")
            throw AuthError.accountCreationFailed(error.localizedDescription)
        }
    }
    
    func logout() async throws {
        do {
            try await Auth.auth().signOut()
            authState.send(.loggedOut)
            print("Logged out")
        } catch {
            print("Failed to log out current user \(error.localizedDescription)")
            throw AuthError.accountCreationFailed(error.localizedDescription)
        }
    }

    
    
}

extension AuthManager {
    private func saveUserInfoToDatabase(user: UserItem) async throws {
        do {
            let userDictionary: [String: Any] = [.uid : user.uid, .username : user.username, .email : user.email]
            try await FirebaseConstants.UserRef.child(user.uid).setValue(userDictionary)
        } catch {
            print("Failed to save created user info to database \(error.localizedDescription)")
            throw AuthError.failedToSaveUserInfo(error.localizedDescription)
        }

        
    }
    /// guard let currentUid = Auth.auth().currentUser?.uid else { return }: This line is checking if there is a currently authenticated user. If there is, it assigns the user's unique identifier (UID) to currentUid. If there isn't, it exits the function.
    
    /// Database.database().reference().child("users").child(currentUid).observe(.value) {snapshot in: This line is setting up a listener on the Firebase database at the path "users/{currentUid}". Whenever the data at this path changes, the code inside the closure will be executed. The .value event type means that the listener will receive an event when the data at the specified location changes.

    /// guard let userDict = snapshot.value as? [String: Any] else { return }: This line is trying to cast the value of the snapshot (the data returned from the database) to a dictionary with String keys and Any values. If the cast is successful, it assigns the dictionary to userDict. If it isn't, it exits the function.

    /// let loggedInUser = UserItem(dictionary: userDict): This line is creating a new UserItem object from the userDict dictionary.

    /// self.authState.send(.loggedIn(loggedInUser)): This line is sending a .loggedIn(loggedInUser) event to self.authState, presumably to update the application's state to reflect that the user is logged in.

    /// withCancel: { error in print("Failed to get current user info") }: This is a closure that will be executed if the observation is cancelled for some reason, such as if the user is no longer authenticated. In this case, it simply prints an error message.
    private func fetchCurrentUserInfo() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
    
        FirebaseConstants.UserRef.child(currentUid).observe(.value) {snapshot in
            guard let userDict = snapshot.value as? [String: Any] else { return }
            let loggedInUser = UserItem(dictionary: userDict)
            self.authState.send(.loggedIn(loggedInUser))
            print("Logged in user \(loggedInUser)")
        } withCancel: { error in
            print("Failed to get current user info")
        }

    }
}

extension AuthManager {
    static let testAccounts: [String] = [
    "max1@example.com",
    "max2@example.com",
    "max3@example.com",
    "max4@example.com",
    "max5@example.com",
    "max6@example.com",
    "max7@example.com",
    "max8@example.com",
    "max9@example.com",
    "max10@example.com",
    "max11@example.com",
    "max12@example.com",
    "max13@example.com",
    "max14@example.com",
    "max15@example.com",
    "max16@example.com",
    "max17@example.com",
    "max18@example.com",
    "max19@example.com",
    "max20@example.com",
    "max21@example.com",
    "max22@example.com",
    "max23@example.com",
    "max24@example.com",
    "max25@example.com",
    "max26@example.com",
    "max27@example.com",
    "max28@example.com",
    "max29@example.com",
    "max30@example.com",
    "max31@example.com",
    "max32@example.com",
    "max33@example.com",
    "max34@example.com",
    "max35@example.com",
    "max36@example.com",
    "max37@example.com",
    "max38@example.com",
    "max39@example.com",
    "max40@example.com",
    "max41@example.com",
    "max42@example.com",
    "max43@example.com",
    "max44@example.com",
    "max45@example.com",
    "max46@example.com",
    "max47@example.com",
    "max48@example.com",
    "max49@example.com",
    "max50@example.com",
    ]
}
