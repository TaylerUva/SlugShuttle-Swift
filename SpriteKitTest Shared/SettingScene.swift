//
//  SettingScene.swift
//  SpriteKitTest
//
//  Created by Tayler Uva on 7/1/18.
//  Copyright © 2018 Tayler Uva. All rights reserved.
//

import SpriteKit

class SettingScene: SKScene {
    var starField:SKEmitterNode!
    
    let userDefaults = UserDefaults.standard
    
    var menuButton:SKShapeNode!
    var resetButton:SKShapeNode!
    
    var highscoreLabel:SKLabelNode!
    
    var difficulty:Int = UserDefaults.standard.integer(forKey: "Difficulty")
    
    class func newSettingScene() -> SettingScene {
        // Load 'SettingScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "SettingScene") as? SettingScene else {
            print("Failed to load MenuScene")
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
    
    override func didMove(to view: SKView) {
        //BG
        starField = SKEmitterNode(fileNamed: "Starfield")
        starField.position = CGPoint(x: 0, y: self.frame.size.height)
        starField.particlePositionRange = CGVector(dx: self.frame.size.width, dy: 0)
        starField.advanceSimulationTime(20)
        self.addChild(starField)
        starField.zPosition = -1
        
        //Settings Title
        let titleLabel = SKLabelNode(text: "Settings")
        titleLabel.position = CGPoint(x: 0, y: 300)
        titleLabel.fontName = "Gunship"
        titleLabel.fontSize = 45
        addChild(titleLabel)
        
        //High Score
        highscoreLabel = SKLabelNode(text: "High Score: \(userDefaults.integer(forKey: "HighScore"))")
        highscoreLabel.position = CGPoint(x: 0, y: -300)
        highscoreLabel.fontName = "Gunship"
        highscoreLabel.fontSize = 45
        addChild(highscoreLabel)
        
        //Reset High Score
        resetButton = SKShapeNode(rectOf: CGSize(width: 500, height: 100), cornerRadius: 30)
        resetButton.position = CGPoint(x: 0, y: -150)
        resetButton.fillColor = .darkGray
        resetButton.strokeColor = .white
        addChild(resetButton)
        let resetLabel = SKLabelNode(text: "Reset Highscore")
        resetLabel.fontName = "Gunship"
        resetLabel.position.y = resetButton.position.y - 10
        addChild(resetLabel)
        
        //Start
        menuButton = SKShapeNode(rectOf: CGSize(width: 500, height: 100), cornerRadius: 30)
        menuButton.fillColor = .darkGray
        menuButton.strokeColor = .white
        menuButton.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        let menuLabel = SKLabelNode(text: "Back to Menu")
        menuLabel.position.y = menuButton.position.y - 10
        menuLabel.fontName = "Gunship"
        self.addChild(menuLabel)
        self.addChild(menuButton)
    }
    
    func resetHighScore() {
        userDefaults.set(0, forKey: "HighScore")
        highscoreLabel.text = "High Score: \(userDefaults.integer(forKey: "HighScore"))"
        userDefaults.synchronize()
    }
    
    override func mouseDown(with event: NSEvent) {
        let touchLocation = event.location(in: self)
        // Check if the location of the touch is within the button's bounds
        if menuButton.contains(touchLocation) {
            goToMenu()
        }
        if resetButton.contains(touchLocation){
            resetHighScore()
        }
    }
}
