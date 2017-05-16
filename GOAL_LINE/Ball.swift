//
//  Ball.swift
//  Goal Line
//
//  Created by Pedro G. Branco on 11/12/15.
//  Copyright © 2015 Pedro G. Branco. All rights reserved.
//

import UIKit
import SpriteKit

class Ball: SKSpriteNode {
    
    
    init(imageName: String) {
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
