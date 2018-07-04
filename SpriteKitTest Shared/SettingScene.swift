//
//  SettingScene.swift
//  SpriteKitTest
//
//  Created by Tayler Uva on 7/1/18.
//  Copyright © 2018 Tayler Uva. All rights reserved.
//

import SpriteKit

class SettingScene: BaseScene {
    
    override class func newScene() -> SettingScene {
        // Load 'SettingScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "SettingScene") as? SettingScene else {
            print("Failed to load MenuScene")
            abort()
        }
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        return scene
    }
    
    override func didMove(to view: SKView) {
        loadBackground()
        showMainTitle(position: CGPoint(x: 0, y: 300), size: 80)
        showHighscore(position: CGPoint(x: 0, y: 120), size: 45)
        
        //Settings Title
        let titleLabel = SKLabelNode(text: "Settings")
        titleLabel.position = CGPoint(x: 0, y: 200)
        titleLabel.fontName = "Gunship"
        titleLabel.fontSize = 45
        addChild(titleLabel)
        
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
        userDefaults.set(0, forKey: highscoreKey)
        highscoreLabel.text = "Highscore: \(userDefaults.integer(forKey: highscoreKey))"
        userDefaults.synchronize()
    }
}
