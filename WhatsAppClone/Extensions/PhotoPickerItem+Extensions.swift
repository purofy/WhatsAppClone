//
//  PhotoPickerItem+Extensions.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 08.08.24.
//

import Foundation
import PhotosUI
import SwiftUI

extension PhotosPickerItem {
    var isVideo: Bool {
        let videoUTTypes: [UTType] = [
            .avi,
            .video,
            .mpeg2Video,
            .mpeg4Movie,
            .quickTimeMovie,
            .audiovisualContent,
            .mpeg,
            .appleProtectedMPEG4Video
        ]
        
        return videoUTTypes.contains(where: supportedContentTypes.contains)
    }
}
