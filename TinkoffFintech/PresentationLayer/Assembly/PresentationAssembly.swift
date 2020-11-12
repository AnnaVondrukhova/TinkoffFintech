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
        var model = conversationListModel()
        let conversationListVC = ConversationListViewController(presentationAssembly: self,
                                                                model: model)
        model.fetchDelegate = conversationListVC
        model.userInfoDelegate = conversationListVC
        return conversationListVC
    }
    
    private func conversationListModel() -> ConversationListModelProtocol {
        return ConversationListModel(themeService: serviceAssembly.themeService,
                                     saveToFileService: serviceAssembly.gcdFileService,
                                     channelsService: serviceAssembly.channelsService,
                                     fetchedResultsProvider: serviceAssembly.channelsFetchResultsProvider)
    }
    
    func conversatioViewController() -> ConversationViewController {
        var model = conversationModel()
        let conversationVC = ConversationViewController(model: model)
        
        model.fetchDelegate = conversationVC
        return conversationVC
    }
    
    private func conversationModel() -> ConversationModelProtocol {
        return ConversationModel(themeService: serviceAssembly.themeService,
                                 messageService: serviceAssembly.messagesService,
                                 fetchedResultsProvider: serviceAssembly.messagesFetchResultsProvider)
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
