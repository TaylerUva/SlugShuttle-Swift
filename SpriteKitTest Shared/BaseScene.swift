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
    let highscoreKey = "Highscore"
    let difficultyKey = "Difficulty"
    
    let screenResolution = NSScreen.main!.frame.size
    
    var highscoreLabel:SKLabelNode!
    var mainTitleLabel:SKLabelNode!
    var difficultyLabel:SKLabelNode!
    var difficulty:Int = UserDefaults.standard.integer(forKey: "Difficulty")
    
    class func loadStartingScene() -> SKScene {
        let scene = MenuScene.init(size: NSScreen.main!.frame.size)
        scene.scaleMode = .aspectFill
        return scene
    }
    
    //Navigation Functions
    func startGame() {
        let scene = GameScene(size: screenResolution)
        scene.scaleMode = .aspectFill
        let transition = SKTransition.doorsOpenVertical(withDuration: 0.5)
        view?.presentScene(scene, transition: transition)
    }
    func goToSettings(){
        let scene = SettingScene(size: screenResolution)
        scene.scaleMode = .aspectFill
        let transition = SKTransition.doorsOpenVertical(withDuration: 0.5)
        view?.presentScene(scene, transition: transition)
    }
    func goToMenu(){
        let scene = MenuScene(size: screenResolution)
        scene.scaleMode = .aspectFill
        let transition = SKTransition.doorsCloseVertical(withDuration: 0.5)
        view?.presentScene(scene, transition: transition)
    }
    func quitGame() {
        exit(0)
    }
    
    //Asset Loading Functions
    func loadBackground() {
        let starField = SKEmitterNode(fileNamed: "Starfield")!
        starField.position = CGPoint(x: frame.midX, y: frame.maxY)
        starField.particlePositionRange = CGVector(dx: frame.size.width, dy: 0)
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
        highscoreLabel = SKLabelNode(text: "Highscore: \(userDefaults.integer(forKey: highscoreKey))")
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
                userDefaults.set(1, forKey: difficultyKey)
                userDefaults.synchronize()
                difficultyLabel.text = "Difficulty:\nEasy"
        }
        difficultyLabel.fontSize = size
        addChild(difficultyLabel)
    }
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}
