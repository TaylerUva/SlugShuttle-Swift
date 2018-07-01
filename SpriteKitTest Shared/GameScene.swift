//
//  GameScene.swift
//  test Shared
//
//  Created by Tayler Uva on 6/27/18.
//  Copyright © 2018 Tayler Uva. All rights reserved.
//

import SpriteKit
import GameplayKit

#if os(iOS) || os(tvOS)
import CoreMotion
#endif

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Movement
    #if os(iOS) || os(tvOS)
    let motionManager = CMMotionManager()
    #endif
    var yAcceleration:CGFloat = 0
    var acclerationModifier:CGFloat = 1 {
        didSet {
            speedLabel.text = "Speed: \(acclerationModifier)"
        }
    }
    //
    
    var starField:SKEmitterNode!
    var player:SKSpriteNode!
    
    var scoreLabel:SKLabelNode!
    var speedLabel:SKLabelNode!
    var lifeLabel:SKLabelNode!
    var gameOverLabel:SKLabelNode!
    var diffLabel:SKLabelNode!
    
    var life:Int = 3 {
        didSet{
            lifeLabel.text = "Lives Left: \(life)"
        }
    }
    var lifeScore:Int = 0 {
        didSet {
            if (lifeScore >= 10000){
                life += 1
                run(SKAction.playSoundFileNamed("1up.mp3", waitForCompletion: false))
                lifeScore = lifeScore - 10000
            }
        }
    }
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var difficulty:Int = 1 {
        didSet {
            diffLabel.text = "Difficulty: \(difficulty)"
            let time:Double = 0.85 - Double(difficulty) / 10.0
            gameTimer = Timer.scheduledTimer(timeInterval: (time), target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        }
    }
    
    var gameTimer:Timer!
    
    var possibleAliens = ["alien", "alien2", "alien3"]
    //Gives each item a unique identifier
    let photonTorpedoCategory:UInt32 = 0x1 << 0
    let alienCategory:UInt32 = 0x1 << 1
    let playerCatergory:UInt32 = 0x1 << 2
    let heartCatergory:UInt32 = 0x1 << 3
    
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    func restart(){
        guard let gameScene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        let transition = SKTransition.fade(withDuration: 1.0) // create type of transition (you can check in documentation for more transtions)
        gameScene.scaleMode = .aspectFill
        self.view!.presentScene(gameScene, transition: transition)
    }
    
    override func didMove(to view: SKView) {
        //BG
        starField = SKEmitterNode(fileNamed: "Starfield")
        starField.position = CGPoint(x: 0, y: self.frame.size.height)
        starField.particlePositionRange = CGVector(dx: self.frame.size.width, dy: 0)
        starField.advanceSimulationTime(20)
        self.addChild(starField)
        starField.zPosition = -1
        
        //Player
        player = SKSpriteNode(imageNamed: "shuttle")
            //Double this size of sprite if on macOS
            #if os(macOS)
            player.size = CGSize(width: player.size.width * 2, height: player.size.height * 2)
            #endif
        player.position = CGPoint(x: 0, y: -(self.frame.size.height/2)+50)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = playerCatergory
        player.physicsBody?.contactTestBitMask = alienCategory
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(player)
        
        
        //Physics
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        //Score
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 0, y: (self.frame.size.height/2)-50)
        scoreLabel.fontName = "Gunship"
        score=0
        addChild(scoreLabel)
        
        //Life
        lifeLabel = SKLabelNode(text: "Lives: 0")
        lifeLabel.position = CGPoint(x: -400, y: (self.frame.size.height/2)-50)
        lifeLabel.fontName = "Gunship"
        life=3
        addChild(lifeLabel)
        
        //Difficulty
        diffLabel = SKLabelNode(text: "Difficulty: 1")
        diffLabel.position = CGPoint(x: 400, y: (self.frame.size.height/2)-50)
        diffLabel.fontName = "Gunship"
        difficulty=1
        addChild(diffLabel)
        
        //Speed
        speedLabel = SKLabelNode(text: "Speed: 1.0")
        speedLabel.position = CGPoint(x: 0, y: (self.frame.size.height/2)-100)
        speedLabel.fontSize = 24
        speedLabel.fontName = "Gunship"
        #if os(macOS)
        addChild(speedLabel)
        #endif
        
        //Set how often aliens appear
        gameTimer = Timer.scheduledTimer(timeInterval: (100), target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        
        //Add motion controls
        #if os(iOS) || os(tvOS)
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data:CMAccelerometerData?, error:Error?) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.yAcceleration = CGFloat(acceleration.y) * 0.75 + self.yAcceleration * 0.25
            }
        }
        #endif
    }
    
    @objc func addAlien () {
        let halfMaxHeight = self.frame.size.height/2
        let halfMaxWidth = self.frame.size.width/2
        
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: possibleAliens[0])
        
        let randomAlienPos = GKRandomDistribution(lowestValue: Int(-halfMaxWidth), highestValue: Int(halfMaxWidth))
        let position = CGFloat(randomAlienPos.nextInt())
        
        alien.position = CGPoint(x: position, y: halfMaxHeight)
        
            //Double this size of sprite if on macOS
            #if os(macOS)
            alien.size = CGSize(width: alien.size.width * 2, height: alien.size.height * 2)
            #endif
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
        alien.physicsBody?.collisionBitMask = 0
        addChild(alien)
        
        let animationDuration:TimeInterval = TimeInterval(6 / difficulty)
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -(halfMaxHeight+50)), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
    }
    
    func fireTorpedo (){
        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        let torpedoNode = SKSpriteNode(imageNamed: "torpedo")
        
            //Double this size of sprite if on macOS
            #if os(macOS)
            torpedoNode.size = CGSize(width: torpedoNode.size.width * 2, height: torpedoNode.size.height * 2)
            #endif
        
        torpedoNode.position = player.position
        torpedoNode.position.y += 10
    
        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.width / 2)
        torpedoNode.physicsBody?.isDynamic = true
        
        torpedoNode.physicsBody?.categoryBitMask = photonTorpedoCategory
        torpedoNode.physicsBody?.contactTestBitMask = alienCategory
        torpedoNode.physicsBody?.collisionBitMask = 0
        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(torpedoNode)
        
        let animationDuration:TimeInterval = 0.3
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.height/2 + 50), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        torpedoNode.run(SKAction.sequence(actionArray))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask & playerCatergory) != 0 {
            if (contact.bodyB.categoryBitMask & heartCatergory) != 0 {
                heartCollected(playerNode: contact.bodyA.node as! SKSpriteNode, heartNode: contact.bodyB.node as! SKSpriteNode)
            }
            if (contact.bodyB.categoryBitMask & alienCategory) != 0 {
                shipHit(playerNode: contact.bodyA.node as! SKSpriteNode, alienNode: contact.bodyB.node as! SKSpriteNode)
            }
        }
        if (contact.bodyB.categoryBitMask & photonTorpedoCategory) != 0 {
            if (contact.bodyA.categoryBitMask & alienCategory) != 0 {
                torpedoHit(torpedoNode: contact.bodyB.node as! SKSpriteNode, alienNode: contact.bodyA.node as! SKSpriteNode)
            }
        }
    }
    
    func torpedoHit(torpedoNode:SKSpriteNode, alienNode:SKSpriteNode) {
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        self.addChild(explosion)
        
        run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        torpedoNode.removeFromParent()
        let dropRate = GKRandomDistribution(lowestValue: 0, highestValue: 20 * difficulty)
        if (dropRate.nextInt() == 0) {
            dropHeart(alienNode: alienNode)
        }
        alienNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)){
            explosion.removeFromParent()
        }
        
        lifeScore += 100 * difficulty
        score += 100 * difficulty
    }
    
    func dropHeart(alienNode: SKSpriteNode) {
        let heartNode = SKSpriteNode(imageNamed: "heart")
        let animationDuration:TimeInterval = TimeInterval(6 / difficulty)
        
        heartNode.physicsBody = SKPhysicsBody(rectangleOf: heartNode.size)
        heartNode.physicsBody?.isDynamic = true
        heartNode.physicsBody?.categoryBitMask = heartCatergory
        heartNode.physicsBody?.contactTestBitMask = playerCatergory
        heartNode.physicsBody?.collisionBitMask = 0
        heartNode.position = alienNode.position
        self.addChild(heartNode)
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: heartNode.position.x, y: -(self.frame.size.height/2 + 50)), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        heartNode.run(SKAction.sequence(actionArray))
    }
    
    func shipHit(playerNode:SKSpriteNode, alienNode:SKSpriteNode) {
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        self.addChild(explosion)
        
        run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        alienNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)){
            explosion.removeFromParent()
        }
        if (life == 0){
            playerNode.removeFromParent()
            //Game Over
            gameOverLabel = SKLabelNode(text: "Game Over\nYour score is \(score)\n\nPress R to restart")
            gameOverLabel.numberOfLines = 3
            gameOverLabel.position = CGPoint(x: 0, y: 0)
            gameOverLabel.fontName = "Gunship"
            addChild(gameOverLabel)
        }
        else {
            life -= 1
        }
    }
    
    func heartCollected(playerNode:SKSpriteNode, heartNode:SKSpriteNode){
        life += 1
        heartNode.removeFromParent()
        run(SKAction.playSoundFileNamed("1up.mp3", waitForCompletion: false))
    }
    
    override func didSimulatePhysics() {
        let halfMaxWidth = self.frame.size.width/2
        #if os(iOS) || os(tvOS)
        player.position.x += yAcceleration * 50
        #elseif os(macOS)
        player.position.x += yAcceleration
        #endif
        
        if player.position.x > halfMaxWidth {
            player.position = CGPoint(x: -halfMaxWidth, y: player.position.y)
        }else if player.position.x < -halfMaxWidth{
            player.position = CGPoint(x: halfMaxWidth, y: player.position.y)
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {
    
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        if let label = self.label {
    //            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
    //        }
    //
    //        for t in touches {
    //            self.makeSpinny(at: t.location(in: self), color: SKColor.green)
    //        }
    //    }
    //
    //    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        for t in touches {
    //            self.makeSpinny(at: t.location(in: self), color: SKColor.blue)
    //        }
    //    }
    //
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            fireTorpedo()
        }
    //
    //    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        for t in touches {
    //            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
    //        }
    //    }
    
    
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {
    
    override func mouseDown(with event: NSEvent) {
    }
    
    override func mouseDragged(with event: NSEvent) {
    }
    
    override func mouseUp(with event: NSEvent) {
        fireTorpedo()
    }
    
    override func keyUp(with event: NSEvent) {
        //Right End
        if (event.keyCode == 124 || event.keyCode == 2){
            xAcceleration = 0
        }
        //Left End
        if (event.keyCode == 123 || event.keyCode == 0){
            xAcceleration = 0
        }
    }
    
    override func keyDown(with event: NSEvent) {
        let aKey = 0
        let sKey = 1
        let dKey = 2
        let wKey = 13
        let rKey = 15
        let oneKey = 18
        let twoKey = 19
        let threeKey = 20
        let spaceKey = 49
        let leftArrow = 123
        let rightArrow = 124
        let downArrow = 125
        let upArrow = 126

        switch Int(event.keyCode) {
        case wKey, upArrow:
            acclerationModifier += 1
        case sKey,downArrow:
            if (acclerationModifier != 1) {
                acclerationModifier -= 1
            }
        case dKey, rightArrow:
            self.xAcceleration = (10 * acclerationModifier)
        case aKey, leftArrow:
            self.xAcceleration = (-10 * acclerationModifier)
        case spaceKey:
            fireTorpedo()
        case rKey:
            restart()
        case oneKey:
            difficulty = 1
        case twoKey:
            difficulty = 2
        case threeKey:
            difficulty = 3
        default:
            break
        }
    }
}
#endif
