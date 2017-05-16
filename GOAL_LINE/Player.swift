//
//  Player.swift
//  Goal Line
//
//  Created by Pedro G. Branco on 11/12/15.
//  Copyright © 2015 Pedro G. Branco. All rights reserved.
//

import UIKit
import SpriteKit


class Player: SKSpriteNode {
    
    fileprivate var canFire = true
    
    init() {
        let texture = SKTexture(imageNamed: "player1")
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        self.physicsBody?.categoryBitMask = CollisionCategories.Player
        self.physicsBody?.collisionBitMask = CollisionCategories.EdgeBody
        self.physicsBody?.allowsRotation = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fireBall(_ scene: SKScene){
        if(!canFire){
            return
        }
        else{
            canFire = false
            let ball = PlayerBall(imageName: "laser")
            ball.position.x = self.position.x
            ball.position.y = self.position.y + self.size.height/2
            scene.addChild(ball)
            let moveBallAction = SKAction.move(to: CGPoint(x:self.position.x,y:scene.size.height + ball.size.height), duration: 1.0)
            let removeBallAction = SKAction.removeFromParent()
            ball.run(SKAction.sequence([moveBallAction,removeBallAction]))
            let waitToEnableFire = SKAction.wait(forDuration: 0.3)
            run(waitToEnableFire,completion:{
            self.canFire = true
            })
        }
    }
}
