//
//  GameOverScene.swift
//  Myspritekit
//
//  Created by  陳奕軒 on 2023/4/22.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    override func didMove(to view:SKView){
        createScene()
    }
    
    var myScore = 0
    
    func createScene(){
        let bgd = SKSpriteNode(color: SKColor.black, size: self.size)
        bgd.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bgd.zPosition = -1
        
        
        let label = SKLabelNode(text: "You lose!")
        label.name = "label"
        label.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 150)
        label.fontName = "Avenir-Oblique"
        label.fontSize = 60
        
        self.addChild(bgd)
        self.addChild(label)
        
        let alert = UIAlertController(title: "Your score: \(myScore) ", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Again", style: .default, handler:{(action: UIAlertAction!) in
            
            let mainScene = MainScene(size: self.size)
            self.view?.presentScene(mainScene)
            
        })
        alert.addAction(alertAction)
        self.scene?.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }

}
