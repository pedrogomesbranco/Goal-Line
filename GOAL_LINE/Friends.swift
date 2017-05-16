//
//  Opponent.swift
//  Goal Line
//
//  Created by Pedro G. Branco on 11/12/15.
//  Copyright © 2015 Pedro G. Branco. All rights reserved.
//

import UIKit
import SpriteKit

class Friends: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "invader2")
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        self.name = "friends"
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = false
        self.physicsBody?.categoryBitMask = CollisionCategories.Friend
        self.physicsBody?.contactTestBitMask = CollisionCategories.PlayerBall
        self.physicsBody?.collisionBitMask = 0x0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
