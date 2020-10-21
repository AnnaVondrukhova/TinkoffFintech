//
//  LoadOperation.swift
//  TinkoffFintech
//
//  Created by Anya on 14.10.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import UIKit

class LoadOperation: Operation {
    private let nameFilename = Constants.nameFileName
    private let descriptionFilename = Constants.descriptionFileName
    private let photoFilename = Constants.photoFileName
    var userName: String?
    var userDescription: String?
    var userPhoto: UIImage?
    
    override func main() {
        
        if isCancelled {
            return
        }

        //добавила sleep для наглядности ожидания
        sleep(2)
        
        if isCancelled {
            return
        }
        
        loadData()
    }
    
    func loadData() {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        do {
            self.userName = try String(contentsOf: directory.appendingPathComponent(self.nameFilename))
        } catch {
            print(error.localizedDescription)
        }
        
        do {
            self.userDescription = try String(contentsOf: directory.appendingPathComponent(self.descriptionFilename))
        } catch {
            print(error.localizedDescription)
        }
        
        do {
            let photoData = try Data(contentsOf: directory.appendingPathComponent(self.photoFilename))
            self.userPhoto = UIImage(data: photoData)
        } catch {
            print(error.localizedDescription)
        }
    }
}
