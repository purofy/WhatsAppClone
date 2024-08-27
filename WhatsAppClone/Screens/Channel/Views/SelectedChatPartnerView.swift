//
//  SelectedChatPartnerView.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 18.06.24.
//

import SwiftUI

struct SelectedChatPartnerView: View {
    let users: [UserItem]
    let onTapHandler: (_ user: UserItem) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(users) { user in
                    chatPartnerView(user)
                }
            }
        }

    }
    
    private func chatPartnerView(_ user: UserItem) -> some View {
        VStack {
            Circle()
                .fill(.gray)
                .frame(width: 60,height: 60)
                .overlay(alignment: .topTrailing, content: {
                    cancelButton(user)
                })
            Text(user.username)
        }
    }
    
    private func cancelButton(_ user: UserItem) -> some View {
        Button {
            onTapHandler(user)
        } label: {
            Image(systemName: "xmark")
                .imageScale(.small)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
                .padding(5)
                .background(Color(.systemGray5))
                .clipShape(Circle())
        }
    }
}

#Preview {
    SelectedChatPartnerView(users: UserItem.placeholders) { user in
        
    }
}
