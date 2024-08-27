//
//  ChatViewScreen.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 11.06.24.
//

import SwiftUI

struct ChannelTabScreen: View {
    
    @State private var searchText = ""
    @StateObject private var viewModel: ChannelTabViewModel
    
    init(_ currentUser: UserItem) {
        self._viewModel = StateObject(wrappedValue: ChannelTabViewModel(currentUser))
    }
    
    var body: some View {
        NavigationStack(path: $viewModel.navRoutes) {
            List {
                archivedChatsButton()
                ForEach(viewModel.channels) { channel in
//                    Bad because we load ChatRoomsScreen immeadiatelly into memeory.
//                    NavigationLink {
//                        ChatRoomScreen(channel: channel)
//                    } label: {
//                        ChannelItemView(channel: channel)
//                    }
                    Button {
                        viewModel.navRoutes.append(.chatRoom(channel))
                    } label: {
                        ChannelItemView(channel: channel)
                    }
                }
                inboxFooterView()
                    .listRowSeparator(.hidden)
                
            }
            .listStyle(.plain)
            .navigationTitle("Chats")
            .searchable(text: $searchText)
            .toolbar {
                leadingNavItems()
                trailingNavItems()
            }
            .navigationDestination(for: ChannelTabRoutes.self) { route in
                destinationView(for: route)
            }
            .sheet(isPresented: $viewModel.showChatPartnerPickerView, content: {
                ChatPartnerPickerScreen(onCreate: viewModel.onNewChannelCreation)
            })
            .navigationDestination(isPresented: $viewModel.navigateToChatRoom) {
                if let newChannel = viewModel.newChannel {
                    ChatRoomScreen(channel: newChannel)
                }
            }
        }

        
    }
}

extension ChannelTabScreen {
    
    @ViewBuilder
    private func destinationView( for route: ChannelTabRoutes) -> some View  {
        switch route {
        case .chatRoom(let channel):
            ChatRoomScreen(channel: channel)
        }
    }
    
    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Menu {
                Button {
                    
                } label: {
                    Label("Select chats", systemImage: "checkmark.circle")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }
    private func trailingNavItems() -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            aiButton()
            cameraButton()
            newChatButton()
        }
    }
    
    private func aiButton() -> some View {
        Button {
            
        } label: {
            Image(.circle)
        }
    }
    private func newChatButton() -> some View {
        Button {
            viewModel.showChatPartnerPickerView = true
        } label: {
            Image(.plus)
        }
    }
    private func cameraButton() -> some View {
        Button {
            
        } label: {
            Image(systemName: "camera")
        }
    }
    
    private func archivedChatsButton() -> some View {
        Button {
            
        } label: {
            Label("Archived", systemImage: "archivebox.fill")
                .bold()
                .padding()
                .foregroundColor(.gray)
        }
    }
    
    private func inboxFooterView() -> some View {
        HStack {
            Image(systemName: "lock")
            Text("Your personal messages are")
                
            Text("end-to-end encrypted")
                .foregroundColor(.blue)
        }
        .foregroundColor(.gray)
        .font(.system(size: 12))
        .padding(.horizontal)
    }
}

#Preview {
    ChannelTabScreen(.placeholder)
}
