//
//  PresentationAssembly.swift
//  TinkoffFintech
//
//  Created by Anya on 09.11.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation

protocol PresentationAssemblyProtocol {
    func conversationListViewController() -> ConversationListViewController
    func conversatioViewController() -> ConversationViewController
    func profileViewController() -> ProfileViewController
    func themesViewController() -> ThemesViewController
}

class PresentationAssembly: PresentationAssemblyProtocol {
    private let serviceAssembly: ServiceAssemblyProtocol
    
    init(serviceAssembly: ServiceAssemblyProtocol) {
        self.serviceAssembly = serviceAssembly
    }
    
    func conversationListViewController() -> ConversationListViewController {
        let conversationListVC = ConversationListViewController(presentationAssembly: self,
                                                                themeService: serviceAssembly.themeService,
                                                                saveToFileService: serviceAssembly.gcdFileService,
                                                                channelsService: serviceAssembly.channelsService,
                                                                fetchedResultsProvider: serviceAssembly.channelsFetchResultsProvider)
        return conversationListVC
    }
    
    func conversatioViewController() -> ConversationViewController {
        let conversationVC = ConversationViewController(themeService: serviceAssembly.themeService,
                                                        messageService: serviceAssembly.messagesService,
                                                        fetchedResultsProvider: serviceAssembly.messagesFetchResultsProvider)
        return conversationVC
    }
    
    func profileViewController() -> ProfileViewController {
        let profileVC = ProfileViewController(themeService: serviceAssembly.themeService,
                                              gcdFileService: serviceAssembly.gcdFileService,
                                              operationFileService: serviceAssembly.operationFileService)
        return profileVC
    }
    
    func themesViewController() -> ThemesViewController {
        let themesVC = ThemesViewController(themeService: serviceAssembly.themeService)
        return themesVC
    }
}
