//
//  GameScene.swift
//  Goal Line
//
//  Created by Pedro G. Branco on 11/12/15.
//  Copyright (c) 2015 Pedro G. Branco. All rights reserved.
//
import SpriteKit

class CowntdownLabel: SKLabelNode {
    
    var endTime:Date!
   
    func update(){
        let timeLeftInteger = Int(timeLeft())
        text = "Time to throw: \(String(timeLeftInteger))s"
    }
    func startWithDuration(_ duration: TimeInterval){
        let timeNow = Date();
        endTime = timeNow.addingTimeInterval(duration)
    }

    
    func hasFinished() -> Bool{
        return timeLeft() == 0
    }
    
    
    fileprivate func timeLeft() -> TimeInterval{
        let now = Date()
        let remainSeconds = endTime.timeIntervalSince(now)
        return(max(remainSeconds, 0))
    }
}
