//
//  URL+Extensions.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 14.08.24.
//

import Foundation
import AVFoundation
import UIKit

extension URL {
    
    static var stubUrl: URL {
        return URL(string: "wwww.test.url.com")!
    }
    
    func generateThumbnail() async throws -> UIImage? {
        let asset = AVAsset(url: self)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        imageGenerator.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 1.0, preferredTimescale: 60)
        
        return try await withCheckedThrowingContinuation { continuation in
            imageGenerator.generateCGImageAsynchronously(for: time) { cgImage, _, error in
                if let cgImage {
                    let thumbnail = UIImage(cgImage: cgImage)
                    continuation.resume(returning: thumbnail)
                } else {
                    continuation.resume(throwing: error ?? NSError(domain: "generateThumbnail", code: 0, userInfo: nil))
                }
            }
        }
    }
}
