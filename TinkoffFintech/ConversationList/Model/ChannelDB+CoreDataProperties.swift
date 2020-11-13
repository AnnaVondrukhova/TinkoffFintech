//
//  ChannelDB+CoreDataProperties.swift
//  TinkoffFintech
//
//  Created by Anya on 27.10.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//
//

import Foundation
import CoreData


extension ChannelDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChannelDB> {
        return NSFetchRequest<ChannelDB>(entityName: "ChannelDB")
    }

    @NSManaged public var identifier: String
    @NSManaged public var lastActivity: Date?
    @NSManaged public var lastMessage: String?
    @NSManaged public var name: String
    @NSManaged public var messages: NSSet?

}

// MARK: Generated accessors for messages
extension ChannelDB {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: MessageDB)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: MessageDB)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}
