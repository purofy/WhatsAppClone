//
//  MessageItem+Types.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 10.07.24.
//

import Foundation

enum AdminMessageType: String {
    case channelCreated
    case memberAdded
    case memberLeft
    case channelNameChanged
}

enum MessageDirection {
    case sent, received
    
    static var random: MessageDirection {
        return [MessageDirection.sent, .received].randomElement() ?? .sent
        
    }
}

enum MessageType {
    case admin(_ type: AdminMessageType), text, photo, video, audio
    
    var title: String {
        switch self {
        case .admin:
            return "admin"
        case .text:
            return "text"
        case .photo:
            return "photo"
        case .video:
            return "video"
        case .audio:
            return "audio"
        }
    }
    
    init?(_ stringValue: String) {
        switch stringValue {
        case "text":
            self = .text
        case "photo":
            self = .photo
        case "video":
            self = .video
        case "audio":
            self = .audio
        default:
            if let adminMessageType = AdminMessageType(rawValue: stringValue) {
                self = .admin(adminMessageType)
            } else {
                return nil
            }
        }
    }
}

extension MessageType: Equatable {
    static func ==(lhs: MessageType, rhs: MessageType) -> Bool {
        switch (lhs, rhs) {
        case (.admin(let lhsType), .admin(let rhsType)):
            return lhsType == rhsType
        case (.text, .text):
            return true
        case (.photo, .photo):
            return true
        case (.video, .video):
            return true
        case (.audio, .audio):
            return true
        default:
            return false
        }
    }
}
