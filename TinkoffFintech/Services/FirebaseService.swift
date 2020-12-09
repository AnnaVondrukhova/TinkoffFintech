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
    
    func getChannels(completion: @escaping ([Channel]) -> Void ) {
        let reference = db.collection("channels")
        var channels = [Channel]()
        
        let firebaseQueue = DispatchQueue.global()
        firebaseQueue.async {
            reference.getDocuments { (snapshot, _) in
                guard let snapshot = snapshot else { return }
                
                for document in snapshot.documents {
                    let channelIdentifier = document.documentID
                    let channelDict = document.data()
                    let channel = Channel(identifier: channelIdentifier, dict: channelDict)
                    channels.append(channel)
                }
                
                completion(channels)
            }
        }
    }
}
