//
//  MenuScene.swift
//  SpriteKitTest
//
//  Created by Tayler Uva on 7/1/18.
//  Copyright © 2018 Tayler Uva. All rights reserved.
//

import SpriteKit

class BaseScene: SKScene {
    let userDefaults = UserDefaults.standard
    var highscoreLabel:SKLabelNode!
    var mainTitleLabel:SKLabelNode!
    var difficultyLabel:SKLabelNode!
    var difficulty:Int = UserDefaults.standard.integer(forKey: "Difficulty")
    
    class func newScene() -> BaseScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "BaseScene") as? BaseScene else {
            print("Failed to load Base")
            abort()
        }
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        return scene
    }
    
    //Navigation Functions
    func startGame() {
        let scene = GameScene.newScene()
        let transition = SKTransition.fade(withDuration: 1.0)
        self.view?.presentScene(scene, transition: transition)
    }
    func goToSettings(){
        let scene = SettingScene.newScene()
        let transition = SKTransition.fade(withDuration: 1.0)
        self.view!.presentScene(scene, transition: transition)
    }
    func goToMenu(){
        let scene = MenuScene.newScene()
        let transition = SKTransition.fade(withDuration: 1.0)
        self.view!.presentScene(scene, transition: transition)
    }
    func quitGame() {
        exit(0)
    }
    
    //Asset Loading Functions
    func createBackground() {
        let starField = SKEmitterNode(fileNamed: "Starfield")!
        starField.position = CGPoint(x: 0, y: self.frame.size.height)
        starField.particlePositionRange = CGVector(dx: self.frame.size.width, dy: 0)
        starField.advanceSimulationTime(20)
        self.addChild(starField)
        starField.zPosition = -100
    }
    func showMainTitle(position: CGPoint, size: CGFloat){
        mainTitleLabel = SKLabelNode(text: "Slug Shuttle")
        mainTitleLabel.position = position
        mainTitleLabel.fontName = "Gunship"
        mainTitleLabel.fontSize = size //80
        addChild(mainTitleLabel)
    }
    func showHighscore(position: CGPoint, size: CGFloat){
        highscoreLabel = SKLabelNode(text: "Highscore: \(userDefaults.integer(forKey: "HighScore"))")
        highscoreLabel.position = position
        highscoreLabel.fontName = "Gunship"
        highscoreLabel.fontSize = size
        addChild(highscoreLabel)
    }
    func showDifficulty(position: CGPoint, size: CGFloat){
        difficultyLabel = SKLabelNode(fontNamed: "Gunship")
        difficultyLabel.position = position
        switch difficulty {
            case 1:
                difficultyLabel.text = "Difficulty:\nEasy"
            case 2:
                difficultyLabel.text = "Difficulty:\nMed"
            case 3:
                difficultyLabel.text = "Difficulty:\nHard"
            default:
                userDefaults.set(1, forKey: "Difficulty")
                userDefaults.synchronize()
                difficultyLabel.text = "Difficulty:\nEasy"
        }
        difficultyLabel.fontSize = size
        addChild(difficultyLabel)
    }
}
