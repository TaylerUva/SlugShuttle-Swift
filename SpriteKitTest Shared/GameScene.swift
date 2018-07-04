//
//  GameScene.swift
//  test Shared
//
//  Created by Tayler Uva on 6/27/18.
//  Copyright © 2018 Tayler Uva. All rights reserved.
//

import SpriteKit
import GameplayKit

#if os(iOS)
import CoreMotion
#endif

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Movement
    #if os(iOS)
    let motionManager = CMMotionManager()
    #endif
    var yAcceleration:CGFloat = 0
    var acclerationModifier:CGFloat = 1 {
        didSet {
            #if os(macOS)
            speedLabel.text = "Speed: \(acclerationModifier)"
            #endif
        }
    }
    //
    
    var starField:SKEmitterNode!
    var player:SKSpriteNode!
    
    var scoreLabel:SKLabelNode!
    var speedLabel:SKLabelNode!
    var lifeLabel:SKLabelNode!
    var pauseLabel:SKLabelNode!

    var menuButton:ButtonNode!
    var restartButton:ButtonNode!
    var resumeButton:ButtonNode!
    
    var gameTimer:Timer!
    
    let userDefaults = UserDefaults.standard
    
    var difficulty:Int = UserDefaults.standard.integer(forKey: "Difficulty")
    
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
            if userDefaults.integer(forKey: "HighScore") < score {
                userDefaults.set(score, forKey: "HighScore")
            }
        }
    }
    
    var possibleAliens = ["redGub", "greenGub", "blueGub"]
    
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
    
    func goToMenu(){
        let menuScene = MenuScene.newMenuScene()
        let transition = SKTransition.fade(withDuration: 1.0)
        menuScene.scaleMode = .aspectFill
        self.view!.presentScene(menuScene, transition: transition)
    }
    
    func restartGame(){
        let gameScene = GameScene.newGameScene()
        let transition = SKTransition.fade(withDuration: 1.0)
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
        player.size = CGSize(width: player.size.width * 0.65, height: player.size.height * 0.65)
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
        userDefaults.synchronize()
        addChild(scoreLabel)
        
        //Life
        lifeLabel = SKLabelNode(text: "Lives: 0")
        lifeLabel.position = CGPoint(x: -400, y: (self.frame.size.height/2)-50)
        lifeLabel.fontName = "Gunship"
        life = 4 - difficulty
        addChild(lifeLabel)
        
        //Speed
        speedLabel = SKLabelNode(text: "Speed: 1.0")
        speedLabel.position = CGPoint(x: 0, y: (self.frame.size.height/2)-100)
        speedLabel.fontSize = 24
        speedLabel.fontName = "Gunship"
        #if os(macOS)
        addChild(speedLabel)
        #endif
        
        // Pause Label
        pauseLabel = SKLabelNode(text: "Paused")
        pauseLabel.position = CGPoint(x: 0, y: 100)
        pauseLabel.fontName = "Gunship"
        pauseLabel.fontSize = 50
        pauseLabel.zPosition = 1000
        addChild(pauseLabel)
        pauseLabel.isHidden = true
        
        //Resume button
        resumeButton = ButtonNode(buttonText: "Resume", isHidden: true, buttonAction: pauseGame)
        resumeButton.position = CGPoint(x:0, y: 20)
        addChild(resumeButton)
        
        //Menu button
        menuButton = ButtonNode(buttonText: "Back to Menu", isHidden: true, buttonAction: goToMenu)
        menuButton.position = CGPoint(x:0, y:-220)
        addChild(menuButton)
        
        //Restart button
        restartButton = ButtonNode(buttonText: "Restart", isHidden: true, buttonAction: restartGame)
        restartButton.position.y = menuButton.position.y + 120
        addChild(restartButton)
        
        // Difficulty
        var timeInt:Double = 0
        switch difficulty {
        case 1:
            timeInt = 0.75
        case 2:
            timeInt = 0.50
        case 3:
            timeInt = 0.3
        default:
            timeInt = 0.75
        }
        gameTimer = Timer.scheduledTimer(timeInterval: (timeInt), target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        
        //Add motion controls
        #if os(iOS)
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
        if isPaused == false {
            let halfMaxHeight = self.frame.size.height/2
            let halfMaxWidth = self.frame.size.width/2
            
            possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
            
            let alien = SKSpriteNode(imageNamed: possibleAliens[0])
            
            let randomAlienPos = GKRandomDistribution(lowestValue: Int(-halfMaxWidth), highestValue: Int(halfMaxWidth))
            let position = CGFloat(randomAlienPos.nextInt())
            
            alien.position = CGPoint(x: position, y: halfMaxHeight)
            alien.size = CGSize(width: alien.size.width * 0.55, height: alien.size.height * 0.55)
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
    }
    
    func fireTorpedo (){
        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        let torpedoNode = SKSpriteNode(imageNamed: "torpedo")
        torpedoNode.size = CGSize(width: torpedoNode.size.width * 2, height: torpedoNode.size.height * 2)
        
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
        if (life == 1){
            playerNode.removeFromParent()
            player.isHidden = true
            gameOver()
        }
        life -= 1
    }
    
    func heartCollected(playerNode:SKSpriteNode, heartNode:SKSpriteNode){
        life += 1
        heartNode.removeFromParent()
        run(SKAction.playSoundFileNamed("1up.mp3", waitForCompletion: false))
    }
    
    func gameOver() {
        //Game Over
        let gameOverLabel = SKLabelNode(text: "Game Over\n\nScore: \(score)\n\nHigh Score: \(userDefaults.integer(forKey: "HighScore"))")
        gameOverLabel.numberOfLines = 3
        gameOverLabel.position = CGPoint(x: 0, y: 0)
        gameOverLabel.fontName = "Gunship"
        gameOverLabel.zPosition = 1000
        addChild(gameOverLabel)
        
        menuButton.showButton()
        restartButton.showButton()
    }
    
    func pauseGame() {
        if (isPaused == false){
            pauseLabel.isHidden = false
            menuButton.showButton()
            restartButton.showButton()
            resumeButton.showButton()
            isPaused = true
        }
        else if (isPaused == true) {
            pauseLabel.isHidden = true
            menuButton.hideButton()
            restartButton.hideButton()
            resumeButton.hideButton()
            isPaused = false
        }
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
extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchLocation = touches.first?.location(in: self)
        if !player.isHidden{
            fireTorpedo()
        }
    }
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {
    override func keyUp(with event: NSEvent) {
        let aKey = 0
        let dKey = 2
        let leftArrow = 123
        let rightArrow = 124
        
        switch Int(event.keyCode) {
        case dKey, rightArrow:
            self.yAcceleration = (0)
        case aKey, leftArrow:
            self.yAcceleration = (0)
        default:
            break
        }
    }
    
    override func keyDown(with event: NSEvent) {
        let aKey = 0
        let sKey = 1
        let dKey = 2
        let wKey = 13
        let escKey = 53
        let pKey = 35
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
            self.yAcceleration = (10 * acclerationModifier)
        case aKey, leftArrow:
            self.yAcceleration = (-10 * acclerationModifier)
        case spaceKey:
            if !player.isHidden{
                fireTorpedo()
            }
        case escKey, pKey:
            pauseGame()
        default:
            break
        }
    }
}
#endif
