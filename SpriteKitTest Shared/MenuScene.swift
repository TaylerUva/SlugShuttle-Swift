//
//  MenuScene.swift
//  SpriteKitTest
//
//  Created by Tayler Uva on 7/1/18.
//  Copyright © 2018 Tayler Uva. All rights reserved.
//

import SpriteKit

class MenuScene: BaseScene {
    
    var diffButton:ButtonNode!
    var startButton:ButtonNode!
    var settingsButton:ButtonNode!
    var quitButton:ButtonNode!
    
    override func setPositions() {
        startButton.position = CGPoint(x: frame.midX, y:frame.midY + 50);
        diffButton.position = CGPoint(x: frame.midX, y: startButton.position.y - 120)
        settingsButton.position = CGPoint(x: frame.midX, y: diffButton.position.y - 120)
        quitButton.position = CGPoint(x:frame.midX, y:settingsButton.position.y - 120);
        mainTitleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 300)
        highscoreLabel.position = CGPoint(x: frame.midX, y: frame.midY + 160)
        difficultyLabel.position = CGPoint(x: frame.midX, y: frame.midY + 210)
        super.setPositions()
    }
    
    override func didMove(to view: SKView) {
        loadBackground()
        showMainTitle(size: 80)
        showHighscore(size: 45)
        showDifficulty(size: 45)
        
        //Start
        startButton = ButtonNode(buttonText: "Start Game", buttonAction: startGame)
        addChild(startButton)
        
        //Difficulty
        diffButton = ButtonNode(buttonText: "Set Difficulty", buttonAction: changeDiff)
        addChild(diffButton)
        //Settings
        settingsButton = ButtonNode(buttonText: "Settings", buttonAction: goToSettings)
        addChild(settingsButton)
        
        //Quit
        quitButton = ButtonNode(buttonText: "Quit Game", buttonAction: quitGame)
        addChild(quitButton)
        
        setPositions()
    }
    
    func changeDiff(){
        difficulty = UserDefaults.standard.integer(forKey: difficultyKey)
        switch difficulty {
        case 3:
            userDefaults.set(1, forKey: difficultyKey)
            difficultyLabel.text = "Difficulty:\nEasy"
        case 1:
            userDefaults.set(2, forKey: difficultyKey)
            difficultyLabel.text = "Difficulty:\nMed"
        case 2:
            userDefaults.set(3, forKey: difficultyKey)
            difficultyLabel.text = "Difficulty:\nHard"
        default:
            userDefaults.set(1, forKey: difficultyKey)
            difficultyLabel.text = "Difficulty:\nEasy"
        }
        userDefaults.synchronize()
    }
}
