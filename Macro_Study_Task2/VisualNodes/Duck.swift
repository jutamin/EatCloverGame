//
//  Player.swift
//  Macro_Study_Task2
//
//  Created by 원주연 on 10/15/24.
//

import Foundation
import SpriteKit

class Duck: SKSpriteNode {
    
    private static var runAnimation: SKAction {
        get {
            let duck1 = SKTexture(imageNamed: "blueduck")
            let duck2 = SKTexture(imageNamed: "blueduck2")

            let runTexture = [duck1, duck2]
            let runAnimation = SKAction.animate(with: runTexture, timePerFrame: 0.1, resize: false, restore: true)
            let foreverRun = SKAction.repeatForever(runAnimation)

            return foreverRun
        }
    }
    
}
