//
//  AddGroupChatPartnersScreen.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 18.06.24.
//

import SwiftUI

struct GroupPartnerPickerScreen: View {
    @ObservedObject var viewModel: ChatPartnerPickerViewModel
    
    @State private var searchText = ""
    var body: some View {
        List {
            
            if viewModel.showSelectedUsers {
                SelectedChatPartnerView(users: viewModel.selectedChatPartners) { user in
                    viewModel.handleItemSelection(user)
                }
            }
            
            Section {
                ForEach(viewModel.users) { item in
                    Button {
                        viewModel.handleItemSelection(item)
                    } label: {
                        chatsPartnerRawView(item)
                    }
                }
            }
            
            if viewModel.isPaginatable {
                loadMoreUsersView()
            }
        }
        .animation(.easeInOut, value: viewModel.showSelectedUsers)
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search name or number"
        )
        .toolbar {
            titleView()
            trailingNavItem()
        }
        .onAppear {
            viewModel.deselectAllChatPartners()
        }

    }
    
    private func chatsPartnerRawView(_ user: UserItem) -> some View {
        ChatPartnerRowView(user: user) {
            Spacer()
            let isSelected = viewModel.isUserSelected(user)
            let imageName = isSelected ? "checkmark.circle.fill" : "circle"
            let foregroundStyle = isSelected ? Color(.systemBlue) : Color(.systemGray4)
            Image(systemName: imageName)
                .foregroundStyle(foregroundStyle)
                .imageScale(.large)
        }
    }
    
    private func loadMoreUsersView() -> some View {
        ProgressView()
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
            .task {
                await viewModel.fetchUsers()
            }
    }
}
extension GroupPartnerPickerScreen {
    @ToolbarContentBuilder
    private func trailingNavItem() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                viewModel.navStack.append(.setupGroupChat)
            } label: {
                Text("Next")
            }
            .bold()
            .disabled(viewModel.disableNextButton)
        }
    }
     
    @ToolbarContentBuilder
    private func titleView() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            VStack {
                Text("Add participants")
                    .bold()
                let count = viewModel.selectedChatPartners.count
                let maxCount = ChannelConstants.maxGroupParticipants
                Text("\(count)/\(maxCount)")
                    .foregroundStyle(.gray)
                    .font(.footnote)
            }
        }
    }
}

#Preview {
    GroupPartnerPickerScreen(viewModel: ChatPartnerPickerViewModel())
}
