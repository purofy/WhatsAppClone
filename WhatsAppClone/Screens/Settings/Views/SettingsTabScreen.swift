//
//  SettingsViewScreen.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 11.06.24.
//

import SwiftUI

struct SettingsTabScreen: View {
    @State private var searchText = ""
    var body: some View {
        NavigationStack {
            List {
                SettingsHeaderView()
                Section {
                    SettingsItemView(item: SettingsItem.broadCastLists)
                    SettingsItemView(item: SettingsItem.starredMessages)
                    SettingsItemView(item: SettingsItem.linkedDevices)
                }
                Section {
                    SettingsItemView(item: SettingsItem.account)
                    SettingsItemView(item: SettingsItem.privacy)
                    SettingsItemView(item: SettingsItem.chats)
                    SettingsItemView(item: SettingsItem.notifications)

                    SettingsItemView(item: SettingsItem.storage)

                }
                Section {
                    SettingsItemView(item: SettingsItem.help)
                    SettingsItemView(item: SettingsItem.tellFriend)
                    .toolbar {
                        
                    }
                }
            }
            .navigationTitle("Settings")
            .searchable(text: $searchText)
            .toolbar {
                leadingNavItem()
            }
        }
    }
}

extension SettingsTabScreen {
    @ToolbarContentBuilder
    private func leadingNavItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Sign Out") {
                Task {
                    try? await  AuthManager.shared.logout()
                }
            }
            .foregroundStyle(.red)
        }
    }
}

private struct SettingsHeaderView: View {
    var body: some View {
        Section {
            HStack {
                Circle()
                    .frame(width: 55, height: 55)
                userInfoTextView()
            }
            SettingsItemView(item: .avatar)
        }
    }
    
    private func userInfoTextView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Max Mustermann")
                    .font(.title2)
                Spacer()
                Image(.qrcode)
                    .renderingMode(.template)
                    .padding(5)
                    .foregroundStyle(.blue)
                    .background(Color(.systemGray5))
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            }
            Text("Hey there! I'm using WhatsApp!")
                .font(.system(.caption))
                .foregroundStyle(.gray)
        }
        .lineLimit(1)
    }
}

#Preview {
    SettingsTabScreen()
}
