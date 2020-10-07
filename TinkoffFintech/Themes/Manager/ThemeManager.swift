//
//  ThemeManager.swift
//  TinkoffFintech
//
//  Created by Anya on 02.10.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import UIKit

enum Theme: Int, CaseIterable {
    case classic, day, night
    
    var colors: Colors {
        switch self {
        case .classic:
            return Constants.classicTheme
        case .day:
            return Constants.dayTheme
        case .night:
            return Constants.nightTheme
        }
    }
}

let themeKey = "selectedTheme"

struct ThemeManager {
    static var currentTheme = selectedTheme()
    
    static func selectedTheme() -> Theme {
        if let storedTheme = UserDefaults.standard.value(forKey: themeKey) as? Int {
            guard let theme = Theme(rawValue: storedTheme) else { return .classic}
            return theme
        } else {
            return .classic
        }
    }
    
    static func saveTheme(theme: Theme) {
        UserDefaults.standard.set(theme.rawValue, forKey: themeKey)
        UserDefaults.standard.synchronize()
        currentTheme = theme
    }
    
    static func applyTheme(theme: Theme) {
        let proxyNavigationBar = UINavigationBar.appearance()
        proxyNavigationBar.tintColor = theme.colors.tintColor
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = theme.colors.UIElementColor
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : theme.colors.baseFontColor]
            appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : theme.colors.baseFontColor]
            
            proxyNavigationBar.standardAppearance = appearance
            proxyNavigationBar.scrollEdgeAppearance = appearance
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.changeStatusBar(theme: theme)
            }
        } else {
            proxyNavigationBar.barTintColor = theme.colors.UIElementColor
            proxyNavigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : theme.colors.baseFontColor]
            proxyNavigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : theme.colors.baseFontColor]
            proxyNavigationBar.barStyle = theme.colors.barStyle
        }
        
        let proxyTableView = UITableView.appearance()
        proxyTableView.backgroundColor = theme.colors.backgroundColor
    }
    
    static func updateWindows() {
        let windows = UIApplication.shared.windows
        for window in windows {
            for view in window.subviews {
                view.removeFromSuperview()
                window.addSubview(view)
            }
        }
    }
}
