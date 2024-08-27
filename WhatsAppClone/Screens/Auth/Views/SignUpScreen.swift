//
//  SignUpScreen.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 16.06.24.
//

import SwiftUI

struct SignUpScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var authScreenModel: AuthScreenModel
    
    var body: some View {
        VStack {
            Spacer()
            AuthHeaderView()
            Spacer()
            AuthTextField(type: .email, text: $authScreenModel.email)
            let usernameInputType = AuthTextField.InputType.custom("Username", "at")
            AuthTextField(type: usernameInputType, text: $authScreenModel.username)
            AuthTextField(type: .password, text: $authScreenModel.password)
            AuthButton(title: "Create an account") {
                Task {
                    await authScreenModel.handleSignUp()
                }
            }
            .disabled(authScreenModel.disableSignUpButton)
            Spacer()
            backButton()
                .padding(30)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(
            colors: [Color.green, Color.green.opacity(0.8), .teal], startPoint: .top, endPoint: .bottom))
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }
    
    private func backButton() -> some View {
        Button {
            dismiss()
        } label: {
            HStack {
                Image(systemName: "sparkles")
                (
                    Text("Already created an account ?  ")
                    +
                    Text("Login")
                        .bold()
                )
                Image(systemName: "sparkles")

            }
            .foregroundStyle(.white)    
        }
    }
}

#Preview {
    SignUpScreen(authScreenModel: AuthScreenModel())
}
