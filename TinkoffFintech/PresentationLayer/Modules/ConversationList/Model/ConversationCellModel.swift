//
//  ConversationViewModelFactory.swift
//  TinkoffFintech
//
//  Created by Anya on 06.10.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation

struct ConversationCellModel {
    let name: String
    let message: String?
    let date: Date?
}

protocol ViewModelFactoryProtocol {
    associatedtype Model
    associatedtype ViewModel
    
    static func createViewModel(with model: Model) -> ViewModel
}

struct ConversationViewModelFactory: ViewModelFactoryProtocol {
    typealias Model = ChannelDB
    typealias ViewModel = ConversationCellModel
    
    static func createViewModel(with model: ChannelDB) -> ConversationCellModel {
        let name = model.name
        let message = model.lastMessage
        let date = model.lastActivity
        
        let conversationCellModel = ConversationCellModel(name: name, message: message, date: date)
        
        return conversationCellModel
    }
    
}
