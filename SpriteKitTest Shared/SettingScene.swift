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
        highscoreLabel.position = CGPoint(x: 0, y: 200)
        highscoreLabel.fontName = "Gunship"
        highscoreLabel.fontSize = 45
        addChild(highscoreLabel)
        
        //Reset High Score
        let resetButton = ButtonNode(buttonText: "Reset Highscore", buttonAction: resetHighScore)
        resetButton.position = CGPoint(x: 0, y: 0)
        addChild(resetButton)
        
        //Back to menu
        let menuButton = ButtonNode(buttonText: "Back To Menu", buttonAction: goToMenu)
        menuButton.position = CGPoint(x: 0, y: -150)
        self.addChild(menuButton)
    }
    
    func resetHighScore() {
        userDefaults.set(0, forKey: "HighScore")
        highscoreLabel.text = "High Score: \(userDefaults.integer(forKey: "HighScore"))"
        userDefaults.synchronize()
    }
}
