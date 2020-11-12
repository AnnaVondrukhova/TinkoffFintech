//
//  ConversationListViewController.swift
//  TinkoffFintech
//
//  Created by Anya on 26.09.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import UIKit

class ConversationListViewController: UIViewController, ThemesPickerDelegate, AlertPresentableProtocol, ChannelsFetchedResultsServiceDelegate {
    
    @IBOutlet var tableView: UITableView!

    var updateAppearanceClosure: ((Theme) -> Void)?
    var currentTheme: Theme {
        didSet {
            updateAppearance(theme: currentTheme)
        }
    }
    
    var user = User()
    private let presentationAssembly: PresentationAssemblyProtocol
    private let themeService: ThemeServiceProtocol
    private let saveToFileService: SaveDataToFileServiceProtocol
    private let channelsService: ChannelsServiceProtocol
    private let dataProvider: ChannelsDataProviderProtocol
    private var fetchedResultsProvider: ChannelsFetchedResultsServiceProtocol
    
    init(presentationAssembly: PresentationAssemblyProtocol,
         themeService: ThemeServiceProtocol,
         saveToFileService: SaveDataToFileServiceProtocol,
         channelsService: ChannelsServiceProtocol,
         fetchedResultsProvider: ChannelsFetchedResultsServiceProtocol) {
        self.presentationAssembly = presentationAssembly
        self.themeService = themeService
        self.saveToFileService = saveToFileService
        self.channelsService = channelsService
        self.fetchedResultsProvider = fetchedResultsProvider
        self.dataProvider = ChannelsDataProvider(fetchedResultsProvider: self.fetchedResultsProvider, channelsService: self.channelsService, themeService: self.themeService)
        
        print("Current theme: \(themeService.currentTheme.rawValue)")
        self.currentTheme = themeService.currentTheme
        
        super.init(nibName: "ConversationList", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Constants.senderId)
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last?.appendingPathComponent("Chat.sqlite") as Any)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(ConversationCell.self, forCellReuseIdentifier: "conversationCell")
        tableView.delegate = dataProvider
        tableView.dataSource = dataProvider
        fetchedResultsProvider.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(showMessages(withNotification:)),
                                               name: NSNotification.Name(rawValue: "DidSelectRow notification"),
                                               object: nil)
        
        self.updateAppearanceClosure = { [weak self] theme in
            self?.currentTheme = theme
        }
        
        fetchedResultsProvider.makeFetchedResultsController()
        getChannels()
        
        saveToFileService.loadData { (name, _, photo) in
            DispatchQueue.main.async {
                self.user.name = name ?? "No name"
                Constants.senderName = name ?? "No name"
                self.user.photo = photo
                
                self.configureNavigationElements()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureNavigationElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func getChannels() {
        let currentChannels = fetchedResultsProvider.fetchedResultsController?.fetchedObjects ?? []
        channelsService.getChannels(currentChannels: currentChannels)
    }
        
    func configureNavigationElements() {
        let userButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        let userAvatarView = AvatarView(frame: userButton.frame)
        userAvatarView.backgroundColor = Constants.userPhotoBackgrounColor
        userAvatarView.layer.cornerRadius = userAvatarView.frame.width / 2
        userAvatarView.configure(image: user.photo, name: user.name, fontSize: Constants.navigationBarAvatarFontSize, cornerRadius: userAvatarView.frame.width / 2)
        userAvatarView.isUserInteractionEnabled = true
        userAvatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileBarButtonPressed)))
        
        userButton.addSubview(userAvatarView)
        
        let profileRightBarButton = UIBarButtonItem(customView: userButton)
        let addChannelRightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addChannelBarButtonPressed))
        
        let settingsLeftBarBurron = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(settingsLeftBarButtonPressed))
                
        self.navigationItem.leftBarButtonItem = settingsLeftBarBurron
        self.navigationItem.rightBarButtonItems = [profileRightBarButton, addChannelRightBarButton]
        self.navigationItem.title = "Tinkoff Chat"
    }
    
    func updateAppearance(theme: Theme) {
        themeService.applyTheme(theme: theme)
        themeService.updateWindows()
        tableView.reloadData()
    }
    
    @objc func settingsLeftBarButtonPressed(_ sender: Any) {
        let themesVC = presentationAssembly.themesViewController()
        
        themesVC.delegate = self
        if let closure = updateAppearanceClosure {
            themesVC.setThemeClosure = closure
        }
        navigationController?.pushViewController(themesVC, animated: true)
    }
    
    @objc func addChannelBarButtonPressed() {
        let alertController = UIAlertController(title: "Add channel", message: nil, preferredStyle: .alert)
        alertController.addTextField { (tf) in
            tf.placeholder = "Enter hannel name"
        }
        
        let  createAction = UIAlertAction(title: "Create", style: .default) { (_) in
            if let channelName = alertController.textFields?.first?.text {
                self.channelsService.addChannel(in: self, channelName: channelName)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func profileBarButtonPressed() {
        let profileVC = presentationAssembly.profileViewController()
        profileVC.delegate = self
        
        present(profileVC, animated: true, completion: nil)
    }
    
    @objc func showMessages(withNotification notification: Notification) {
        guard let userInfo = notification.userInfo,
            let channel = userInfo["channel"] as? ChannelDB else { return }
        let conversationVC = presentationAssembly.conversatioViewController()
        conversationVC.channel = channel
        navigationController?.pushViewController(conversationVC, animated: true)
    }
}
