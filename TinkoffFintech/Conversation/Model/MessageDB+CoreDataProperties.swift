//
//  MessageDB+CoreDataProperties.swift
//  TinkoffFintech
//
//  Created by Anya on 27.10.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//
//

import Foundation
import CoreData


extension MessageDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageDB> {
        return NSFetchRequest<MessageDB>(entityName: "MessageDB")
    }

    @NSManaged public var content: String
    @NSManaged public var created: Date
    @NSManaged public var identifier: String
    @NSManaged public var senderId: String
    @NSManaged public var senderName: String
    @NSManaged public var channel: ChannelDB?

}
