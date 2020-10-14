//
//  ConversationListViewController.swift
//  TinkoffFintech
//
//  Created by Anya on 26.09.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import UIKit

enum Sections: Int, CaseIterable {
    case online
    case history
}

class ConversationListViewController: UIViewController, ThemesPickerDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    private var onlineConversations = [Conversation]()
    private var historyConversations = [Conversation]()
    
    var updateAppearanceClosure: ((Theme) -> ())? = nil
    var currentTheme = ThemeManager.currentTheme {
        didSet {
            updateAppearance(theme: currentTheme)
        }
    }
    
    var user = User()
    var saveDataManager: SaveDataManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        onlineConversations = TestData().conversations.filter({ $0.isOnline == true})
        historyConversations = TestData().conversations.filter({ ($0.isOnline == false)&&(!$0.messages.isEmpty)})
        
        self.updateAppearanceClosure = { [weak self] theme in
            self?.currentTheme = theme
        }
        
        //загрузка данных через GCD
        saveDataManager = GCDDataManager()
                
        //загрузка данных через Operation
//        saveDataManager = OperationDataManager()
        
        saveDataManager.loadData { (name, _, photo) in
            DispatchQueue.main.async {
                self.user.name = name ?? "No name"
                self.user.photo = photo
                
                self.configureNavigationElements()
            }
        }
        
        currentTheme = ThemeManager.currentTheme
        tableView.register(ConversationCell.self, forCellReuseIdentifier: "conversationCell")
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureNavigationElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func configureNavigationElements() {
        let userButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        let userAvatarView = AvatarView(frame: userButton.frame)
        userAvatarView.backgroundColor = Constants.userPhotoBackgrounColor
        userAvatarView.layer.cornerRadius = userAvatarView.frame.width/2
        userAvatarView.configure(image: user.photo, name: user.name, fontSize: Constants.navigationBarAvatarFontSize, cornerRadius: userAvatarView.frame.width/2)
        userAvatarView.isUserInteractionEnabled = true
        userAvatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rightBarButtonPressed)))
        
        userButton.addSubview(userAvatarView)
        
        let rightBarButton = UIBarButtonItem(customView: userButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        self.navigationItem.leftBarButtonItem?.image = UIImage(named: "settings")
    }
    
    func updateAppearance(theme: Theme) {
        ThemeManager.applyTheme(theme: theme)
        ThemeManager.updateWindows()
        tableView.reloadData()
    }
    
    @IBAction func leftBarButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Themes", bundle: nil)
        guard let themesVC = storyboard.instantiateViewController(withIdentifier: "themesVC") as? ThemesViewController else { return }
        
        themesVC.delegate = self
        if let closure = updateAppearanceClosure {
            themesVC.setThemeClosure = closure
        }
        navigationController?.pushViewController(themesVC, animated: true)
    }
    
    @objc func rightBarButtonPressed() {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        guard let userDetailsVC = storyboard.instantiateViewController(withIdentifier: "profileVC") as? ProfileViewController else { return }
        userDetailsVC.delegate = self
        
        present(userDetailsVC, animated: true, completion: nil)
    }
}

extension ConversationListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Sections(rawValue: section) else { return 0 }
        
        switch section {
        case .online:
            return onlineConversations.count
        case .history:
            return historyConversations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Sections(rawValue: indexPath.section) else { return ConversationCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell") as? ConversationCell else { return ConversationCell() }
        let model: ConversationCellModel
        
        switch section {
        case .online:
            model = ConversationViewModelFactory.createViewModel(with: onlineConversations[indexPath.row])
        case .history:
            model = ConversationViewModelFactory.createViewModel(with: historyConversations[indexPath.row])
        }

        cell.setUpAppearance(with: model, theme: currentTheme)
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Sections(rawValue: indexPath.section) else { return }
        let storyboard = UIStoryboard(name: "Conversation", bundle: nil)
        guard let conversationVC = storyboard.instantiateViewController(withIdentifier: "conversationVC") as? ConversationViewController else { return }
        
        switch section {
        case .online:
            conversationVC.conversation = onlineConversations[indexPath.row]
        case .history:
            conversationVC.conversation = historyConversations[indexPath.row]
        }
        
        navigationController?.pushViewController(conversationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Sections(rawValue: section) else { return nil }
        
        switch section {
        case .online:
            return "Online"
        case .history:
            return "History"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
