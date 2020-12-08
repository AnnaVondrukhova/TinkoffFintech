//
//  AlertService.swift
//  TinkoffFintech
//
//  Created by Anya on 22.09.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import UIKit

protocol AlertPresentableProtocol {
    var currentTheme: Theme { get set }
    func showAlert(title: String?, message: String?, preferredStyle: UIAlertController.Style, actions: [UIAlertAction], completion: (() -> Void)?)
}

extension AlertPresentableProtocol where Self: UIViewController {
    func showAlert(title: String?, message: String?, preferredStyle: UIAlertController.Style, actions: [UIAlertAction], completion: (() -> Void)?) {
        let currentTheme = self.currentTheme
        let attributedTitle = NSAttributedString(string: title ?? "", attributes: [NSAttributedString.Key.foregroundColor: currentTheme.colors.baseFontColor,
                                                                                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)])
        let attributedMessage = NSAttributedString(string: message ?? "", attributes: [NSAttributedString.Key.foregroundColor: currentTheme.colors.baseFontColor,
                                                                                       NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.setValue(attributedTitle, forKey: "attributedTitle")
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = currentTheme.colors.UIElementColor
        
        actions.forEach { alertController.addAction($0) }

        present(alertController, animated: true, completion: completion)
    }
}
