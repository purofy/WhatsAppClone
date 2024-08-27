//
//  ChatRoomScreen.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 12.06.24.
//

import SwiftUI
import PhotosUI

struct ChatRoomScreen: View {
    
    let channel: ChannelItem
    @StateObject private var viewModel: ChatRoomViewModel

    init(channel: ChannelItem) {
        self.channel = channel
        _viewModel = StateObject(wrappedValue: ChatRoomViewModel(channel))
    }
    
    
    var body: some View {
        MessageListView(viewModel)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                leadingNavItems()
                trailingNavItems()
            }
            .photosPicker(isPresented: $viewModel.showPhotoPicker, selection: $viewModel.photoPickerItems, maxSelectionCount: 6)
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                bottomSafeAreaView()
            }
    }
    
    private func bottomSafeAreaView() -> some View {
        VStack(spacing:0) {
            Divider()
            if viewModel.showPhotoPickerPreview {
                MediaAttachmentPreview(mediaAttachments: viewModel.mediaAttachments)
                Divider()
            }
            TextInputArea(textMessage: $viewModel.textMessage) { action in
                viewModel.handleTextInputAreaAction(action)
            }
        }
    }
}

extension ChatRoomScreen {
    
    private var channelTitle: String {
        let maxChar = 20
        let trailingChars = channel.title.count > maxChar ? "..." : ""
        let title = String(channel.title.prefix(maxChar) + trailingChars)
        
        return title
    }
    
    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            HStack {
                CircularProfileImageView(channel, size: .mini)
                    .frame(width: 35, height: 35)
                Text(channelTitle)
                    .bold()
                
            }
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavItems() -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {
                
            } label: {
                Image(systemName: "video")
            }
            Button {
                
            } label: {
                Image(systemName: "phone")
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChatRoomScreen(channel: .placeholder)

    }
}
