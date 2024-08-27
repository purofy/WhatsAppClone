//
//  AdminMessageTextView.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 16.07.24.
//

import SwiftUI

struct AdminMessageTextView: View {
    let channel: ChannelItem
    
    var body: some View {
        VStack {
            if channel.isCreatedByCurrentUser {
                textView("You just created a new channel. Tap to add more members.")
            } else {
                textView("\(channel.createrName) just created a new channel. Tap to learn more about it.")
                textView("\(channel.createrName) added you.")
            }
        }
    }
    
    private func textView(_ text: String) -> some View {
        Text(text)
            .multilineTextAlignment(.center)
            .font(.footnote)
            .padding(8)
            .padding(.horizontal, 5)
            .background(.bubbleWhite)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5, x: 0, y: 20)
    }
}

#Preview {
    ZStack {
        Color(.systemGray5)
        AdminMessageTextView(channel: .placeholder)
    }
    .ignoresSafeArea()
}
