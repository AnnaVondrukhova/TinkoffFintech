//
//  CoreAssembly.swift
//  TinkoffFintech
//
//  Created by Anya on 09.11.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation

protocol CoreAssemblyProtocol {
    var firebaseManager: FirebaseManagerProtocol { get }
    var coreDataManager: CoreDataManagerProtocol { get }
    var saveToFileManager: SaveToFileManagerProtocol { get }
    var fetchManager: FetchManagerProtocol { get }
}

class CoreAssembly: CoreAssemblyProtocol {
    lazy var firebaseManager: FirebaseManagerProtocol = FirebaseManager()
    lazy var coreDataManager: CoreDataManagerProtocol = CoreDataManager()
    lazy var saveToFileManager: SaveToFileManagerProtocol = SaveToFileManager()
    lazy var fetchManager: FetchManagerProtocol = FetchManager(coreDataManager: self.coreDataManager)
}
