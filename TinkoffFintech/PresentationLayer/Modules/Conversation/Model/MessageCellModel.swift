//
//  MessageCellModel.swift
//  TinkoffFintech
//
//  Created by Anya on 06.10.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation

struct MessageCellModel {
    let senderName: String
    let content: String
    let created: String
}

struct MessageViewModelFactory: ViewModelFactoryProtocol {
    typealias Model = MessageDB
    typealias ViewModel = MessageCellModel
    
    private static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df
    }()
    
    static func createViewModel(with model: MessageDB) -> MessageCellModel {
        let dateString = dateFormatter.string(from: model.created)
        return MessageCellModel(senderName: model.senderName, content: model.content, created: dateString)
    }
}
