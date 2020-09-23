//
//  AlertService.swift
//  TinkoffFintech
//
//  Created by Anya on 22.09.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import UIKit

class AlertService {
    static func showAlert(in vc: UIViewController, message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
}
