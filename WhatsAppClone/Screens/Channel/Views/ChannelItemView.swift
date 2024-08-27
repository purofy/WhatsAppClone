//
//  ChannelItemView.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 11.06.24.
//

import SwiftUI

struct ChannelItemView: View {
    
    let channel: ChannelItem
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            CircularProfileImageView(channel.coverImageUrl, size: .medium)
            VStack(alignment: .leading) {
                titleTextView()
                lastMessagePreview()

            }
        }
    }
    
    private func titleTextView() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(channel.title)
                    .lineLimit(1)
                    .bold()
                Spacer()
                Text(channel.lastMessageTimeStamp.dateOrTimeRepresentation)
                    .foregroundStyle(.gray)
                    .font(.system(size: 15))
            }
        }

    }
    
    private func lastMessagePreview() -> some View {
        HStack {
//            Image(systemName: "mic.fill")
            Text(channel.lastMessage)
        }
        .font(.system(size: 16))
        .lineLimit(2)
        .foregroundColor(.gray)
    }
}

#Preview {
    ChannelItemView(channel: .placeholder)
}
