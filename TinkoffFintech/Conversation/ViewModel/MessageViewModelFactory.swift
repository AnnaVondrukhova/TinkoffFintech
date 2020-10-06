//
//  MessageCellModel.swift
//  TinkoffFintech
//
//  Created by Anya on 28.09.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation

struct MessageViewModelFactory: ViewModelFactory {
    typealias Model = Message
    typealias ViewModel = MessageCellModel
    
    static func createViewModel(with model: Message) -> MessageCellModel {
        return MessageCellModel(text: model.text)
    }
}
