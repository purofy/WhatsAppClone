//
//  UpdatesTabScreen.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 11.06.24.
//

import SwiftUI

struct UpdatesTabScreen: View {
    
    @State private var searchtext = ""
    
    var body: some View {
        NavigationStack {
            List {
                StatusSectionHeader()
                    .listRowBackground(Color.clear)
                StatusSection()
                Section {
                    RecentUpdatesItemView()

                } header: {
                    Text("Recent Updates")
                }
                Section {
                    ChannelListView()

                } header: {
                    channelSectionheader()
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Updates")
            .searchable(text: $searchtext)
        }
    }
    private func channelSectionheader() -> some View {
        HStack {
            Text("Channels")
                .bold()
                .font(.title3)
                .textCase(nil)
                .foregroundColor(.whatsAppBlack)
             
            Spacer()
            Button {
                
            } label: {
                Image(systemName: "plus")
                    .padding(7)
                    .background(Color(.systemGray5))
                    .clipShape(Circle())
            }
        }
    }
}

extension UpdatesTabScreen {
    enum Constant {
        static let imageDimention: CGFloat = 55
    }
}

private struct StatusSectionHeader: View {
    var body: some View  {
        HStack(alignment: .top) {
            Image(systemName: "circle.dashed")
                .foregroundStyle(.blue)
                .imageScale(.large)
            Spacer()
            (
                Text("use status to share photos, text and videos that disappear in 24 hours.")
                +
                Text(" ")
                +
                Text("Status Privacy")
                    .foregroundColor(.blue).bold()
            )
            Spacer()
            Image(systemName: "xmark")
                .foregroundColor(.blue)
        }
        .padding()
        .background(.whatsAppWhite)
        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
    }
}

private struct StatusSection: View {
    var body: some View {
        HStack {
            Circle()
                .frame(width: UpdatesTabScreen.Constant.imageDimention,height: UpdatesTabScreen.Constant.imageDimention)
            VStack(alignment: .leading){
                Text("My Status")
                    .font(.callout)
                    .bold()
                Text("Add to my status")
                    .foregroundStyle(.gray)
                    .font(.system(size: 15))
                
            }
            
            Spacer()
            cameraButton()
            pencilButton()
            
        }
    }
    
    private func cameraButton() -> some View {
        Button {
            
        } label: {
            Image(systemName: "camera.fill")
                .padding(10)
                .background(Color(.systemGray5))
                .clipShape(Circle())
                .bold()
        }
    }
    private func pencilButton() -> some View {
        Button {
            
        } label: {
            Image(systemName: "pencil")
                .padding(10)
                .background(Color(.systemGray5))
                .clipShape(Circle())
                .bold()
        }
    }
}

private struct RecentUpdatesItemView: View {
    var body: some View {
        HStack {
            Circle()
                .frame(width: UpdatesTabScreen.Constant.imageDimention,height: UpdatesTabScreen.Constant.imageDimention)
            VStack(alignment: .leading){
                Text("Max Mustermann")
                    .font(.callout)
                    .bold()
                Text("1h ago")
                    .foregroundStyle(.gray)
                    .font(.system(size: 15))
                
            }
            
        }
    }
    

}

private struct ChannelListView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Stay updated on topics that matter to you. Find channels to follow bellow.")
                .foregroundStyle(.gray)
                .padding(.horizontal)
                .font(.callout)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<45) { _ in
                         ChannelitemView()
                    }
                }
            }
            Button("Explore more") {
                
            } .tint(.blue)
                .bold()
                .buttonStyle(.borderedProminent)
                .clipShape(Capsule())
                .padding(.vertical)
        }
    }
}

private struct ChannelitemView: View {
    var body: some View {
        VStack {
            Circle()
                .frame(width: 55, height: 55)
            Text("Real Madrid FC")
            Button {
                
            } label: {
                Text("Follow")
                    .bold()
                    .padding(5)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.2))
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical)
        .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color(.systemGray4), lineWidth: 1))
    }
}

#Preview {
    UpdatesTabScreen()
}
