//
//  OoperationDataManager.swift
//  TinkoffFintech
//
//  Created by Anya on 13.10.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import UIKit

class OperationFileService: SaveDataToFileServiceProtocol {
    let saveToFileManager: SaveToFileManagerProtocol
    
    init(saveToFileManager: SaveToFileManagerProtocol) {
        self.saveToFileManager = saveToFileManager
    }
    
    func saveData(name: String?, description: String?, photo: UIImage?, completion: @escaping ([String: Bool], [String]) -> Void) {
        print("saving with Operation")
        let saveOperation = SaveOperation(saveToFileManager: saveToFileManager, name: name, description: description, photo: photo)
        
        saveOperation.completionBlock = {
            DispatchQueue.main.async {
                completion(saveOperation.savedFields, saveOperation.fails)
            }
        }
        OperationQueue().addOperation(saveOperation)
    }
    
    func loadData(completion: @escaping (String?, String?, UIImage?) -> Void) {
        print("loading with Operation")
        let loadOperation = LoadOperation(saveToFileManager: saveToFileManager)
        
        loadOperation.completionBlock = {
            DispatchQueue.main.async {
                completion(loadOperation.userName, loadOperation.userDescription, loadOperation.userPhoto)
            }
        }
        OperationQueue().addOperation(loadOperation)
    }
}
