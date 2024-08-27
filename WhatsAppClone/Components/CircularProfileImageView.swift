//
//  CircularProfileImageView.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 17.07.24.
//

import SwiftUI
import Kingfisher

struct CircularProfileImageView: View {
    let profileImageUrl: String?
    let size: Size
    let fallBackImage: FallBackImage
    
    init(_ profileImageUrl: String? = nil, size: Size = .medium) {
        self.profileImageUrl = profileImageUrl
        self.size = size
        self.fallBackImage = .directChatIcon
    }
    
    var body: some View {

        if profileImageUrl != nil {
            KFImage(URL(string: profileImageUrl ?? ""))
                .resizable()
                .placeholder { ProgressView()}
                .scaledToFit()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
        } else {
            placeholerImageView()
        }

    }
    
    private func placeholerImageView() -> some View {
        Image(systemName: fallBackImage.rawValue)
            .resizable()
            .scaledToFit()
            .imageScale(.large)
            .foregroundColor(Color.placeholder)
            .frame(width: size.dimension, height: size.dimension)
            .background(.white)
            .clipShape(Circle())
    }
}

extension CircularProfileImageView {
    enum Size {
        case mini, xSmall, smal, medium, large, xLarge
        case custom(CGFloat)
        
        var dimension: CGFloat {
            switch self {
            case .mini:
                return 30
            case .xSmall:
                return 40
            case .smal:
                return 50
            case .medium:
                return 60
            case .large:
                return 80
            case .xLarge:
                return 120
            case .custom(let size):
                return size
            }
        }
    }
    
    enum FallBackImage: String {
        case directChatIcon = "person.circle.fill"
        case groupChatIcon = "person.2.fill"
        
        init(for memberCount: Int) {
            switch memberCount {
            case 2:
                self = .directChatIcon
            default:
                self = .groupChatIcon
            }
        }
    }
}

extension CircularProfileImageView {
    init(_ channel: ChannelItem, size: Size) {
        self.profileImageUrl = channel.coverImageUrl
        self.size = size
        self.fallBackImage = FallBackImage(for: channel.membersCount)
    }
}

#Preview {
    CircularProfileImageView(size: .xLarge)
}
