//
//  SettingScene.swift
//  SpriteKitTest
//
//  Created by Tayler Uva on 7/1/18.
//  Copyright © 2018 Tayler Uva. All rights reserved.
//

import SpriteKit

class SettingScene: BaseScene {
    
    var settingsLabel:SKLabelNode!
    var resetButton:ButtonNode!
    var menuButton:ButtonNode!
    
    override func setPositions() {
        mainTitleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 300)
        highscoreLabel.position = CGPoint(x: frame.midX, y: frame.midY + 160)
        settingsLabel.position = CGPoint(x: frame.midX, y: frame.midY + 220)
        resetButton.position = CGPoint(x: frame.midX, y: highscoreLabel.position.y - 110)
        menuButton.position = CGPoint(x: frame.midX, y: resetButton.position.y - 240)
        super.setPositions()
    }
    
    override func didMove(to view: SKView) {
        loadBackground()
        showMainTitle(size: 80)
        showHighscore(size: 45)
        
        //Settings Title
        settingsLabel = SKLabelNode(text: "Settings")
        settingsLabel.fontName = "Gunship"
        settingsLabel.fontSize = 60
        addChild(settingsLabel)
        
        //Reset High Score
        resetButton = ButtonNode(buttonText: "Reset Highscore", buttonAction: resetHighScore)
        addChild(resetButton)
        
        //Back to menu
        menuButton = ButtonNode(buttonText: "Back To Menu", buttonAction: goToMenu)
        self.addChild(menuButton)
        
        setPositions()
    }
    
    func resetHighScore() {
        userDefaults.set(0, forKey: highscoreKey)
        highscoreLabel.text = "Highscore: \(userDefaults.integer(forKey: highscoreKey))"
        userDefaults.synchronize()
    }
}
