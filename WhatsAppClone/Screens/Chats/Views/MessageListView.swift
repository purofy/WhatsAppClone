//
//  MessageListView.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 14.06.24.
//

import SwiftUI

struct MessageListView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = MessageListController
    
    private var viewModel: ChatRoomViewModel
    
    init(_ viewModel: ChatRoomViewModel) {
        self.viewModel = viewModel
    }
    
    func makeUIViewController(context: Context) -> MessageListController {
        let messageListController = MessageListController(viewModel)
        return messageListController
    }
    
    func updateUIViewController(_ uiViewController: MessageListController, context: Context) {
        
    }
}

#Preview {
    MessageListView(ChatRoomViewModel(.placeholder))
}
