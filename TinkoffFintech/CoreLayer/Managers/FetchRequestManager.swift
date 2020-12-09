//
//  FetchRequestManager.swift
//  TinkoffFintech
//
//  Created by Anya on 10.11.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import CoreData

protocol FetchManagerProtocol {
    func makeRequest<T: NSManagedObject>(sortDescriptors: [NSSortDescriptor]?, predicate: NSPredicate?) -> NSFetchRequest<T>
}

class FetchManager {
    func makeRequest<T: NSManagedObject>(sortDescriptors: [NSSortDescriptor]?, predicate: NSPredicate?) -> NSFetchRequest<T> {
        guard let fetchRequest = T.fetchRequest() as? NSFetchRequest<T> else { return NSFetchRequest() }
        
        if let sortDescriptors = sortDescriptors {
            fetchRequest.sortDescriptors = sortDescriptors
        }
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        
        return fetchRequest
    }
}
