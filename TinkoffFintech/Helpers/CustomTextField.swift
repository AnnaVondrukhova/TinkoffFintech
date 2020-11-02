//
//  CustomTextField.swift
//  TinkoffFintech
//
//  Created by Anya on 17.10.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomTextField: UITextField {
    
    var padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    @IBInspectable var leftInset: CGFloat = 0 {
        didSet {
            self.padding.left = leftInset
        }
    }
    
    @IBInspectable var rightInset: CGFloat = 0 {
        didSet {
            self.padding.right = rightInset
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
