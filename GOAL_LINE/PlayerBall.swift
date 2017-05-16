//
//  Throwing.swift
//  Goal Line
//
//  Created by Pedro G. Branco on 11/12/15.
//  Copyright © 2015 Pedro G. Branco. All rights reserved.
//

import UIKit
import SpriteKit

class PlayerBall: Ball {
    
    override init(imageName: String){
        super.init(imageName: imageName)
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = CollisionCategories.PlayerBall
        self.physicsBody?.contactTestBitMask = CollisionCategories.Opponent | CollisionCategories.Friend
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
