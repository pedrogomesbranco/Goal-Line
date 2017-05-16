//
//  GameScene.swift
//  Goal Line
//
//  Created by Pedro G. Branco on 11/12/15.
//  Copyright (c) 2015 Pedro G. Branco. All rights reserved.
//
import UIKit
import SpriteKit

class PulsatingText : SKLabelNode {
    
    func setTextFontSizeAndPulsate(_ theText: String, theFontSize: CGFloat){
        self.text = theText;
        self.fontSize = theFontSize
        let scaleSequence = SKAction.sequence([SKAction.scale(to: 3, duration: 1),SKAction.scale(to: 2, duration:1)])
        let scaleForever = SKAction.repeatForever(scaleSequence)
        self.run(scaleForever)
    }
}
