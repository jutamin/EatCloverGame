//
//  GameScene.swift
//  Macro_Study_Task2
//
//  Created by 원주연 on 10/15/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var duck: Duck?
    private var clover: Clover?
    private var scoreCounter: ScoreCounter?
    private var clovers: [SKSpriteNode] = []
    private var isGameOver = false  // 게임 오버 상태를 관리하는 변수
    
    override func didMove(to view: SKView) {
        
        duck = childNode(withName: "blueduck") as? Duck
        if let duck = self.duck {
            duck.position = CGPoint(x: 0, y: -(self.size.height/2)+200)
            // 오리에 물리 바디 설정 (원형 바디)
            duck.physicsBody = SKPhysicsBody(circleOfRadius: duck.size.width / 5)
            duck.physicsBody?.isDynamic = false
            duck.physicsBody?.categoryBitMask = 2  // 오리의 카테고리
            duck.physicsBody?.contactTestBitMask = 1  // 클로버와 충돌
        }
        
        
        clover = childNode(withName: "clover") as? Clover
        startDroppingClovers()
        
        scoreCounter = childNode(withName: "ScoreCounter") as? ScoreCounter
        scoreCounter?.configure()
        //        if let scoreCounter = self.scoreCounter {
        //            print("configure!")
        //            scoreCounter.configure()
        //        }
        
        self.physicsWorld.contactDelegate = self
    }
    
    func creatClovers() {
        if let clover = self.clover {
            let newClover = clover.copy() as! Clover
            // 클로버에 물리 바디 설정 (직사각형 바디)
            newClover.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 40))
            newClover.physicsBody?.categoryBitMask = 1  // 클로버의 카테고리 설정
            newClover.physicsBody?.contactTestBitMask = 2  // 오리와 접촉할 때 이벤트 발생
            newClover.physicsBody?.collisionBitMask = 0  // 물리 충돌은 하지 않도록 설정
            
            let randomX = CGFloat.random(in: -(self.size.width/4 + 90) ... self.size.width/4 - 90)
            //self.size.width = 750 (즉, 좌표값이 아니라 길이 값을 가져옴. 따라서 /4를 해줘야 함)
            newClover.position = CGPoint(x: randomX, y: self.size.height / 2)
            newClover.shine()
            clovers.append(newClover)
            addChild(newClover)
            
            let moveDown = SKAction.moveTo(y: -self.size.height / 2, duration: 3)
            let removeAction = SKAction.removeFromParent()
            //            newClover.run(moveDown)
            
            let sequence = SKAction.sequence([moveDown, removeAction])
            newClover.run(sequence) { [weak self] in
                self?.handleCloverFell(newClover)  // 클로버가 화면 밖으로 나갈 때 호출
            }
        }
    }
    
    func startDroppingClovers() {
        //        let dropAction = SKAction.run { [weak self] in
        //            self?.creatClovers()
        //        }
        let dropAction = SKAction.run { [weak self] in
            // 게임 오버 상태가 아닐 때만 클로버 생성
            if let self = self, !self.isGameOver {
                self.creatClovers()
            }
        }
        let waitAction = SKAction.wait(forDuration: 0.5) // 클로버 간격
        let sequence = SKAction.sequence([dropAction, waitAction])
//        self.run(SKAction.repeatForever(sequence))
        
        // 클로버 생성 액션을 "dropClovers" 키로 실행
            self.run(SKAction.repeatForever(sequence), withKey: "dropClovers")
    }
    
    func handleCollision(with clover: SKSpriteNode) {
        // 점수 증가
        scoreCounter?.increaseCounter()
        
        // 클로버 제거
        clover.removeFromParent()
        clovers.removeAll { $0 == clover }
    }
    
    func handleCloverFell(_ clover: SKSpriteNode) {
        
        // 게임 오버 상태가 아닐 때만 처리
        if !isGameOver {
            isGameOver = true  // 게임 오버 상태로 변경
            showGameOverMessage()
            print("showGameOverMessage")
        }
        
        // 클로버 제거
        clover.removeFromParent()
        clovers.removeAll { $0 == clover }
    }
    
    func showGameOverMessage() {
        let gameOverLabel = SKLabelNode(fontNamed: "Arial")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 60
        gameOverLabel.fontColor = .red
        gameOverLabel.position = CGPoint(x: 0, y: 0) //화면 중앙
        gameOverLabel.zPosition = 2     //클로버 위로 글씨 뜨도록
        gameOverLabel.name = "gameOverLabel"  // 이름 설정
        addChild(gameOverLabel)
        
        // "다시하기" 버튼
        let retryButton = SKLabelNode(fontNamed: "Arial")
        retryButton.text = "Retry"
        retryButton.fontSize = 40
        retryButton.fontColor = .blue
        retryButton.position = CGPoint(x: 0, y: -50)  // 게임 오버 메시지 아래에 위치
        retryButton.zPosition = 2
        retryButton.name = "retryButton"  // 터치 이벤트를 위해 이름 설정
        addChild(retryButton)
        
        // 오리의 액션 중지
        duck?.removeAllActions()
        
        // 모든 클로버의 액션 중지
        for clover in clovers {
            clover.removeAllActions()
        }
        
        // 3초 후 제거
        //        let fadeOut = SKAction.fadeOut(withDuration: 3.0)
        //        let remove = SKAction.removeFromParent()
        //        gameOverLabel.run(SKAction.sequence([fadeOut, remove]))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // 충돌한 두 객체 가져오기
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        // 오리와 클로버가 충돌한 경우
        if bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 2 {
            handleCollision(with: bodyA.node as! SKSpriteNode)
        } else if bodyB.categoryBitMask == 1 && bodyA.categoryBitMask == 2 {
            handleCollision(with: bodyB.node as! SKSpriteNode)
        }
    }
    
    func resetGame() {
        // 기존 게임 상태 초기화
        isGameOver = false
        
        // 모든 클로버와 노드를 제거
        for clover in clovers {
            clover.removeFromParent()
        }
        clovers.removeAll()
        
        // 점수 리셋
        scoreCounter?.resetScore()
        
        // 기존 클로버 생성 액션 중지
            self.removeAction(forKey: "dropClovers")  // 중복된 클로버 생성 액션 중지
        
        // 다시 클로버 떨어뜨리기 시작
        startDroppingClovers()
        
        // "게임 오버" 및 "다시하기" 메시지 제거
            self.childNode(withName: "retryButton")?.removeFromParent()
            self.childNode(withName: "gameOverLabel")?.removeFromParent()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        let touch = touches.first
        //
        //        if let location = touch?.location(in: self) {
        //            let destX: CGFloat = location.x
        //            let moveAction = SKAction.move(to: CGPoint(x: destX, y: -(self.size.height/2)+200), duration: 0.3)
        //            duck?.run(moveAction)
        //
        //            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
        //                // 1초 후 실행될 부분
        //                self.duck?.removeAllActions()
        //            }
        //        }
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let touchedNode = self.atPoint(location)
            
            if touchedNode.name == "retryButton" {
                resetGame()  // 다시 시작 함수 호출
            } else {
                // 오리 움직임 처리
                let destX: CGFloat = location.x
                let moveAction = SKAction.move(to: CGPoint(x: destX, y: -(self.size.height / 2) + 200), duration: 0.3)
                duck?.run(moveAction)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                    self.duck?.removeAllActions()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
}
