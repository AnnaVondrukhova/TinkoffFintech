//
//  User.swift
//  TinkoffFintech
//
//  Created by Anya on 21.09.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import UIKit

struct User {
    var name: String
    var description: String
    var photo: UIImage?
    
    static var testUser = User(name: "Marina Dudarenko", description: "UX/UI designer, web-designer\nMoscow, Russia")
}
