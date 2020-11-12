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
    func makeFetchedResultsController<T: NSManagedObject>(sortDescriptors: [NSSortDescriptor]?,
                                                          predicate: NSPredicate?) -> NSFetchedResultsController<T>?
}

class FetchManager: FetchManagerProtocol {
    let coreDataManager: CoreDataManagerProtocol
    
    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
    }
    
    func makeFetchedResultsController<T: NSManagedObject>(sortDescriptors: [NSSortDescriptor]?,
                                                          predicate: NSPredicate?) -> NSFetchedResultsController<T>? {
        guard let fetchRequest = T.fetchRequest() as? NSFetchRequest<T> else { return NSFetchedResultsController() }
        
        if let sortDescriptors = sortDescriptors {
            fetchRequest.sortDescriptors = sortDescriptors
        }
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        
        fetchRequest.resultType = .managedObjectResultType

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: coreDataManager.mainContext,
                                                                  sectionNameKeyPath: nil, cacheName: nil)

        return fetchedResultsController
    }
}
