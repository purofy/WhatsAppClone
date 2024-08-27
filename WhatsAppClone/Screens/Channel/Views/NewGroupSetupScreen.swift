//
//  NewGroupSetupScreen.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 18.06.24.
//

import SwiftUI

struct NewGroupSetupScreen: View {
    
    @State private var channelName = ""
    @ObservedObject var viewModel: ChatPartnerPickerViewModel
    
    var onCreate: (_ newChannel: ChannelItem) -> Void

    
    var body: some View {
        List {
            Section {
                channelSetupView()
            }
            
            Section {
                Text("Disappearing Messages")
                Text("Group Permissions")
            }
            Section {
                SelectedChatPartnerView(users: viewModel.selectedChatPartners) { user in
                    viewModel.handleItemSelection(user)
                }
            } header: {
                let count = viewModel.selectedChatPartners.count
                let maxCount = ChannelConstants.maxGroupParticipants
                Text("Participants: \(count) of \(maxCount)")
            }
            .listRowBackground(Color.clear)
        }
        .navigationTitle("New Group")
        .toolbar {
            trailingNavItem()
        }
    }

    
    private func channelSetupView() -> some View {
        HStack {
            profileImageView()
                .frame(width: 60, height: 60)
            
            TextField(
                "",
                text: $channelName,
                prompt: Text("Group name"),
                axis: .vertical
            )
        }
    }
    
    private func profileImageView() -> some View {
        Button {
        }label: {
            ZStack {
                Image(systemName: "camera.fill")
                    .imageScale(.large)
            }
            .frame(width: 60,height: 60)
            .background(Color(.systemGray6))
            .clipShape(Circle())
        }
    }
}

extension NewGroupSetupScreen {
    @ToolbarContentBuilder
    private func trailingNavItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                viewModel.createGroupChannel(channelName, completion: onCreate)
            } label: {
                Text("Create")
            }
            .bold()
            .disabled(viewModel.disableNextButton)
        }
    }
}

#Preview {
    NavigationStack {
        NewGroupSetupScreen(viewModel: ChatPartnerPickerViewModel()) {_ in
            
        }
    }
}
