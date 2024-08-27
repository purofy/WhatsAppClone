//
//  CallsTabScreen.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 11.06.24.
//

import SwiftUI

struct CallsTabScreen: View {
    @State private var searchtext = ""
    @State private var callHistory = CallHistory.all

    var body: some View {
        NavigationStack {
            List {
                Section {
                    CreateCallKinkSection()
                }
                
                Section {
                    ForEach(0..<12) { item in
                        RecentCallItemView()
                    }
                } header: {
                    Text("Recent")
                        .bold()
                        .font(.headline)
                        .textCase(nil)
                        .foregroundColor(.whatsAppBlack)
                }
            }
            .navigationTitle("Calls")
            .searchable(text: $searchtext)
            .toolbar {
                leadingNavItem()
                trailingNavItem()
                principleNavItem()
            }
        }
    }
}

extension CallsTabScreen {
    
    @ToolbarContentBuilder
    private func leadingNavItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Edit") {}
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                
            } label: {
                Image(systemName: "phone.arrow.up.right")
            }
        }
    }
    
    @ToolbarContentBuilder
    private func principleNavItem() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Picker("", selection: $callHistory) {
                ForEach(CallHistory.allCases) { item in
                    Text(item.rawValue.capitalized)
                        .tag(item)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 150)
        }
    }
    
    private enum CallHistory: String, CaseIterable, Identifiable {
        case all, missed
        
        var id: String {
            return rawValue
        }
    }
}

private struct CreateCallKinkSection: View {
    var body: some View {
        HStack {
            Image(systemName: "link")
                .padding(8)
                .background(Color(.systemGray6))
                .clipShape(Circle())
                .foregroundStyle(.blue)

                
            
            VStack(alignment: .leading) {
                Text("Create Call Link")
                    .foregroundStyle(.blue)
                
                Text("Share a link for your WhatsApp call")
                    .foregroundStyle(.gray)
                    .font(.caption)
            }
        }
    }
}

private struct RecentCallItemView: View {
    var body: some View {
        HStack {
            Circle()
                .frame(width: 45, height: 45)
            recentCallTextView()
            Spacer()
            Text("Yesterday")
                .font(.system(size: 16))
                .foregroundStyle(.gray)
            
            Image(systemName: "info.circle")
        }
    }
    
    private func recentCallTextView() -> some View {
        VStack(alignment: .leading) {
            Text("Max Mustermann") // TODO: update text with actual caller
            HStack(spacing: 5) {
                Image(systemName: "phone.arrow.up.right") // TODO: update text with call type
                Text("Outgoing") // TODO: update text with call type
            }
            .font(.system(size: 14))
            .foregroundColor(.gray)
        }
    }
}

#Preview {
    CallsTabScreen()
}
