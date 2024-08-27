//
//  TextInputArea.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 12.06.24.
//

import SwiftUI

struct TextInputArea: View {
    @Binding var textMessage: String
    
    let actionHandler:(_ action: UserAction) -> Void
        
    
    
    private var disableSendButton: Bool {
        return textMessage.isEmpty
    }
    
    var body: some View {
        HStack(alignment:.bottom, spacing: 5) {
            imagePickerButton()
                .padding(3)
            audioRecorderButton()
            messageTextField()
            sendMessageButton()
                .disabled(textMessage.isEmpty)
                .grayscale(textMessage.isEmpty ? 1 : 0)

        }
        .padding(.bottom)
        .padding(.horizontal, 8)
        .padding(.top, 10)
        .background(.whatsAppWhite)
    }
    
    private func messageTextField() -> some View {
        TextField("", text: $textMessage, axis: .vertical)
            .padding(5)
            .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.thinMaterial))
            .overlay(textViewBorder())
    }
    
    private func textViewBorder() -> some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .stroke(Color(.systemGray5), lineWidth: 1)
    }
    
    private func sendMessageButton() -> some View {
        Button {
            actionHandler(.sendMessage)
        } label: {
            Image(systemName: "arrow.up")
                .fontWeight(.heavy)
                .foregroundStyle(.white)
                .padding(6)
                .background(Color.blue)
                .clipShape(Circle())
        }
    }
    
    
    private func imagePickerButton() -> some View {
        Button {
            actionHandler(.presentPhotoPicker)
        } label: {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 22))
        }
    }
    
    private func audioRecorderButton() -> some View {
        Button {
        } label: {
            Image(systemName: "mic.fill")
                .fontWeight(.heavy)
                .imageScale(.small)
                .foregroundStyle(.white)
                .padding(6)
                .background(.blue)
                .clipShape(Circle())
                .padding(.horizontal, 3)
        }
    }
}

extension TextInputArea {
    enum UserAction {
        case presentPhotoPicker
        case sendMessage
    }
}

#Preview {
    TextInputArea(textMessage: .constant("")) { _ in
        
    }
}