//
//  LoginScreen.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 15.06.24.
//

import SwiftUI

struct LoginScreen: View {
    
    @StateObject private var authScreenModel = AuthScreenModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                AuthHeaderView()
                AuthTextField(type: .email, text: $authScreenModel.email)
                AuthTextField(type: .password, text: $authScreenModel.password)
                
                forgotPasswordButton()
                
                AuthButton(title: "Login Now") {
                    Task {
                        await authScreenModel.handleLogin()
                    }
                }
                .disabled(authScreenModel.disableLoginButton)
                Spacer()
                signUpButton()
                    .padding(.bottom,30)
                
                    
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.teal.gradient)
            .ignoresSafeArea()
            .alert(isPresented: $authScreenModel.errorState.showError){
                Alert(title: Text(authScreenModel.errorState.errorMessage), dismissButton: .default(Text("Ok")))
            }
        }
    }
    
    private func forgotPasswordButton() -> some View {
        Button {
            
        }label: {
            Text("Forgot Password")
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 32)
                .bold()
                .padding(.vertical)
            
        }
    }
    private func signUpButton() -> some View {
        NavigationLink {
            SignUpScreen(authScreenModel: authScreenModel)
        } label: {
            HStack {
                Image(systemName: "sparkles")
                (
                    Text("Dont have an account ? ")
                    +
                    Text("Create one")
                        .bold()
                )
                Image(systemName: "sparkles")

            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    LoginScreen()
}
