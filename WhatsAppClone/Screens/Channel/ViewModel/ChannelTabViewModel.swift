//
//  ChannelTabViewModel.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 29.06.24.
//

import Foundation
import Firebase


enum ChannelTabRoutes: Hashable {
    case chatRoom(_ channel: ChannelItem)
}

final class ChannelTabViewModel: ObservableObject {
    
    
    @Published var navRoutes = [ChannelTabRoutes]()
    @Published var navigateToChatRoom = false
    @Published var newChannel: ChannelItem?
    @Published var showChatPartnerPickerView = false
    @Published var channels = [ChannelItem]()
    
    typealias ChannelId = String
    @Published var channelDictionary: [ChannelId: ChannelItem] = [:]
    
    
    private let currentUser: UserItem
//    private var subscriptions = Set<AnyCancellable>()
    
    init(_ currentUser: UserItem) {
        self.currentUser = currentUser
        fetchCurrentUserChannels()
    }
    
    func onNewChannelCreation(_ channel: ChannelItem)  {
        showChatPartnerPickerView = false
        newChannel = channel
        navigateToChatRoom = true
    }
    
    private func fetchCurrentUserChannels() {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        FirebaseConstants.UserChannelsRef.child(currentUid).observe(.value) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            dict.forEach { key, value in
                let channelId = key
                self.getChannel(with: channelId)
            }
        } withCancel: { error in
                print("Failed to get current user channels")
        }
        
    }
    private func getChannel(with channelId: String) {
        FirebaseConstants.ChannelsRef.child(channelId).observe(.value) {[weak self] snapshot in
            guard let dict = snapshot.value as? [String: Any], let self = self else { return }
            var channel = ChannelItem(dict)
            
            self.getChannelMembers(channel) { members in
                channel.members = members
                channel.members.append(self.currentUser)
                self.channelDictionary[channelId] = channel
                self.releadData()
            }
                
                
        } withCancel: { error in
            print("Failed to get channel for id \(channelId): \(error.localizedDescription)")
        }
    }
    
    private func getChannelMembers(_ channel: ChannelItem, completion: @escaping (_ members: [UserItem]) -> Void) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let channelMemberUids = Array(channel.membersUids.filter { $0 != currentUid }.prefix(2))
        
        UserService.getUsers(with: channelMemberUids) { userNode in
             completion(userNode.users)
        }
    }
    
    private func releadData() {
        self.channels = Array(channelDictionary.values)
        self.channels.sort { $0.lastMessageTimeStamp > $1.lastMessageTimeStamp }
    }
}
