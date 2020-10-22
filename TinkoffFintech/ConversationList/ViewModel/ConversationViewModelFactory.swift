//
//  ConversationViewModelFactory.swift
//  TinkoffFintech
//
//  Created by Anya on 06.10.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation

protocol ViewModelFactory {
    associatedtype Model
    associatedtype ViewModel
    
    static func createViewModel(with model: Model) -> ViewModel
}

struct ConversationViewModelFactory: ViewModelFactory {
    typealias Model = Conversation
    typealias ViewModel = ConversationCellModel
    
    static func createViewModel(with model: Conversation) -> ConversationCellModel {
        let name = model.name.isEmpty ? "No name" : model.name
        let message = model.messages.last?.text ?? ""
        let date = Date(timeIntervalSince1970: TimeInterval(model.messages.last?.date ?? Int(Date().timeIntervalSince1970)))
        let hasUnreadMessages = !(model.messages.last?.isRead ?? true)
        
        let conversationCellModel = ConversationCellModel(name: name, message: message, date: date, isOnline: model.isOnline, hasUnreadMessages: hasUnreadMessages)
        
        return conversationCellModel
    }
}
