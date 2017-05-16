//
//  BT.swift
//  Goal Line
//
//  Created by Pedro G. Branco on 11/12/15.
//  Copyright © 2015 Pedro G. Branco. All rights reserved.
//

import UIKit
import SpriteKit

class OpponentBall: Ball {
    
    override init(imageName: String, ballSound:String?){
        super.init(imageName: imageName, ballSound: ballSound)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func fireBall(scene: SKScene){
        let ball = OpponentBall(imageName: "laser",ballSound: nil)
        ball.position.x = self.position.x
        ball.position.y = self.position.y - self.size.height/2
        scene.addChild(ball)
        let moveBallAction = SKAction.moveTo(CGPoint(x:self.position.x,y: 0 - ball.size.height), duration: 2.0)
        let removeBallAction = SKAction.removeFromParent()
        ball.runAction(SKAction.sequence([moveBallAction,removeBallAction]))
    }
}