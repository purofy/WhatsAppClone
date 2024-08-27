//
//  MessageListController.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 13.06.24.
//

import Foundation
import UIKit
import SwiftUI
import Combine

final class MessageListController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .clear
        view.backgroundColor = .clear
        setUpViews()
        setUpMessageListeners()
    }
    
    init(_ viewModel: ChatRoomViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: ChatRoomViewModel
    private var subscriptions = Set<AnyCancellable>()
    private let cellIdentifier = "MessageListControllerCells"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGray3
    
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let backgroundImageView: UIView = {
        let backgroundView = UIImageView(image: .chatbackground)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()
    
    private func setUpViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func setUpMessageListeners() {
        viewModel.$messages
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink {[weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)
    }
}

extension MessageListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let message = viewModel.messages[indexPath.row]
        cell.contentConfiguration = UIHostingConfiguration {
            switch message.type {
            case .text:
                BubbleTextView(item: message)
            case .video, .photo:
                BubbleImageView(item: message)
            case .audio:
                BubbleAudioView(item: message)
            case .admin(let admintype):
                switch admintype {
                case .channelCreated:
                    ChannelCreationTextView()
                    if viewModel.channel.isGroupChat {
                        AdminMessageTextView(channel: viewModel.channel)
                    }

                default:
                   Text("Unknown")
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension // Auto resize
    }
}


#Preview {
    MessageListView(ChatRoomViewModel(.placeholder))
        .ignoresSafeArea()
}
