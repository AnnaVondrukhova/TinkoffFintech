//
//  FirebaseManager.swift
//  TinkoffFintech
//
//  Created by Anya on 16.10.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    private let db = Firestore.firestore()
    
    func getChannels(completion: @escaping ([Channel], [Channel], [String]) -> Void) {
        print("***Listened")
        let reference = db.collection("channels")
        
        
        let firebaseQueue = DispatchQueue.global()
        firebaseQueue.async {
            reference.addSnapshotListener { (snapshot, _) in
                guard let snapshot = snapshot else { return }
                
                var addedChannels = [Channel]()
                var modifiedChannels = [Channel]()
                var removedChannels = [String]()
                
                snapshot.documentChanges.forEach { (diff) in
                    if (diff.type == .added) {
                        let channelIdentifier = diff.document.documentID
                        let channelDict = diff.document.data()
                        if let channel = Channel(identifier: channelIdentifier, dict: channelDict) {
                            addedChannels.append(channel)
                        }
                        
                    }
                    if (diff.type == .modified) {
                        let channelIdentifier = diff.document.documentID
                        let channelDict = diff.document.data()
                        if let channel = Channel(identifier: channelIdentifier, dict: channelDict) {
                            modifiedChannels.append(channel)
                        }
                    }
                    if (diff.type == .removed) {
                        removedChannels.append(diff.document.documentID)
                    }
                }
                
                DispatchQueue.main.async {
                    completion(addedChannels, modifiedChannels, removedChannels)
                }
            }
        }
    }
    
    func addChannel(name: String, completion: @escaping (String?, Error?) -> Void) {
        let reference = db.collection("channels")
        
        let firebaseQueue = DispatchQueue.global()
        firebaseQueue.async {
            var channelRef: DocumentReference? = nil
            channelRef = reference.addDocument(data: ["name": name]) {error in
                if let error = error {
                    print ("Error adding channel")
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                } else {
                    print("Successfully added channel")
                    DispatchQueue.main.async {
                        completion(channelRef?.documentID, nil)
                    }
                }
            }
        }
    }
    
    func getMessages(with channelId: String, completion: @escaping([Message]) -> Void) {
        let reference = db.collection("channels").document(channelId).collection("messages")
        
        let firebaseQueue = DispatchQueue.global()
        firebaseQueue.async {
            reference.addSnapshotListener { (snapshot, _) in
                guard let snapshot = snapshot else { return }
                var messages = [Message]()

                snapshot.documentChanges.forEach { (diff) in
                    if (diff.type == .added) {
                        let messageDict = diff.document.data()
                        if let message = Message(dict: messageDict) {
                            messages.append(message)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    completion(messages)
                }
            }
        }
    }
    
    func sendMessage(channelId: String, message: Message, completion: @escaping (Error?) -> Void) {
        let messageData = ["content": message.content,
                           "created": Timestamp(date: message.created),
                           "senderId": message.senderId,
                           "senderName": message.senderName] as [String : Any]
        
        let reference = db.collection("channels").document(channelId).collection("messages")
        let firebaseQueue = DispatchQueue.global()
        firebaseQueue.async {
            reference.addDocument(data: messageData) { error in
                print("***Error!")
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
}
