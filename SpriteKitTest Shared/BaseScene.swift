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
    
    var starField:SKEmitterNode!
    var highscoreLabel:SKLabelNode!
    var mainTitleLabel:SKLabelNode!
    var difficultyLabel:SKLabelNode!
    var difficulty:Int = UserDefaults.standard.integer(forKey: "Difficulty")
    
    class func loadStartingScene() -> SKScene {
        #if os(macOS)
        let scene = MenuScene.init(size: NSScreen.main!.frame.size)
        #endif
        #if os(iOS) || os(tvOS)
        let scene = MenuScene.init(size: CGSize(width: UIScreen.main.bounds.width * 2, height: UIScreen.main.bounds.height * 2))
        #endif
        return scene
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        guard oldSize != self.size else { return }
        setPositions()
    }
    
    func setPositions(){
        starField.position = CGPoint(x: frame.midX, y: frame.maxY)
        starField.particlePositionRange = CGVector(dx: frame.size.width, dy: 0)
        starField.advanceSimulationTime(20)
    }
    
    func getResolution() -> CGSize {
        #if os(macOS)
        return NSScreen.main!.frame.size
        #endif
        
        #if os(iOS) || os(tvOS)
        return CGSize(width: UIScreen.main.bounds.width * 2, height: UIScreen.main.bounds.height * 2)
        #endif
    }
    
    //Navigation Functions
    func startGame() {
        let scene = GameScene(size: getResolution())
        let transition = SKTransition.doorsOpenVertical(withDuration: 0.5)
        view?.presentScene(scene, transition: transition)
    }
    func goToSettings(){
        let scene = SettingScene(size: getResolution())
        let transition = SKTransition.doorsOpenVertical(withDuration: 0.5)
        view?.presentScene(scene, transition: transition)
    }
    func goToMenu(){
        let scene = MenuScene(size: getResolution())
        let transition = SKTransition.doorsCloseVertical(withDuration: 0.5)
        view?.presentScene(scene, transition: transition)
    }
    func quitGame() {
        exit(0)
    }
    
    //Asset Loading Functions
    func loadBackground() {
        starField = SKEmitterNode(fileNamed: "Starfield")!
        starField.position = CGPoint(x: frame.midX, y: frame.maxY)
        starField.particlePositionRange = CGVector(dx: frame.size.width, dy: 0)
        starField.advanceSimulationTime(20)
        self.addChild(starField)
        starField.zPosition = -100
    }
    func showMainTitle(size: CGFloat){
        mainTitleLabel = SKLabelNode(text: "Slug Shuttle")
        mainTitleLabel.position = position
        mainTitleLabel.fontName = "Gunship Condensed"
        mainTitleLabel.fontSize = size //80
        addChild(mainTitleLabel)
    }
    func showHighscore(size: CGFloat){
        highscoreLabel = SKLabelNode(text: "Highscore: \(userDefaults.integer(forKey: highscoreKey))")
        highscoreLabel.position = position
        highscoreLabel.fontName = "Gunship Condensed"
        highscoreLabel.fontSize = size
        addChild(highscoreLabel)
    }
    func showDifficulty(size: CGFloat){
        difficultyLabel = SKLabelNode(fontNamed: "Gunship Condensed")
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
