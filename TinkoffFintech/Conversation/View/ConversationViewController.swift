//
//  ConversationViewController.swift
//  TinkoffFintech
//
//  Created by Anya on 28.09.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var conversation: Conversation?
    private var messages = [Message]()
    var currentTheme = ThemeManager.currentTheme
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let conversation = conversation {
            messages = conversation.messages.reversed()
        }

        tableView.estimatedRowHeight = 1.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(SentMessageCell.self, forCellReuseIdentifier: "sentMessageCell")
        tableView.register(ReceivedMessageCell.self, forCellReuseIdentifier: "receivedMessageCell")
        
        navigationItem.title = conversation?.name
        navigationItem.largeTitleDisplayMode = .never
        
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentTheme = ThemeManager.currentTheme
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.backgroundView = setUpBackgroundLabel()
        self.view.backgroundColor = currentTheme.colors.backgroundColor
    }

}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages.isEmpty {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
            return 0
        } else {
            tableView.backgroundView?.isHidden = true
            return messages.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let model = MessageViewModelFactory.createViewModel(with: message)
        
        if message.senderIsMe {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "sentMessageCell") as? SentMessageCell else { return SentMessageCell() }
            cell.configure(with: model)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "receivedMessageCell") as? ReceivedMessageCell else { return ReceivedMessageCell() }
            cell.configure(with: model)
            return cell
        }
    }
    
    func setUpBackgroundLabel() -> UILabel {
        let backgroundLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        backgroundLabel.text = "No messages"
        backgroundLabel.font = .systemFont(ofSize: 27, weight: .semibold)
        backgroundLabel.textColor = currentTheme.colors.secondaryFontColor
        backgroundLabel.textAlignment = .center
        backgroundLabel.transform = CGAffineTransform(scaleX: 1, y: -1)
        return backgroundLabel
    }
    
    
}
