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
    
    override func didMove(to view: SKView) {
        loadBackground()
        showMainTitle(position: CGPoint(x: frame.midX, y: frame.midY + 300), size: 80)
        showHighscore(position: CGPoint(x: frame.midX, y: frame.midY + 160), size: 45)
        showDifficulty(position: CGPoint(x: frame.midX, y: frame.midY + 210), size: 45)
        
        //Start
        let startButton = ButtonNode(buttonText: "Start Game", buttonAction: startGame)
        startButton.position = CGPoint(x: frame.midX, y:frame.midY + 50);
        self.addChild(startButton)
        
        //Difficulty
        diffButton = ButtonNode(buttonText: "Set Difficulty", buttonAction: changeDiff)
        diffButton.position = CGPoint(x: frame.midX, y: startButton.position.y - 120)
        addChild(diffButton)
        
        //Settings
        let settingsButton = ButtonNode(buttonText: "Settings", buttonAction: goToSettings)
        settingsButton.position = CGPoint(x: frame.midX, y: diffButton.position.y - 120)
        addChild(settingsButton)
        
        //Quit
        let quitButton = ButtonNode(buttonText: "Quit Game", buttonAction: quitGame)
        quitButton.position = CGPoint(x:frame.midX, y:settingsButton.position.y - 120);
        self.addChild(quitButton)
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
