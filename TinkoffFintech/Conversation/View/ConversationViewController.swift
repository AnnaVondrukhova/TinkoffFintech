//
//  ConversationViewController.swift
//  TinkoffFintech
//
//  Created by Anya on 28.09.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITextFieldDelegate, AlertPresentable {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var sendView: UIView!
    @IBOutlet var sendTextField: CustomTextField!
    @IBOutlet var sendButton: UIButton!
    var channel: Channel?
    private var messages = [Message]()
    var currentTheme = ThemeManager.currentTheme
    private var firebaseManager: FirebaseManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendTextField.delegate = self
        
        tableView.estimatedRowHeight = 1.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(SentMessageCell.self, forCellReuseIdentifier: "sentMessageCell")
        tableView.register(ReceivedMessageCell.self, forCellReuseIdentifier: "receivedMessageCell")
        
        navigationItem.title = channel?.name
        navigationItem.largeTitleDisplayMode = .never
        
        sendButton.isUserInteractionEnabled = false
        sendButton.isHidden = true
        
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        firebaseManager = FirebaseManager()
        if let channel = self.channel {
            firebaseManager.getMessages(with: channel.identifier) { (messages) in
                let messages = messages.sorted { $0.created.compare($1.created) == .orderedDescending }
                self.messages.insert(contentsOf: messages, at: 0)
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentTheme = ThemeManager.currentTheme
        setUpUppearance()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.backgroundView = setUpBackgroundLabel()
        self.view.backgroundColor = currentTheme.colors.backgroundColor
    }
    
    func setUpUppearance() {
        sendView.backgroundColor = currentTheme.colors.UIElementColor
        sendTextField.backgroundColor = currentTheme.colors.backgroundColor
        sendTextField.layer.borderColor = UIColor.lightGray.cgColor
        sendTextField.layer.borderWidth = 1.0
        sendTextField.layer.cornerRadius = 16
        sendTextField.clipsToBounds = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        if !text.isEmpty{
            sendButton.isUserInteractionEnabled = true
            sendButton.isHidden = false
        } else {
            sendButton.isUserInteractionEnabled = false
            sendButton.isHidden = true
        }
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        view.endEditing(true)
        
        sendButton.isUserInteractionEnabled = false
        sendButton.isHidden = true
        
        guard let text = sendTextField.text,
            let channel = self.channel else { return }
        let message = Message(content: text)
        self.sendTextField.text = ""
        firebaseManager.sendMessage(channelId: channel.identifier, message: message) { (error) in
            if error != nil {
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                self.showAlert(title: "Error", message: "Failed to send message", preferredStyle: .alert, actions: [okAction], completion: nil)
            }
        }
        
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
        
        if message.senderId == Constants.senderId {
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
