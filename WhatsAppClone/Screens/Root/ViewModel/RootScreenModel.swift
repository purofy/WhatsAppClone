//
//  RootScreenModel.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 17.06.24.
//

import Foundation
import Combine

// In summary, RootScreenModel acts as a ViewModel in the MVVM (Model-View-ViewModel) pattern, 
// responsible for managing and updating the authentication state of the app. 
// It listens for changes in the authentication state via Combine and updates its authState 
// property accordingly, which in turn notifies the UI to reflect the current authentication status.
@MainActor
final class RootScreenModel: ObservableObject {
    @Published private(set) var authState = AuthState.pending
    
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = AuthManager.shared.authState.receive(on: DispatchQueue.main)
            .sink {[weak self] latestAuthState in
                self?.authState = latestAuthState
            }
// Populate test accounts
//        AuthManager.testAccounts.forEach { email in
//                registerTestAccount(with: email)
//        }
    }
//    private func registerTestAccount(with email: String) {
//        Task {
//            let username = email.replacingOccurrences(of: "@example.com", with: "")
//            try? await AuthManager.shared.createAccount(for: username, with: email, and: "12345678")
//        }
//    }
}


