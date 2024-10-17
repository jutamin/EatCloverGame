//
//  BusStop.swift
//  Macro_Study_Task2
//
//  Created by 원주연 on 10/15/24.
//

import Foundation
import SpriteKit

class Clover: SKSpriteNode {
    
    private static var shineAnimation: SKAction {
        get {
            let clover1 = SKTexture(imageNamed: "clover")
            let clover2 = SKTexture(imageNamed: "clover2")

            let runTexture = [clover1, clover2]
            let shineAnimation = SKAction.animate(with: runTexture, timePerFrame: 0.1, resize: false, restore: true)
            let foreverRun = SKAction.repeatForever(shineAnimation)

            return foreverRun
        }
    }
    
//    func startDroppingClovers() {
//            let dropAction = SKAction.run { [weak self] in
//                self?.createBlueberry()
//            }
//            let waitAction = SKAction.wait(forDuration: 1.0) // 블루베리 간격
//            let sequence = SKAction.sequence([dropAction, waitAction])
//            self.run(SKAction.repeatForever(sequence))
//    }
    
//    public func configure() {
//        
//    }

    
    public func shine() {
        run(Clover.shineAnimation)
    }

    

}
