//
//  ChatRoomViewModel.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 15.07.24.
//

import Foundation
import Combine
import PhotosUI
import SwiftUI

final class ChatRoomViewModel: ObservableObject {
    
    @Published var textMessage = ""
    @Published var messages = [MessageItem]()
    @Published var showPhotoPicker = false
    @Published var photoPickerItems: [PhotosPickerItem] = []
    @Published var mediaAttachments: [MediaAttachment] = []
    
    private var currentUser: UserItem?
    
    private(set) var channel: ChannelItem
    private var subscriptions = Set<AnyCancellable>()
    
    var showPhotoPickerPreview: Bool {
        return !mediaAttachments.isEmpty
    }
    
    init(_ channel: ChannelItem) {
        self.channel = channel
        listenToAuthState()
        onPhotoPickerSelection()
    }
    
    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        currentUser = nil
    }
    
    private func listenToAuthState() {
        AuthManager.shared.authState.receive(on: DispatchQueue.main).sink {[weak self] authState in
            guard let self else { return }
            
            switch authState {
            case .loggedIn(let currentUser):
                self.currentUser = currentUser
                if self.channel.allMembersFetched {
                    self.getMessages()
                } else {
                    self.getAllChannelMembers()
                }
            default:
                break
            }
        }.store(in: &subscriptions)
    }
    
    func sendMessage() {
        
        guard let currentUser else { return }
        MessageService.sendTextMessage(to: channel, from: currentUser , textMessage) { [ weak self ] in
            self?.textMessage = ""
        }
    }
    
    private func getMessages() {
        MessageService.getMessages(for: channel) {[weak self] messages in
            self?.messages = messages
            print(messages.map { $0.text })
        }
    }

    private func getAllChannelMembers() {
        guard let currentUser = currentUser else { return }
        let membersAlreadyFetched = channel.members.compactMap {$0.uid}
        var memberUidsTOFetch = channel.membersUids.filter { !membersAlreadyFetched.contains($0) }
        
        memberUidsTOFetch = memberUidsTOFetch.filter { $0 != currentUser.uid }
        
        UserService.getUsers(with: memberUidsTOFetch) { [weak self] usernode in
            guard let self = self else { return }
            self.channel.members.append(contentsOf: usernode.users)
            self.getMessages()
        }
    }
    
    func handleTextInputAreaAction(_ action: TextInputArea.UserAction) {
        switch action {
        case .sendMessage:
            sendMessage()
        case .presentPhotoPicker:
            showPhotoPicker = true
        }
    }
    
    private func onPhotoPickerSelection() {
        $photoPickerItems.sink {[weak self] photoItems in
            guard let self = self else { return }
            Task { await self.parsePhotoPickerItems(photoItems) }
        }.store(in: &subscriptions)
    }
    
    func dismissPhotoPicker() {
        photoPickerItems = []
        mediaAttachments = []
        showPhotoPicker = false
    }
    
    private func parsePhotoPickerItems(_ photoPickerItems: [PhotosPickerItem]) async {
        for photoItem in photoPickerItems {
            if photoItem.isVideo {
                if let movie = try? await photoItem.loadTransferable(type: VideoPickerTransferable.self), let thumbnail = try? await movie.url.generateThumbnail() {
                    let videoAttachment = MediaAttachment(id: UUID().uuidString, type: .video(thumbnail, movie.url))
                    self.mediaAttachments.insert(videoAttachment, at: 0)
                }
            } else {
                guard
                let data = try? await photoItem.loadTransferable(type: Data.self),
                let thumbnail = UIImage(data: data)
                else {return}
                let photoAttachment = MediaAttachment(id: UUID().uuidString, type: .photo(thumbnail))
                self.mediaAttachments.insert(photoAttachment, at: 0)
            }
        }
    }
}
