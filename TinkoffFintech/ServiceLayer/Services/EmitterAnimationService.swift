//
//  EmitterAnimationService.swift
//  TinkoffFintech
//
//  Created by Anya on 24.11.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import UIKit

class EmitterAnimationService {
    lazy var particleEmitter: CAEmitterLayer = {
        let emitter = CAEmitterLayer()
        emitter.emitterShape = .point
        emitter.renderMode = .additive
        return emitter
    }()
    let tinkoffCell = TinkoffCell()
    var vc: UIViewController
    
    init(vc: UIViewController) {
        self.vc = vc
    }
    
    func showParticles() {
        particleEmitter.emitterCells = [tinkoffCell]
        vc.view.layer.addSublayer(particleEmitter)
    }
    
    func handleTap(_ sender: UILongPressGestureRecognizer) {
        particleEmitter.emitterPosition = sender.location(in: vc.view)
        
        if sender.state == .began {
            showParticles()
            particleEmitter.birthRate = 1.0
        } else if sender.state == .ended {
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(stopEmission), userInfo: nil, repeats: false)
        }
    }
    
    @objc func stopEmission() {
        particleEmitter.birthRate = 0
    }
    
    func handlePan(_ sender: UIPanGestureRecognizer) {
        particleEmitter.emitterPosition = sender.location(in: vc.view)
        
        if sender.state == .began {
            showParticles()
            particleEmitter.birthRate = 1.0
        } else if sender.state == .ended {
            particleEmitter.birthRate = 0
        }
    }
}
