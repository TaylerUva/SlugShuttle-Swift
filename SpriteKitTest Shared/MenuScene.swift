//
//  MenuScene.swift
//  SpriteKitTest
//
//  Created by Tayler Uva on 7/1/18.
//  Copyright © 2018 Tayler Uva. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    let userDefaults = UserDefaults.standard
    
    var diffButton:ButtonNode!
    
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
    
    func goToSettings(){
        let settingScene = SettingScene.newSettingScene()
        let transition = SKTransition.fade(withDuration: 1.0)
        settingScene.scaleMode = .aspectFill
        self.view!.presentScene(settingScene, transition: transition)
    }
    
    override func didMove(to view: SKView) {
        //BG
        let starField = SKEmitterNode(fileNamed: "Starfield")!
        starField.position = CGPoint(x: 0, y: self.frame.size.height)
        starField.particlePositionRange = CGVector(dx: self.frame.size.width, dy: 0)
        starField.advanceSimulationTime(20)
        self.addChild(starField)
        starField.zPosition = -1
        
        //Main Title
        let titleLabel = SKLabelNode(text: "Slug Shuttle")
        titleLabel.position = CGPoint(x: 0, y: 130)
        titleLabel.fontName = "Gunship"
        titleLabel.fontSize = 80
        addChild(titleLabel)
        
        //High Score
        let highscoreLabel = SKLabelNode(text: "High Score: \(userDefaults.integer(forKey: "HighScore"))")
        highscoreLabel.position = CGPoint(x: 0, y: 300)
        highscoreLabel.fontName = "Gunship"
        highscoreLabel.fontSize = 45
        addChild(highscoreLabel)
        
        //Settings
        let settingsButton = ButtonNode(buttonText: "Setting", size: CGSize(width: 350, height: 30), radius: 10, buttonAction: goToSettings)
        settingsButton.position.y = highscoreLabel.position.y - 30
        addChild(settingsButton)
        
        //Difficulty
        diffButton = ButtonNode(buttonText: "Difficulty", buttonAction: changeDiff)
        diffButton.position = CGPoint(x: 0, y: -120)
        print(diffButton.label.numberOfLines)
        switch difficulty {
        case 1:
            diffButton.label.text = "Difficulty:\nEasy"
        case 2:
            diffButton.label.text = "Difficulty:\nMed"
        case 3:
            diffButton.label.text = "Difficulty:\nHard"
        default:
            userDefaults.set(1, forKey: "Difficulty")
            userDefaults.synchronize()
            diffButton.label.text = "Difficulty:\nEasy"
        }
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
        difficulty = UserDefaults.standard.integer(forKey: "Difficulty")
        switch difficulty {
        case 3:
            userDefaults.set(1, forKey: "Difficulty")
            diffButton.label.text = "Difficulty:\nEasy"
        case 1:
            userDefaults.set(2, forKey: "Difficulty")
            diffButton.label.text = "Difficulty:\nMed"
        case 2:
            userDefaults.set(3, forKey: "Difficulty")
            diffButton.label.text = "Difficulty:\nHard"
        default:
            userDefaults.set(1, forKey: "Difficulty")
            diffButton.label.text = "Difficulty:\nEasy"
        }
        userDefaults.synchronize()
    }
    
    func quitGame() {
        exit(0)
    }
}
