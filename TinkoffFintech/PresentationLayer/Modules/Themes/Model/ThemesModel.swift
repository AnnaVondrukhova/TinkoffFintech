//
//  ThemesModel.swift
//  TinkoffFintech
//
//  Created by Anya on 13.11.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation

protocol ThemesProtocol {
    func currentTheme() -> Theme
    func setTheme(theme: Theme)
}

extension ThemesProtocol {
    func setTheme(theme: Theme) { }
}

protocol ThemesModelProtocol: ThemesProtocol {
    func saveTheme(theme: Theme)
}

class ThemesModel: ThemesModelProtocol {
    private let themeService: ThemeServiceProtocol
    
    init(themeService: ThemeServiceProtocol) {
        self.themeService = themeService
    }
    
    func currentTheme() -> Theme {
        return themeService.currentTheme
    }
    
    func saveTheme(theme: Theme) {
        themeService.saveTheme(theme: theme)
    }
}
