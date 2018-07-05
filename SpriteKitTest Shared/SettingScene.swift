//
//  SettingScene.swift
//  SpriteKitTest
//
//  Created by Tayler Uva on 7/1/18.
//  Copyright © 2018 Tayler Uva. All rights reserved.
//

import SpriteKit

class SettingScene: BaseScene {
    
    override func didMove(to view: SKView) {
        loadBackground()
        showMainTitle(position: CGPoint(x: frame.midX, y: frame.midY + 300), size: 80)
        showHighscore(position: CGPoint(x: frame.midX, y: frame.midY + 160), size: 45)
        
        //Settings Title
        let titleLabel = SKLabelNode(text: "Settings")
        titleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 220)
        titleLabel.fontName = "Gunship"
        titleLabel.fontSize = 60
        addChild(titleLabel)
        
        //Reset High Score
        let resetButton = ButtonNode(buttonText: "Reset Highscore", buttonAction: resetHighScore)
        resetButton.position = CGPoint(x: frame.midX, y: highscoreLabel.position.y - 110)
        addChild(resetButton)
        
        //Back to menu
        let menuButton = ButtonNode(buttonText: "Back To Menu", buttonAction: goToMenu)
        menuButton.position = CGPoint(x: frame.midX, y: resetButton.position.y - 240)
        self.addChild(menuButton)
    }
    
    func resetHighScore() {
        userDefaults.set(0, forKey: highscoreKey)
        highscoreLabel.text = "Highscore: \(userDefaults.integer(forKey: highscoreKey))"
        userDefaults.synchronize()
    }
}
