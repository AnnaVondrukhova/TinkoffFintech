//
//  FirebaseChannelsService.swift
//  TinkoffFintech
//
//  Created by Anya on 09.11.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol ChannelsServiceProtocol {
    func getChannels(currentChannels: [ChannelDB])
    func addChannel(in vc: AlertPresentableProtocol, channelName: String)
}

class ChannelsService: ChannelsServiceProtocol {
    let firebaseManager: FirebaseManagerProtocol
    let coreDataManager: CoreDataManagerProtocol
    
    init(firebaseManager: FirebaseManagerProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.firebaseManager = firebaseManager
        self.coreDataManager = coreDataManager
    }
    
    func getChannels(currentChannels: [ChannelDB]) {
        print("Get channels")
        firebaseManager.getChannels { (addedChannels, modifiedChannels, removedChannelsIDs) in
            self.coreDataManager.performSave { (context) in
                for channel in addedChannels {
                    if currentChannels.contains(where: { $0.identifier == channel["identifier"] as? String}) {
                        continue
                    } else {
                        print("performSave - add channel")
                        let identifier = channel["identifier"] as? String
                        let dict = (channel["dict"] as? [String: Any]) ?? [ : ]
                        ChannelDB.createChannel(context: context, identifier: identifier, dict: dict)
                    }
                    
                }

                for channel in modifiedChannels {
                    let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
                    guard let identifier = channel["identifier"] as? String else { continue }
                    request.predicate = NSPredicate(format: "identifier = %@", identifier)
                    do {
                        let channelDB = try context.fetch(request).first
                        if let channelDB = channelDB,
                            let dict = channel["dict"] as? [String: Any] {
                            channelDB.modify(dict: dict)
                        }
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }

                for channelId in removedChannelsIDs {
                    let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
                    request.predicate = NSPredicate(format: "identifier = %@", channelId)
                    do {
                        let channelDB = try context.fetch(request).first
                        if let channelDB = channelDB {
                            context.delete(channelDB)
                        }
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func addChannel(in vc: AlertPresentableProtocol, channelName: String) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        if !channelName.isEmpty,
        !(channelName.replacingOccurrences(of: " ", with: "") == "") {
            
            firebaseManager.addChannel(name: channelName) { (error) in
                if error != nil {
                    vc.showAlert(title: "Error", message: "Failed to create channel", preferredStyle: .alert, actions: [okAction], completion: nil)
                }
            }
        } else {
            vc.showAlert(title: "Error", message: "Please enter channel name", preferredStyle: .alert, actions: [okAction], completion: nil)
        }
    }
}
