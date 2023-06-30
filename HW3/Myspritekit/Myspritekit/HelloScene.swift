//
//  HelloScene.swift
//  Myspritekit
//
//  Created by Mac10 on 2023/3/29.
//

import UIKit
import SpriteKit

class HelloScene: SKScene {
    override func didMove(to view:SKView){
        createScene()
    }
    
    func createScene(){
        let bgd = SKSpriteNode(imageNamed: "doge hellobgd")
        bgd.scale(to: self.size)
        bgd.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bgd.zPosition = -1
        
        let hellolabel = SKLabelNode(text: "Space 🚀 Adventure")
        hellolabel.name = "label"
        hellolabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        hellolabel.fontName = "Avenir-Oblique"
        hellolabel.fontSize = 28
        
        let indentlabel = SKLabelNode(text: "Tap anywhere to start")
        indentlabel.name = "indentLabel"
        indentlabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - self.frame.midY / 2)
        indentlabel.fontName = "Avenir-Oblique"
        indentlabel.fontSize = 18
        
        self.addChild(bgd)
        self.addChild(hellolabel)
        self.addChild(indentlabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let labelNode = self.childNode(withName: "label")
        let moveup = SKAction.moveBy(x: 0,y: 200, duration: 1)
        let zoomin = SKAction.scale(to: 3.0, duration: 1)
        let pause = SKAction.wait(forDuration: 0.5)
        let zoomout = SKAction.scale(to: 0.5, duration: 0.25)
        let fadeaway = SKAction.fadeOut(withDuration: 0.25)
        let remove = SKAction.removeFromParent()
        let rotate = SKAction.rotate(byAngle: Double.pi * 2, duration: 0.5)
        let movedown = SKAction.moveBy(x:0, y:-200, duration: 1)
        let movesequence1 = SKAction.sequence([zoomin, zoomout, moveup, zoomin, pause, zoomout, fadeaway, remove])
        let movesequence2 = SKAction.sequence([rotate, pause, zoomin, zoomout, fadeaway, remove])
        let movesequence3 = SKAction.sequence([moveup, pause, movedown, pause, zoomin, fadeaway, remove])
        
        let moveseq = [movesequence1, movesequence2, movesequence3]
        
        labelNode?.run(moveseq.randomElement()!, completion: {
            let mainScene = MainScene(size: self.size)
            let doors = SKTransition.doorsOpenVertical(withDuration: 0.5)
            self.view?.presentScene(mainScene, transition: doors)
        })
    }
}
