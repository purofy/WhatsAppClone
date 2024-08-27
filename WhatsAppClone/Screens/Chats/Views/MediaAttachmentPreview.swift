//
//  MediaAttachmentPreview.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 06.08.24.
//

import SwiftUI

struct MediaAttachmentPreview: View {
    
    let mediaAttachments: [MediaAttachment]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(mediaAttachments) { attachment in
                    thumbnailImageView(attachment)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: Constants.listHeight)
        .frame(maxWidth: .infinity)
        .background(.whatsAppWhite)
    }
    
    private func thumbnailImageView(_ attachment: MediaAttachment) -> some View {
        Button {
            
        } label: {
            Image(uiImage: attachment.thumbnail)
                .resizable()
                .scaledToFill()
                .frame(width: Constants.ImageDimention, height: Constants.ImageDimention)
                .cornerRadius(5)
                .clipped()
                .overlay(alignment: .topTrailing) {
                    cancelButton()
                }
                .overlay {
                    playButton("play.fill")
                        .opacity(attachment.type == .video(UIImage(), .stubUrl) ? 1 : 0)
                }
            
        }
    }
    
    private func cancelButton() -> some View {
        Button {
            
        } label: {
            Image(systemName: "xmark")
                .scaledToFit()
                .imageScale(.small)
                .padding(5)
                .foregroundStyle(.white)
                .background(Color.white.opacity(0.5))
                .clipShape(Circle())
                .shadow(radius: 5)
                .padding(2)
                .bold()
        }
    }
    
    private func playButton(_ systemName: String) -> some View {
        Button {
            
        } label: {
            Image(systemName: systemName) // mic.fill
                .scaledToFit()
                .imageScale(.small)
                .padding(10)
                .foregroundStyle(.white)
                .background(Color.white.opacity(0.5))
                .clipShape(Circle())
                .shadow(radius: 5)
                .padding(2)
                .bold()
        }
    }
    
    private func audioAttachmentView() -> some View {
        ZStack {
            LinearGradient(colors: [.green, .green.opacity(0.8), .teal], startPoint: .topLeading, endPoint: .bottom)
            playButton("mic.fill")
        }
        .frame(width: Constants.ImageDimention * 2, height: Constants.ImageDimention)
        .cornerRadius(5)
        .clipped()
        .overlay(alignment: .topTrailing) {
            cancelButton()
        }
        .overlay(alignment: .bottomLeading) {
            Text("Audio")
                .lineLimit(1)
                .font(.caption)
                .padding(2)
                .frame(maxWidth: .infinity,alignment: .center)
                .foregroundColor(.white)
                .background(Color.white.opacity(0.3))
        }
    }
}

extension MediaAttachmentPreview {
    enum Constants {
        static let listHeight: CGFloat = 100
        static let ImageDimention: CGFloat = 80
    }
}

#Preview {
    MediaAttachmentPreview(mediaAttachments: [])
}
