//
//  Messageservice.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 15.07.24.
//

import Foundation

/// Mark: - MessageService handles all logic related to messages
struct MessageService {
    
    static func sendTextMessage(to channel: ChannelItem, from currentUser: UserItem, _ textMessage: String, onComplete: () -> Void) {
        let timeStamp = Date().timeIntervalSince1970
        
        guard let messageId = FirebaseConstants.MessagesRef.childByAutoId().key else { return }
        
        let channelDict: [String: Any] = [
            .lastMessage: textMessage,
            .lastMessageTimeStamp: timeStamp
        ]
        let messageDict: [String: Any] = [
            .text: textMessage,
            .type: MessageType.text.title,
            .timeStamp:timeStamp,
            .ownerUid: currentUser.uid
        ]
        
        FirebaseConstants.ChannelsRef.child(channel.id).updateChildValues(channelDict)
        FirebaseConstants.MessagesRef.child(channel.id).child(messageId).setValue(messageDict)
        
        onComplete()
    }
    
    static func getMessages(for channel: ChannelItem, completion: @escaping([MessageItem]) -> Void) {
        FirebaseConstants.MessagesRef.child(channel.id).observe(.value, with: { snapshot  in
            guard let dict = snapshot.value as? [String: Any] else { return }
            var messages: [MessageItem] = []

            dict.forEach { key, value in
                let messageDict = value as? [String: Any] ?? [:]
                let message = MessageItem(id: key, isGroupChat: channel.isGroupChat, dict: messageDict)
                messages.append(message)
                if messages.count == snapshot.childrenCount {
                    messages.sort(by: { $0.timestamp < $1.timestamp })
                    completion(messages)
                }
            }
            
        })
    }
}
