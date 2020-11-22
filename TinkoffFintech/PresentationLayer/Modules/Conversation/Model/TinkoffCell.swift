//
//  TinkoffCell.swift
//  TinkoffFintech
//
//  Created by Anya on 21.11.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import UIKit

class TinkoffCell: CAEmitterCell {
    override init() {
        super.init()
        self.birthRate = 20
        self.lifetime = 0.5
        self.velocity = 150
        self.velocityRange = 50
        self.emissionLongitude = 0
        self.emissionRange = .pi
        self.spinRange = 10
        self.scale = 0.05
        self.scaleRange = 0.25
        self.alphaSpeed = -1
        self.contents = UIImage(named: "tinkoffLogo")?.cgImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
