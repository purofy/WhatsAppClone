//
//  MediaPickerItem+Types.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 08.08.24.
//

import SwiftUI


struct VideoPickerTransferable: Transferable {
    
    let url: URL
    
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { exportingFile in
            return .init(exportingFile.url)
        } importing: { receivedTransferedFile in
            let original = receivedTransferedFile.file
            let uniqueName = "\(UUID().uuidString).mov"
            let copiedFile = URL.documentsDirectory.appendingPathComponent(uniqueName)
            try? FileManager.default.copyItem(at: original, to: copiedFile)
            return .init(url: copiedFile)
        }
    }
}


struct MediaAttachment: Identifiable {
    let id: String
    let type: MediaAttachmentType
    
    var thumbnail: UIImage {
        switch type {
            case .photo(let thumbnail):
                return thumbnail
            case .video(let thumbnail, _):
                return thumbnail
            case .audio:
                return UIImage()
        }
    }
}


enum MediaAttachmentType: Equatable {
    case photo(_ thumbnail: UIImage)
    case video(_ thumbnail: UIImage, _ url: URL)
    case audio
    
    static func == (lhs: MediaAttachmentType, rhs: MediaAttachmentType) -> Bool {
        switch (lhs, rhs) {
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
