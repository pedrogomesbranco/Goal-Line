//
//  GameScene.swift
//  Goal Line
//
//  Created by Pedro G. Branco on 11/12/15.
//  Copyright (c) 2015 Pedro G. Branco. All rights reserved.
//
import SpriteKit
import CoreMotion


struct CollisionCategories{
    static let Opponent : UInt32 = 0xb1
    static let Player: UInt32 = 0xb10
    static let PlayerBall: UInt32 = 0xb100
    static let EdgeBody: UInt32 = 0xb1000
    static let Friend: UInt32 = 0xb10000
}

public class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let leftBounds = CGFloat(30)
    var rightBounds = CGFloat(0)
    let player:Player = Player()
    let buttonDirLeft = SKSpriteNode(imageNamed: "left.png")
    let buttonDirRight = SKSpriteNode(imageNamed: "right.png")
    let buttonDirFire = SKSpriteNode(imageNamed: "fire.png")
    var pressedButtons = [SKSpriteNode]()
    var timer = CowntdownLabel()
    var touchdown = SKLabelNode()
    var record = SKLabelNode()
    var score:Int = 0
    var finalscore:Int = 0
    var motionManager = CMMotionManager()
    var destX:CGFloat  = 0.0
    
    
    override public func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
        backgroundColor = SKColor.black
        rightBounds = self.size.width - 30
        setupPlayer()
        
        let background = SKSpriteNode(imageNamed: "field.png")
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.size = frame.size
        addChild(background)
        background.zPosition = -1
        
        buttonDirLeft.position = CGPoint(x: 26, y: 25)
        buttonDirLeft.setScale(1.8)
        buttonDirLeft.alpha = 0.4
        self.addChild(buttonDirLeft)
        
        buttonDirRight.position = CGPoint(x: 78, y: 25)
        buttonDirRight.setScale(1.8)
        buttonDirRight.alpha = 0.4
        self.addChild(buttonDirRight)
        
        buttonDirFire.position = CGPoint(x: self.frame.width - self.buttonDirRight.frame.width/2, y: 25)
        buttonDirFire.setScale(1.8)
        buttonDirFire.alpha = 0.4
        self.addChild(buttonDirFire)
        
        let topLeft = CGPoint(x: 57, y: self.frame.height - 50)
        let topRight = CGPoint(x: self.frame.width - 30, y: self.frame.height - 50)
        
        timer.position = topLeft
        timer.fontSize = 13
        timer.fontName = "NFLPatriots"
        addChild(timer)
        timer.startWithDuration(5)
        
        touchdown.position = topRight
        touchdown.fontSize = 17
        touchdown.fontName = "NFLPatriots"
        touchdown.text = "TDs: \(score)"
        touchdown.horizontalAlignmentMode = .right
        addChild(touchdown)
        
        let high = UserDefaults.standard
        
        if (high.value(forKey: "finalscore") != nil){
            finalscore = high.value(forKey: "finalscore") as! NSInteger
        }
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(spawnEnemy),
                SKAction.wait(forDuration: 0.5)])))
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(spawnEnemy2),
                SKAction.wait(forDuration: 0.5)])))
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(spawnEnemy3),
                SKAction.wait(forDuration: 0.5)])))
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(spawnEnemy4),
                SKAction.wait(forDuration: 0.5)])))
        
        if motionManager.isAccelerometerAvailable == true {
            // 2
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler:{
                data, error in
                
                var currentX = self.player.position.x
                
                // 3
                if data!.acceleration.x < 0.0 {
                    self.destX = currentX + CGFloat((data?.acceleration.x)! * 100)
                }
                    
                else if data!.acceleration.x > 0.0 {
                    self.destX = currentX + CGFloat((data?.acceleration.x)! * 100)
                }
                
            })
            
        }
        
    }
    
    override public func update(_ currentTime: TimeInterval) {
        
        let playerHalfWidth = player.size.width/8
        timer.update()
        
        if pressedButtons.count > 0{
            print(pressedButtons.count)
        }
        
        if pressedButtons.index(of: buttonDirFire) != nil {
            player.fireBall(self)
        }
        
        if pressedButtons.index(of: buttonDirLeft) != nil {
            
            if(player.position.x < self.leftBounds + playerHalfWidth){
                player.position.x = player.position.x
            }
            else{
                player.position.x -= 4.0
            }
        }
        if pressedButtons.index(of: buttonDirRight) != nil {
            if(player.position.x > self.rightBounds - playerHalfWidth){
                player.position.x = player.position.x
            }
            else{
                player.position.x += 4.0
            }
        }
        
        if(timer.text == "Time to throw: 0s"){
            endGame()
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let playerHalfWidth = player.size.width/8
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            for button in [buttonDirFire, buttonDirLeft, buttonDirRight] {
                if button.contains(location) && pressedButtons.index(of: button) == nil {
                    if(button == buttonDirFire){
                        player.fireBall(self)
                        timer.startWithDuration(5)
                        pressedButtons.append(button)
                    }
                    else if(button == buttonDirLeft){
                        if(player.position.x < self.leftBounds + playerHalfWidth){
                            player.position.x = player.position.x
                            pressedButtons.append(button)
                        }
                        else{
                            player.position.x -= 4.0
                            pressedButtons.append(button)
                        }
                    }
                    else{
                        if(player.position.x > self.rightBounds - playerHalfWidth){
                            player.position.x = player.position.x
                            pressedButtons.append(button)
                        }
                        else{
                            player.position.x += 4.0
                            pressedButtons.append(button)
                        }
                        
                    }
                }
                print(pressedButtons)
            }
            
            for button in [buttonDirFire, buttonDirLeft, buttonDirRight] {
                if pressedButtons.index(of: button) == nil {
                    button.alpha = 0.4
                }
                else {
                    button.alpha = 0.8
                }
            }
            
            let touch = touches.first!
            let touchLocation = touch.location(in: self)
            let touchedNode = self.atPoint(touchLocation)
            if(touchedNode.name == "startgame"){
                let gameOverScene = GameScene(size: size)
                gameOverScene.scaleMode = scaleMode
                let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
                view?.presentScene(gameOverScene,transition: transitionType)
            }
            else if(touchedNode.name == "startgame2"){
                let gameOverScene = StartGameScene(size: size)
                gameOverScene.scaleMode = scaleMode
                let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
                view?.presentScene(gameOverScene,transition: transitionType)
            }
            
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            
            for button in [buttonDirLeft,  buttonDirRight, buttonDirFire] {
                if button.contains(previousLocation)
                    && !button.contains(location) {
                    let index = pressedButtons.index(of: button)
                    if index != nil {
                        pressedButtons.remove(at: index!)
                    }
                }
                else if !button.contains(previousLocation)
                    && button.contains(location)
                    && pressedButtons.index(of: button) == nil {
                    pressedButtons.append(button)
                }
            }
        }
        for button in [buttonDirLeft, buttonDirRight, buttonDirFire] {
            if pressedButtons.index(of: button) == nil {
                button.alpha = 0.4
            }
            else {
                button.alpha = 0.8
            }
        }
    }
    
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            
            for button in [buttonDirLeft, buttonDirRight, buttonDirFire] {
                if button.contains(location) {
                    let index = pressedButtons.index(of: button)
                    if index != nil {
                        pressedButtons.remove(at: index!)
                    }
                }
                else if (button.contains(previousLocation)) {
                    let index = pressedButtons.index(of: button)
                    if index != nil {
                        pressedButtons.remove(at: index!)
                    }
                }
            }
        }
        for button in [buttonDirLeft, buttonDirRight, buttonDirFire] {
            if pressedButtons.index(of: button) == nil {
                button.alpha = 0.4
            }
            else {
                button.alpha = 0.8
            }
        }
    }
    
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            
            for button in [buttonDirLeft, buttonDirRight, buttonDirFire] {
                if button.contains(location) {
                    let index = pressedButtons.index(of: button)
                    if index != nil {
                        pressedButtons.remove(at: index!)
                    }
                }
                else if (button.contains(previousLocation)) {
                    let index = pressedButtons.index(of: button)
                    if index != nil {
                        pressedButtons.remove(at: index!)
                    }
                }
            }
        }
        for button in [buttonDirLeft, buttonDirRight, buttonDirFire] {
            if pressedButtons.index(of: button) == nil {
                button.alpha = 0.4
            }
            else {
                button.alpha = 0.8
            }
        }
    }
    
    
    
    func setupPlayer(){
        player.position = CGPoint(x:self.frame.midX, y:player.size.height/2 + 75)
        addChild(player)
    }
    
    
    func remove(_ opponent:SKSpriteNode, ball:SKSpriteNode) {
        opponent.removeFromParent()
        ball.removeFromParent()
    }
    
    func remove2(_ opponent:SKSpriteNode) {
        opponent.removeFromParent()
    }
    
    
    public func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Opponent != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.PlayerBall != 0) &&  timer.text != "Time to throw: 0s") {
            if (contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil) {
                return
            }
            remove(firstBody.node as! SKSpriteNode, ball: secondBody.node as! SKSpriteNode)
            score+=1
            setupScore()
            
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Friend != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.Opponent != 0) &&  timer.text != "Time to throw: 0s") {
            if (contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil){
                return
            }
            remove2(secondBody.node as! SKSpriteNode)
            
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Friend != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.PlayerBall != 0) &&  timer.text != "Time to throw: 0s") {
            if (contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil) {
                return
            }
            remove(firstBody.node as! SKSpriteNode, ball: secondBody.node as! SKSpriteNode)
            endGame()
        }
    }
    
    
    func findIndex<T: Equatable>(_ array: [T], valueToFind: T) -> Int? {
        for (index, value) in array.enumerated() {
            if value == valueToFind {
                return index
            }
        }
        return nil
    }
    
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    
    func random(_ min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
    
    func spawnEnemy() {
        let enemy: Opponent = Opponent()
        enemy.position = CGPoint(x: frame.size.width + enemy.size.width/2,
                                 y: frame.size.height * random(0.3, max: 0.8))
        addChild(enemy)
        if(timer.text != "Time to throw: 0s" && timer.text != "Time to throw: 1s" && timer.text != "Time to throw: 2s"){
            enemy.run(
                SKAction.moveBy(x: -size.width - enemy.size.width, y: 0.0,
                                duration: TimeInterval(2)))
        }
    }
    
    
    func spawnEnemy2() {
        let enemy2: Friends = Friends()
        enemy2.position = CGPoint(x: frame.size.width + enemy2.size.width/2,
                                  y: frame.size.height * random(0.3, max: 0.8))
        addChild(enemy2)
        if(timer.text != "Time to throw: 0s" && timer.text != "Time to throw: 1s" && timer.text != "Time to throw: 2s"){
            enemy2.run(
                SKAction.moveBy(x: -size.width - enemy2.size.width, y: 0.0,
                                duration: TimeInterval(2)))
        }
    }
    
    func spawnEnemy3() {
        let enemy3: Opponent = Opponent()
        enemy3.position = CGPoint(x: frame.size.width + enemy3.size.width/2,
                                  y: frame.size.height * random(0.3, max: 0.8))
        addChild(enemy3)
        if(timer.text != "Time to throw: 0s" && timer.text != "Time to throw: 1s" && timer.text != "Time to throw: 2s"){
            enemy3.run(
                SKAction.moveBy(x: +size.width + enemy3.size.width, y: 0.0,
                                duration: TimeInterval(2)))
        }
    }
    
    
    func spawnEnemy4() {
        let enemy4: Friends = Friends()
        enemy4.position = CGPoint(x: frame.size.width + enemy4.size.width/2,
                                  y: frame.size.height * random(0.3, max: 0.8))
        addChild(enemy4)
        if(timer.text != "Time to throw: 0s" && timer.text != "Time to throw: 1s" && timer.text != "Time to throw: 2s"){
            enemy4.run(
                SKAction.moveBy(x: +size.width + enemy4.size.width, y: 0.0,
                                duration: TimeInterval(2)))
        }
    }
    
    
    func setupScore(){
        touchdown.text = "TDs: \(score)"
    }
    
    
    func setupScore2(){
        touchdown.text = "TDs: \(score)"
        record.text = "Record: \(finalscore)"
    }
    
    
    func setupScore3(){
        record.position = CGPoint(x: frame.size.width/2 + 100, y: frame.size.height/1.4 - 40)
        record.fontSize = 30
        record.text = "New Record: \(finalscore)"
    }
    
    
    func endGame(){
        
        removeAllActions()
        
        buttonDirLeft.removeFromParent()
        buttonDirRight.removeFromParent()
        buttonDirFire.removeFromParent()
        player.removeFromParent()
        timer.removeFromParent()
        touchdown.removeFromParent()
        record.removeFromParent()
        
        touchdown.position = CGPoint(x: frame.size.width/2 + 50, y: frame.size.height/1.4)
        touchdown.fontSize = 40
        touchdown.fontName = "NFLPatriots"
        touchdown.text = "TDs: \(score)"
        touchdown.horizontalAlignmentMode = .right
        
        record.position = CGPoint(x: frame.size.width/2 + 65, y: frame.size.height/1.4 - 40)
        record.fontSize = 30
        record.fontName = "NFLPatriots"
        record.horizontalAlignmentMode = .right
        
        if (score < finalscore){
            setupScore2()
            addChild(touchdown)
            addChild(record)
        }
        
        if (score >= finalscore){
            finalscore = score
            addChild(record)
            setupScore3()
            let high = UserDefaults.standard
            high.setValue(finalscore, forKey: "finalscore")
            high.synchronize()
        }
        
        let background = SKSpriteNode(imageNamed: "field.png")
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height/2)
        background.size = frame.size
        background.zPosition  = -1
        
        let startGameButton = SKSpriteNode(imageNamed: "newgamebtn")
        startGameButton.position = CGPoint(x: size.width/2,y: size.height/2 - 50)
        startGameButton.name = "startgame"
        startGameButton.zPosition = 2
        addChild(startGameButton)
        
        let menuGameButton = SKSpriteNode(imageNamed: "menu.png")
        menuGameButton.position = CGPoint(x: size.width/2,y: size.height/2 - 120)
        menuGameButton.name = "startgame2"
        menuGameButton.zPosition = 2
        addChild(menuGameButton)
    }
}
