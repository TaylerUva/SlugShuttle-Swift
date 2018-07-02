//
//  MenuScene.swift
//  SpriteKitTest
//
//  Created by Tayler Uva on 7/1/18.
//  Copyright © 2018 Tayler Uva. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    var starField:SKEmitterNode!
    
    let userDefaults = UserDefaults.standard
    
    var diffLabel:SKLabelNode!
    
    var startButton:SKShapeNode!
    var diffButton:SKShapeNode!
    
    var difficulty:Int = UserDefaults.standard.integer(forKey: "Difficulty")
    
    class func newMenuScene() -> MenuScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "MenuScene") as? MenuScene else {
            print("Failed to load MenuScene")
            abort()
        }
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        return scene
    }
    
    func startGame() {
        let gameScene = GameScene.newGameScene()
        let transition = SKTransition.fade(withDuration: 1.0) // create type of transition (you can check in documentation for more transtions)
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    override func didMove(to view: SKView) {
        //BG
        starField = SKEmitterNode(fileNamed: "Starfield")
        starField.position = CGPoint(x: 0, y: self.frame.size.height)
        starField.particlePositionRange = CGVector(dx: self.frame.size.width, dy: 0)
        starField.advanceSimulationTime(20)
        self.addChild(starField)
        starField.zPosition = -1
        
        //Main Title
        let titleLabel = SKLabelNode(text: "Slug Shuttle")
        titleLabel.position = CGPoint(x: 0, y: 100)
        titleLabel.fontName = "Gunship"
        titleLabel.fontSize = 45
        addChild(titleLabel)
        
        //High Score
        let highscoreLabel = SKLabelNode(text: "High Score: \(userDefaults.integer(forKey: "HighScore"))")
        highscoreLabel.position = CGPoint(x: 0, y: 200)
        highscoreLabel.fontName = "Gunship"
        highscoreLabel.fontSize = 45
        addChild(highscoreLabel)
        
        //Difficulty
        diffButton = SKShapeNode(rectOf: CGSize(width: 500, height: 100), cornerRadius: 30)
        diffButton.fillColor = .darkGray
        diffButton.strokeColor = .white
        diffButton.position = CGPoint(x: 0, y: -150)
        diffLabel = SKLabelNode()
        diffLabel.position.y = diffButton.position.y - 40
        diffLabel.fontName = "Gunship"
        diffLabel.numberOfLines = 2
        switch difficulty {
        case 1:
            diffLabel.text = "Difficulty:\nEasy"
        case 2:
            diffLabel.text = "Difficulty:\nMedium"
        case 3:
            diffLabel.text = "Difficulty:\nHard"
        default:
            break
        }
        addChild(diffLabel)
        addChild(diffButton)
        
        //Start
        startButton = SKShapeNode(rectOf: CGSize(width: 500, height: 100), cornerRadius: 30)
        startButton.fillColor = .darkGray
        startButton.strokeColor = .white
        startButton.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        let startLabel = SKLabelNode(text: "Start Game")
        startLabel.position.y = startButton.position.y - 10
        startLabel.fontName = "Gunship"
        self.addChild(startLabel)
        self.addChild(startButton)
    }
    
    func changeDiff(){
        difficulty = UserDefaults.standard.integer(forKey: "Difficulty")
        switch difficulty {
        case 3:
            userDefaults.set(1, forKey: "Difficulty")
            diffLabel.text = "Difficulty:\nEasy"
        case 1:
            userDefaults.set(2, forKey: "Difficulty")
            diffLabel.text = "Difficulty:\nMedium"
        case 2:
            userDefaults.set(3, forKey: "Difficulty")
            diffLabel.text = "Difficulty:\nHard"
        default:
            break
        }
        userDefaults.synchronize()
    }
    
    override func mouseDown(with event: NSEvent) {
        let touchLocation = event.location(in: self)
        // Check if the location of the touch is within the button's bounds
        if startButton.contains(touchLocation) {
            startGame()
        }
        if diffButton.contains(touchLocation) {
            changeDiff()
        }
    }
}
