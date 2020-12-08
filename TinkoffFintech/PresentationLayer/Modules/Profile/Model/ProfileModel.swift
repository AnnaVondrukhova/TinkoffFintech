//
//  ProfileModel.swift
//  TinkoffFintech
//
//  Created by Anya on 13.11.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import UIKit

protocol UserInfoDelegate: class {
    var user: User { get set }
}

protocol UserInfoProtocol {
    var userInfoDelegate: UserInfoDelegate? { get set }
    func loadUserData(completion: @escaping() -> Void)
    func saveUserData(tag: Int, name: String?, description: String?, photo: UIImage?, completion: @escaping ([String: Bool], [String]) -> Void)
}

extension UserInfoProtocol {
    func saveUserData(tag: Int, name: String?, description: String?, photo: UIImage?, completion: @escaping ([String: Bool], [String]) -> Void) { }
}

protocol ProfileModelProtocol: UserInfoProtocol, ThemesProtocol {
}

class ProfileModel: ProfileModelProtocol {
    var userInfoDelegate: UserInfoDelegate?
    
    private let themeService: ThemeServiceProtocol
    private let gcdFileService: SaveDataToFileServiceProtocol
    private let operationFileService: SaveDataToFileServiceProtocol
    
    init(themeService: ThemeServiceProtocol,
         gcdFileService: SaveDataToFileServiceProtocol,
         operationFileService: SaveDataToFileServiceProtocol) {
        self.themeService = themeService
        self.gcdFileService = gcdFileService
        self.operationFileService = operationFileService
    }
    
    func currentTheme() -> Theme {
        return themeService.currentTheme
    }
    
    func loadUserData(completion: @escaping () -> Void) {
        //загрузка данных через GCD
        let loadService = gcdFileService
        
        //загрузка данных через Operation
//        let loadService = operationFileService
        
        loadService.loadData { (name, description, photo) in
            self.userInfoDelegate?.user.name = name ?? "No name"
            self.userInfoDelegate?.user.description = description ?? "No description"
            self.userInfoDelegate?.user.photo = photo
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func saveUserData(tag: Int, name: String?, description: String?, photo: UIImage?, completion: @escaping ([String: Bool], [String]) -> Void) {
        if tag == 0 {
            gcdFileService.saveData(name: name, description: description, photo: photo) { (savedFields, fails) in
                completion(savedFields, fails)
            }
        } else if tag == 1 {
            operationFileService.saveData(name: name, description: description, photo: photo) { (savedFields, fails) in
                completion(savedFields, fails)
            }
        }
    }
}
