//
//  MainScene.swift
//  Myspritekit
//
//  Created by Mac10 on 2023/3/29.
//

import UIKit
import SpriteKit

class MainScene: SKScene, SKPhysicsContactDelegate {
    var myScore = 0
    var scoreNode = SKLabelNode()
    var spaceShip = SKSpriteNode()
    
    override func didMove(to view:SKView){
        createScene()
        physicsWorld.contactDelegate = self
        let Parentcognizer = UIPanGestureRecognizer(target: self, action: #selector(handpan))
        view.addGestureRecognizer(Parentcognizer)
    }
    
    func createScene(){
        myScore = 0
        
        let mainbgd = SKSpriteNode(imageNamed: "mainbgd")
        mainbgd.size.width = self.size.width
        mainbgd.size.height = self.size.height
        mainbgd.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        mainbgd.zPosition = -1
        
        spaceShip = newSpaceShip()
        spaceShip.position = CGPoint(x: self.frame.midX, y: self.frame.midY-150)
        
        scoreNode = SKLabelNode(fontNamed: "Chalkduster")
        scoreNode.text = "Score: \(myScore)"
        scoreNode.fontSize = 24
        scoreNode.position = CGPoint(x: self.frame.minX+75, y:self.frame.minY+25)
        
        self.addChild(mainbgd)
        self.addChild(spaceShip)
        self.addChild(scoreNode)
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(newRock), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(newCoin), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(newBullet), userInfo: nil, repeats: true)
        
    }
    
    func newSpaceShip() -> SKSpriteNode{
        let ship = SKSpriteNode(imageNamed: "spaceship")
        ship.size = CGSize(width: 75, height: 75)
        ship.name = "ships"
        
        let leftlight = newLight()
        leftlight.position = CGPoint(x: -20, y: 6)
        ship.addChild(leftlight)
        
        let rightlight = newLight()
        rightlight.position = CGPoint(x: 20, y: 6)
        ship.addChild(rightlight)
        
        ship.physicsBody = SKPhysicsBody(circleOfRadius: ship.size.width/2)
        ship.physicsBody?.usesPreciseCollisionDetection = true
        ship.physicsBody?.isDynamic = false
        
        ship.physicsBody?.categoryBitMask = 0x1 << 1
        ship.physicsBody?.contactTestBitMask = 0x1 << 3 | 0x1 << 4
        
        return ship
    }
    
    func newLight()->SKShapeNode{
        let light = SKShapeNode()
        light.path = CGPath(rect: CGRect(x:-2, y:4, width:4, height:8), transform: nil)
        light.strokeColor = SKColor.white
        light.fillColor = SKColor.yellow
        
        let blink = SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.25),
            SKAction.fadeIn(withDuration: 0.25)
        ])
        let blinkForever = SKAction.repeatForever(blink)
        light.run(blinkForever)
        return light
    }
    
    @objc func newBullet(){
        let bullet = SKSpriteNode(color: SKColor.red, size: CGSize(width: 10, height: 20))
        
        let fire = SKAction.sequence([
            SKAction.moveTo(y: self.frame.maxY, duration: 0.5),
            SKAction.removeFromParent()
        ])
        
        bullet.position = CGPoint(x: spaceShip.position.x, y: spaceShip.position.y)
        bullet.name = "bullet"
        bullet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 20))
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.categoryBitMask = 0x1 << 2
        bullet.physicsBody?.contactTestBitMask = 0x1 << 3 | 0x1 << 4
        bullet.physicsBody?.collisionBitMask = 0x1 << 2
        bullet.run(fire)
        
        self.addChild(bullet)
    }
    
    @objc func newRock(){
        let rock = SKSpriteNode(imageNamed: "rock")
        rock.size = CGSize(width: 40, height: 40)
        let remove = SKAction.sequence([SKAction.wait(forDuration: 3), SKAction.removeFromParent()])
        let w = self.size.width
        let h = self.size.height
        let x = CGFloat(arc4random()).truncatingRemainder(dividingBy: w)
        rock.position = CGPoint(x: x,y: h)
        rock.name = "rocks"
        rock.physicsBody = SKPhysicsBody(circleOfRadius: 4)
        rock.physicsBody?.usesPreciseCollisionDetection = true
        rock.physicsBody?.categoryBitMask = 0x1 << 3
        rock.physicsBody?.contactTestBitMask = 0x1 << 1 | 0x1 << 2
        rock.run(remove)
        self.addChild(rock)
    }
    
    @objc func newCoin(){
        let coin = SKSpriteNode(imageNamed: "coin")
        coin.size = CGSize(width: 30, height: 30)
        let remove = SKAction.sequence([SKAction.wait(forDuration: 3), SKAction.removeFromParent()])
        let w = self.size.width
        let h = self.size.height
        let x = CGFloat(arc4random()).truncatingRemainder(dividingBy: w)
        coin.position = CGPoint(x: x,y: h)
        coin.name = "coins"
        coin.physicsBody = SKPhysicsBody(circleOfRadius: 4)
        coin.physicsBody?.usesPreciseCollisionDetection = true
        coin.physicsBody?.categoryBitMask = 0x1 << 4
        coin.physicsBody?.contactTestBitMask = 0x1 << 1 | 0x1 << 2
        coin.run(remove)
        self.addChild(coin)
    }
    
    @objc func handpan(recongizer: UIPanGestureRecognizer){
        let viewLocation = recongizer.location(in: view)
        let sceneLocation = convertPoint(fromView: viewLocation)
        let moveAction = SKAction.moveTo(x: sceneLocation.x, duration: 0.1)
        self.childNode(withName: "ships")!.run(moveAction)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        if contact.bodyA.node?.name == "ships" || contact.bodyA.node?.name == "bullet"{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if (firstBody.node?.name == "ships" && secondBody.node?.name == "rocks"){
            print("You lose!")
            let gameOverScene = GameOverScene(size: self.size)
            gameOverScene.myScore = myScore
            self.view?.presentScene(gameOverScene)
        }
        else if (firstBody.node?.name == "ships" && secondBody.node?.name == "coins"){
            contact.bodyB.node?.removeFromParent()
            print("Get 1 point\n")
            myScore += 1
            scoreNode.text = "Score: \(myScore)"
        }
        else if (firstBody.node?.name == "bullet" &&
                 (secondBody.node?.name == "coins" || secondBody.node?.name == "rocks")){
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact){
        //print("didEnd")
    }
    
}
