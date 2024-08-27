//
//  ChatPartnerPickerViewModel.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 18.06.24.
//

import Foundation
import Firebase
import Combine

enum ChannelCreationRoutes {
    case groupPartnerPicker
    case setupGroupChat
}

enum ChannelConstants {
    static let maxGroupParticipants = 12
}

enum ChannelCreationErrors: Error {
    case noChatPartner
    case failedToCreateUniqueIds
}

final class ChatPartnerPickerViewModel: ObservableObject {
    @Published var navStack = [ChannelCreationRoutes]()
    @Published var selectedChatPartners = [UserItem]()
    @Published private(set) var users = [UserItem]()
    @Published var errorState: (showError: Bool, errorMessage: String) = (false, "Oh oh. Error occured!")
    
    private var authStateSubscriptions: AnyCancellable?
    
    private var lastCursor: String?
    
    private var currentUser: UserItem?
    
    var showSelectedUsers: Bool {
        return !selectedChatPartners.isEmpty
    }
    
    var disableNextButton: Bool {
        return selectedChatPartners.isEmpty
    }
    
    var isPaginatable: Bool {
        return !users.isEmpty
    }
    
    init() {
        listenForAuthState()
    }
    
    deinit {
        authStateSubscriptions?.cancel()
        authStateSubscriptions = nil
    }
    
    private var isDirectChannel: Bool {
        return selectedChatPartners.count == 1
    }
    
    private func listenForAuthState() {
        authStateSubscriptions = AuthManager.shared.authState.receive(on: DispatchQueue.main).sink { [weak self] authState in
            guard let self else { return }
            switch authState {
            case .loggedIn(let loggedInUser):
                self.currentUser = loggedInUser
                Task {
                    await self.fetchUsers()
                }
            default: break
            }
        }
    }
    
    // MARK: - PublicMethods
    func fetchUsers() async {
        do {
            let userNode = try await UserService.paginateUsers(lastCursor: lastCursor, pageSize: 5)

            var fetchedUsers = userNode.users
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            fetchedUsers = fetchedUsers.filter { $0.uid != currentUid } // filter out current loggedIn user
            
            self.users.append(contentsOf: fetchedUsers)
            self.lastCursor = userNode.currentCursor
            
        } catch {
            print("Failed to fetch users in ChatPartnerPickerViewModel \(error.localizedDescription)")
        }
    }
    
    func handleItemSelection(_ item: UserItem) {
        if isUserSelected(item) {
            guard let index =  selectedChatPartners.firstIndex(where: { $0.uid == item.uid }) else { return }
            selectedChatPartners.remove(at: index)
        } else {
            guard selectedChatPartners.count < ChannelConstants.maxGroupParticipants else {
                showError("Can't select more than \(ChannelConstants.maxGroupParticipants) users");
                return
            }
            selectedChatPartners.append(item)
        }
    }
    
    func isUserSelected(_ user: UserItem) -> Bool {
        let isSelected = selectedChatPartners.contains { $0.uid == user.uid }
        return isSelected
    }
    

    
    func deselectAllChatPartners() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.selectedChatPartners.removeAll()
        }
    }
    
    func createDirectChannel(_ chatPartner: UserItem, completion: @escaping (_ newChannel: ChannelItem) -> Void) {
        Task {
            // if existing DM, get the channel
            if let channelId = await checkIfDirectChannelExists(with: chatPartner.uid) {
                let snapshot = try await FirebaseConstants.ChannelsRef.child(channelId).getData()
                var channelDict = snapshot.value as! [String: Any]
                var directChannel = ChannelItem(channelDict)
                directChannel.members = selectedChatPartners
                if let currentUser {
                    directChannel.members.append(currentUser)
                }
                completion(directChannel)
                
            } else {
                // create new Channel
                selectedChatPartners.removeAll()
                selectedChatPartners.append(chatPartner)
                let channelCreationResult = createChannel(nil)
                switch channelCreationResult {
                case .success(let channelItem):
                    completion(channelItem)
                case .failure(let error):
                    showError("Sorry! Something went wrong while we were trying to create your chat.")
                }
            }

        }
    }
    
    func createGroupChannel(_ groupName: String, completion: @escaping (_ newChannel: ChannelItem) -> Void) {
        let channelCreationResult = createChannel(groupName)
        switch channelCreationResult {
        case .success(let channelItem):
            completion(channelItem)
        case .failure(let error):
            showError("Sorry! Something went wrong while we were trying to create your group chat.")
        }
    }
    
    
    typealias ChannelId = String
    private func checkIfDirectChannelExists(with charPartnerId: String) async -> ChannelId? {
        guard let currentUid = Auth.auth().currentUser?.uid,
              let snapshot = try? await FirebaseConstants.UserDirectChannels.child(currentUid).child(charPartnerId).getData(),
              snapshot.exists() else {
            return nil
        }
        let directMessageDict = snapshot.value as! [String: Bool]

        let channelId = directMessageDict.compactMap { $0.key }.first
        return channelId
    }
    
    private func showError(_ errorMessage: String) {
        errorState.errorMessage = errorMessage
        errorState.showError = true
    }
    
    private func createChannel(_ channelName: String?) -> Result<ChannelItem, Error> {
        guard !selectedChatPartners.isEmpty else {
            return .failure(ChannelCreationErrors.noChatPartner)
        }
        
        guard 
            let channelId = FirebaseConstants.ChannelsRef.childByAutoId().key,
            let currentUid = Auth.auth().currentUser?.uid,
            let messageId = FirebaseConstants.MessagesRef.childByAutoId().key
            else { return .failure(ChannelCreationErrors.failedToCreateUniqueIds) }
        let timeStamp = Date().timeIntervalSince1970
        
        var memberUids = selectedChatPartners.compactMap { $0.uid }
        memberUids.append(currentUid)
        
        let newChannelBroadcast = AdminMessageType.channelCreated.rawValue
        
        var channelDict: [String: Any] = [
            .id: channelId,
            .lastMessage: newChannelBroadcast,
            .creationDate: timeStamp,
            .lastMessageTimeStamp: timeStamp,
            .memberUids: memberUids,
            .adminUids: [   ],
            .membersCount: memberUids.count,
            .createdBy: currentUid
        ]
        
        if let channelName = channelName, !channelName.isEmptyOrWhitespaces {
            channelDict[.name] = channelName
        }
        
        
        let messageDict: [String: Any] = [.type: newChannelBroadcast, .timeStamp: timeStamp, .ownerUid : currentUid]
        FirebaseConstants.ChannelsRef.child(channelId).setValue(channelDict)
        FirebaseConstants.MessagesRef.child(channelId).child(messageId).setValue(messageDict)
        
        /// keeping an index
        memberUids.forEach { userId in
            FirebaseConstants.UserChannelsRef
                .child(currentUid)
                .child(channelId)
                .setValue(true)
            
//            FirebaseConstants.UserDirectChannels
//                .child(currentUid)
//                .child(channelId)
//                .setValue(true)
        }
        
        if isDirectChannel {
            
            let chatPartner = selectedChatPartners[0]
            
            FirebaseConstants.UserDirectChannels
                .child(currentUid)
                .child(chatPartner.uid)
                .setValue([channelId: true])
            FirebaseConstants.UserDirectChannels.child(chatPartner.uid).child(currentUid).setValue([channelId: true])
        }

        var newChannelItem = ChannelItem(channelDict)
        newChannelItem.members = selectedChatPartners
        if let currentUser {
            newChannelItem.members.append(currentUser)
        }
        return .success(newChannelItem)
    }
}
