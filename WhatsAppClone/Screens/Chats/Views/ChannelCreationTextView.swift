//
//  ChannelCreationTextView.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 16.07.24.
//

import SwiftUI

struct ChannelCreationTextView: View {
    
    @Environment(\.colorScheme) private var backgroundColorScheme
    private var backgroundColor: Color {
        return backgroundColorScheme == .dark ? .black : .yellow
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            (
            Text(Image(systemName: "lock.fill"))
            +
            Text(" Messages and calls are end-to-end encrypted. No one outside of this chat, not even WhatsApp, can read or listen to them. Tap to learn more.")
            +
            Text(Image(systemName: "arrow.down.circle.fill"))
            )
        }
        .font(.footnote)
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .padding(.horizontal, 40)
    }
}

#Preview {
    ChannelCreationTextView()
}
