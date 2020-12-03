//
//  SaveToFileManagerMock.swift
//  TinkoffFintechTests
//
//  Created by Anya on 30.11.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

@testable import TinkoffFintech
import Foundation

class SaveToFileManagerMock: SaveToFileManagerProtocol {
    var savedString = ""
    var savedData = Data()
 
    func saveString(to file: String, string: String) -> Bool {
        savedString = string
        return true
    }
    
    func saveData(to file: String, data: Data) -> Bool {
        savedData = data
        return true
    }
    
    func loadString(from file: String) -> String? {
        return nil
    }
    
    func loadData(from file: String) -> Data? {
        return nil
    }
}
