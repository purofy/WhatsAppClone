//
//  MainTabView.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 11.06.24.
//

import SwiftUI

struct MainTabView: View {
    
    private let currentUser: UserItem
    
    init(_ currentUser: UserItem) {
        self.currentUser = currentUser
        makeTabBarOpaque()
        let thumbImage = UIImage(systemName: "circle.fill")
        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
    }
    
    var body: some View {
        TabView {
            UpdatesTabScreen()
                .tabItem {
                    Image(systemName: Tab.updates.icon)
                }
            CallsTabScreen()
                .tabItem {
                    Image(systemName: Tab.calls.icon)
                }
            CommunityTabScreen()
                .tabItem {
                    Image(systemName: Tab.communities.icon)
                }
            ChannelTabScreen(currentUser)
                .tabItem {
                    Image(systemName: Tab.chats.icon)
                }
            SettingsTabScreen()
                .tabItem {
                    Image(systemName: Tab.settings.icon)
                }
        }
    }
    
    private func makeTabBarOpaque() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

extension MainTabView {
    private func placeholderItemView(_ title: String) -> some View {
        ScrollView {
            VStack {
                ForEach(0..<120) { _ in
                   Text(title)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .background(Color.green.opacity(0.5))
                }
            }
        }
    }
    
    private enum Tab: String {
        case updates, calls, communities, chats, settings
        
        fileprivate var title: String {
            return rawValue.capitalized
        }
        
        fileprivate var icon: String {
            switch self {
            case .updates:
                return "circle.dashed.inset.filled"
            case .calls:
                return "phone"
            case .communities:
                return "person.3"
            case .chats:
                return "message"
            case .settings:
                return "gear"
            }
        }
    }
}

#Preview {
    MainTabView(UserItem.placeholder)
}
