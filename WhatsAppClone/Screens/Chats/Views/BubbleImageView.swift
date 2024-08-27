//
//  BubbleImageView.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 15.06.24.
//

import SwiftUI

struct BubbleImageView: View {
    
    let item: MessageItem
    
    var body: some View {
        HStack(alignment: .bottom ,spacing: 5) {
            if item.direction == .sent { Spacer()}
            
            if item.showGroupPartnerInfo {
                CircularProfileImageView(item.sender?.profileImageUrl, size: .mini)
                    .offset(y:5)
            }
            
            messageTextView()
            .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5,x: 0,y: 20)
            .overlay {
                playButton()
                    .opacity(item.type == .video ? 1 : 0)
            }
            
            if item.direction == .received { Spacer()}

        }
        .frame(maxWidth: .infinity, alignment: item.alignment)
        .padding(.leading, item.leadingPadding)
        .padding(.trailing, item.trailingPadding)
    }
    
    private func messageTextView() -> some View {
        VStack {
            Image(.stubImage0)
                .resizable()
                .scaledToFill()
                .frame(width: 220, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color(.systemGray5)))
                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color(.systemGray5)))
                .padding(5)
                .overlay(alignment: .bottomTrailing){
                    timeStampTextView()

                }
            
            if !item.text.isEmptyOrWhitespaces {
                Text(item.text)
                    .padding([.horizontal, .bottom],8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(width: 220)
            }   
        }
        .background(item.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .applyTail(item.direction)
    }
    
    private func timeStampTextView() -> some View {
        HStack {
            Text("21:34")
                .font(.system(size: 12))
            
            if item.direction == .sent {
                Image(.seen)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 15, height: 15)
            }
        }
        .padding(.vertical, 2.5)
        .padding(.horizontal, 8)
        .foregroundStyle(.white)
        .background(Color(.systemGray3))
        .clipShape(Capsule())
        .padding(12)
    }
    
    private func playButton() -> some View {
        Image(systemName: "play.fill")
            .padding()
            .imageScale(.large)
            .foregroundStyle(.gray)
            .background(.thinMaterial)
            .clipShape(Circle())
    }
    
    private func shareButton() -> some View {
        Button {
            
        }label: {
            Image(systemName: "arrowshape.turn.up.right.fill")
                .padding(10)
                .foregroundStyle(.white)
                .background(Color.gray)
                .background(.thinMaterial)
                .clipShape(Circle())
        }
    }
}

#Preview {
    BubbleImageView(item: .sentPlaceholder)
}
