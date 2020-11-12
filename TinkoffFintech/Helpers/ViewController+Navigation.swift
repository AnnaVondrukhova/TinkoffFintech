//
//  ViewController+Navigation.swift
//  TinkoffFintech
//
//  Created by Anya on 10.11.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func embedInNavigationController() -> UINavigationController {
        let nc = UINavigationController()
        nc.viewControllers = [self]
        return nc
    }
}
