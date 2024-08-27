//
//  BubbleTextView.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 14.06.24.
//

import SwiftUI

struct BubbleTextView: View {
    let item: MessageItem
    
    var body: some View {
        HStack(alignment: .bottom ,spacing: 3) {
            if item.showGroupPartnerInfo {
                CircularProfileImageView(item.sender?.profileImageUrl, size: .mini)
            }
            if item.direction == .sent {
                timeStampTextView()
            }
            Text(item.text)
                .padding(10)
                .background(item.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .applyTail(item.direction) // check Helpers/CustomModifiers.swift
            
            if item.direction == .received {
                timeStampTextView()
            }
            

        }
        .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5,x: 0,y: 20)
        .frame(maxWidth: .infinity,alignment: item.alignment)
        .padding(.leading, item.leadingPadding)
        .padding(.trailing, item.trailingPadding)
        
    }
    
    private func timeStampTextView() -> some View {
            Text(item.timestamp.formatToTime)
                .font(.footnote)
                .foregroundStyle(.gray)
    }
}

#Preview {
    ScrollView {
        BubbleTextView(item: .sentPlaceholder)
        BubbleTextView(item: .receivedPlaceholder)

    }
    .frame(maxWidth: .infinity)
    .background(Color.gray.opacity(0.4))
}
