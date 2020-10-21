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
    
    private static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df
    }()
    
    static func createViewModel(with model: Message) -> MessageCellModel {
        let dateString = dateFormatter.string(from: model.created)
        return MessageCellModel(senderName: model.senderName, content: model.content, created: dateString)
    }
}
