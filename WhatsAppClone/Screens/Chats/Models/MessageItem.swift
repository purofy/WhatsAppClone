//
//  MessageItem.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 14.06.24.
//

import Foundation
import SwiftUI
import Firebase

struct MessageItem: Identifiable {
    
    let id: String
    let isGroupChat: Bool
    let text: String
    let type: MessageType
    let ownerUid: String
    let timestamp: Date
    var sender: UserItem?
    
    var direction: MessageDirection {
        ownerUid == Auth.auth().currentUser?.uid ? .sent : .received
    }
    
    
    static let sentPlaceholder = MessageItem(id: UUID().uuidString, isGroupChat: true, text: "Hello", type: .text, ownerUid: "1", timestamp: Date())
    
    static let receivedPlaceholder = MessageItem(id: UUID().uuidString, isGroupChat: false, text: "Hello back", type: .text, ownerUid: "2", timestamp: Date())
    
    
    var alignment: Alignment {
        return direction == .received ? .leading : .trailing
    }
    
    var horizontalAlignment: HorizontalAlignment {
        return direction == .received ? .leading : .trailing
    }
    
    var backgroundColor: Color {
        return direction == .sent ? .bubbleGreen : .bubbleWhite
    }
    
    var showGroupPartnerInfo: Bool {
        return isGroupChat && direction == .received
    }
    
    var leadingPadding: CGFloat {
        return direction == .received ? 0 : horizontalPadding
    }
    
    var trailingPadding: CGFloat {
        return direction == .received ? horizontalPadding : 0
    }
    
    private let horizontalPadding: CGFloat = 25
    
    static let stubMessages: [MessageItem] = [
        .init(id: "1", isGroupChat: false, text: "Hello", type: .text, ownerUid: "1", timestamp: Date()),
        .init(id: "2", isGroupChat: true,text: "Hello back", type: .text, ownerUid: "2", timestamp: Date()),
        .init(id: "3", isGroupChat: false,text: "Check it out!!", type: .photo, ownerUid: "3", timestamp: Date()),
        .init(id: "4", isGroupChat: true,text: "Just hit play!", type: .video, ownerUid: "2", timestamp: Date()),
    ]
}

extension MessageItem {
    init(id: String, isGroupChat: Bool, dict: [String: Any]) {
        self.id = id
        self.isGroupChat = isGroupChat
        self.text = dict[.text] as? String ?? ""
        let type = dict[.type] as? String ?? "text"
        self.type = MessageType(type) ?? .text
        self.ownerUid = dict[.ownerUid] as? String ?? ""
        let timeInterval = dict[.timeStamp] as? TimeInterval ?? 0
        self.timestamp = Date(timeIntervalSince1970: timeInterval)
    }
}

extension String {
    static let `type` = "type"
    static let timeStamp = "timeStamp"
    static let ownerUid = "ownerUid"
    static let text = "text"
    static let photo = "photo"
    static let video = "video"
    static let audio = "audio"
}
