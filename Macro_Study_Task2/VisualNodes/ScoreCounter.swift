//
//  ScoreCounter.swift
//  Macro_Study_Task2
//
//  Created by 원주연 on 10/16/24.
//

import Foundation
import SpriteKit

class ScoreCounter: SKSpriteNode {
    
    private var label: SKLabelNode?
    private var numberOfScore = 0
    
    public func configure() {
        position = CGPoint(x: 200, y: 540 )
        print(position)
        configureLabel()
    }
    
    public func increaseCounter() {
        numberOfScore += 1
        label?.text = "\(numberOfScore)"
    }
    
    public func resetScore() {
            numberOfScore = 0
            label?.text = "\(numberOfScore)"
        }
    
    private func configureLabel() {
        //        //레이블을 직접 생성하고 추가
        //        label = SKLabelNode(fontNamed: "Arial")
        //        if let label = self.label {
        //            label.fontSize = 40
        //            label.fontColor = .white
        //            label.position = CGPoint(x: 0, y: 0)  // ScoreCounter 노드의 중심에 위치
        //            label.text = "Score: \(numberOfScore)"  // 초기 점수 표시
        //            addChild(label)  // 레이블을 ScoreCounter의 자식 노드로 추가
        //        }
        
        label = childNode(withName: "scoreLabel") as? SKLabelNode
        if let label = self.label {
            label.fontColor = .white
            label.text = "\(numberOfScore)"
        }
    }
    
}
