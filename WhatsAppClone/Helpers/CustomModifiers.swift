//
//  CustomModifiers.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 14.06.24.
//

import SwiftUI

private struct BubbleTailModifieer: ViewModifier {
    var direction: MessageDirection
    
    func body(content: Content) -> some View {
        content.overlay(alignment: direction == .received ? .bottomLeading : .bottomTrailing) {
            BubbleTailView(direction: direction)
        }
    }
}

extension View {
    func applyTail(_ direction: MessageDirection) -> some View {
        self.modifier(BubbleTailModifieer(direction: direction))
    }
}
