//
//  StartGameScene.swift
//  Goal Line
//
//  Created by Pedro G. Branco on 11/12/15.
//  Copyright © 2015 Pedro G. Branco. All rights reserved.
//

import UIKit
import SpriteKit

class StartGameScene: SKScene {
 
    override func didMove(to view: SKView) {
        
        let startGameButton = SKSpriteNode(imageNamed: "newgamebtn")
        startGameButton.position = CGPoint(x: size.width/2,y: size.height/2 - 161)
        startGameButton.name = "startgame"
        addChild(startGameButton)
        
        let background = SKSpriteNode(imageNamed: "fieldao.png")
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2 )
        background.size = frame.size
        addChild(background)
        background.zPosition = -1
        
        let creditsGameButton = SKSpriteNode(imageNamed: "credits")
        creditsGameButton.position = CGPoint(x: size.width/2,y: size.height/2 - 230)
        creditsGameButton.name = "creditstartgame"
        addChild(creditsGameButton)

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        if(touchedNode.name == "startgame"){
            let gameOverScene = GameScene(size: size)
            gameOverScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontal(withDuration: 1.0)
            view?.presentScene(gameOverScene,transition: transitionType)
        }
            
        else if(touchedNode.name == "creditstartgame"){
            let gameOverScene = Credits(size: size)
            gameOverScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontal(withDuration: 1.0)
            view?.presentScene(gameOverScene,transition: transitionType)
        
        }

    }
}
