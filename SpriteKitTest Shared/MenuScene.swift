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
        
    override class func newScene() -> MenuScene {
        // Load 'MenuScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "MenuScene") as? MenuScene else {
            print("Failed to load MenuScene")
            abort()
        }
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        return scene
    }
    
    override func didMove(to view: SKView) {
        loadBackground()
        showMainTitle(position: CGPoint(x: 0, y: 130), size: 80)
        showHighscore(position: CGPoint(x: 0, y: 300), size: 45)
        showDifficulty(position: CGPoint(x: 0, y: 200), size: 45)
        
        //Settings
        let settingsButton = ButtonNode(buttonText: "Settings", size: CGSize(width: 350, height: 30), radius: 10, buttonAction: goToSettings)
        settingsButton.position.y = highscoreLabel.position.y - 30
        addChild(settingsButton)
        
        //Difficulty
        diffButton = ButtonNode(buttonText: "Set Difficulty", buttonAction: changeDiff)
        diffButton.position = CGPoint(x: 0, y: -120)
        addChild(diffButton)
        
        //Start
        let startButton = ButtonNode(buttonText: "Start Game", buttonAction: startGame)
        startButton.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        self.addChild(startButton)
        
        //Quit
        let quitButton = ButtonNode(buttonText: "Quit Game", buttonAction: quitGame)
        quitButton.position = CGPoint(x:0, y:-240);
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
