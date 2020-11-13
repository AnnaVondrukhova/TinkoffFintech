//
//  Conversation.swift
//  TinkoffFintech
//
//  Created by Anya on 26.09.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Channel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    
    init? (identifier: String?, dict: [String: Any]) {
        guard let identifier = identifier,
            let name = dict["name"] as? String else { return nil }
        self.identifier = identifier
        self.name = name
        self.lastMessage = (dict["lastMessage"] as? String) ?? nil
        self.lastActivity = (dict["lastActivity"] as? Timestamp)?.dateValue() ?? nil
    }
}
