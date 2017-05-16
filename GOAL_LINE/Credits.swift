//
//  StartGameScene.swift
//  Goal Line
//
//  Created by Pedro G. Branco on 11/12/15.
//  Copyright © 2015 Pedro G. Branco. All rights reserved.
//

import UIKit
import SpriteKit

class Credits: SKScene {
    let back = SKSpriteNode(imageNamed: "back")
    let ufa = SKSpriteNode(imageNamed: "opa")
    
    
    override func didMove(to view: SKView) {
        back.position = CGPoint(x: size.width/2,y: size.height/2 - 228)
        back.name = "back"
        addChild(back)
        ufa.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2 )
        ufa.size = frame.size
        addChild(ufa)
        ufa.zPosition = -1
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        if(touchedNode.name == "back"){
            let gameOverScene = StartGameScene(size: size)
            gameOverScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontal(withDuration: 1.0)
            view?.presentScene(gameOverScene,transition: transitionType)}
        
    }
}
