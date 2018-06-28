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
    var xAcceleration:CGFloat = 0
    //
    
    var starField:SKEmitterNode!
    var player:SKSpriteNode!
    
    var scoreLabel:SKLabelNode!
    
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score \(score)"
        }
    }
    
    var gameTimer:Timer!
    
    var possibleAliens = ["alien", "alien2", "alien3"]
    //Gives each item a unique identifier
    let alienCategory:UInt32 = 0x1 << 1
    let photonTorpedoCategory:UInt32 = 0x1 << 0
    
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
        player.position = CGPoint(x: 0, y: -(self.frame.size.height/2)+50)
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
        
        //Set how often aliens appear
        // TODO: Create Difficulty mode where this increases
        gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        
        //Add motion controls
        #if os(iOS) || os(tvOS)
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data:CMAccelerometerData?, error:Error?) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
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
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
        alien.physicsBody?.collisionBitMask = 0
        
        addChild(alien)
        
        let animationDuration:TimeInterval = 6
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -(halfMaxHeight+50)), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
    }
    
    func fireTorpedo (){
        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        let torpedoNode = SKSpriteNode(imageNamed: "torpedo")
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
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & photonTorpedoCategory) != 0 && (secondBody.categoryBitMask & alienCategory) != 0 {
            torpedoHit(torpedoNode: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode)
        }
    }
    
    func torpedoHit(torpedoNode:SKSpriteNode, alienNode:SKSpriteNode) {
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        self.addChild(explosion)
        
        run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        torpedoNode.removeFromParent()
        alienNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)){
            explosion.removeFromParent()
        }
        score += 10
    }
    
    override func didSimulatePhysics() {
        let halfMaxWidth = self.frame.size.width/2
        player.position.x += xAcceleration * 50
        
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
    
    override func keyDown(with event: NSEvent) {
        if (event.keyCode == 124){
            xAcceleration = 0.25
        }
        if (event.keyCode == 123){
            xAcceleration = -0.25
        }
        if (event.keyCode == 49){
            fireTorpedo()
        }
    }
    
    override func keyUp(with event: NSEvent) {
        if (event.keyCode == 124){
            xAcceleration = 0
        }
        if (event.keyCode == 123){
            xAcceleration = 0
        }
    }
    
    
    
    
}
#endif
