//
//  GameViewController.swift
//  SpriteKitTest macOS
//
//  Created by Tayler Uva on 6/27/18.
//  Copyright © 2018 Tayler Uva. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController, NSWindowDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let sceneSize = CGSize(width: NSScreen.main!.frame.size.width * 1.5, height: NSScreen.main!.frame.size.height * 1.5)
        let scene = BaseScene.loadStartingScene(sceneSize: sceneSize)
        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        
        skView.showsFPS = true
        skView.showsNodeCount = true
    }
    
    override func viewDidAppear() {
        view.window?.delegate = self
    }
    
    func windowDidResize(_ notification: Notification) {
        viewWillTransition(to: (view.window?.frame.size)!)
    }
    
    override func viewWillTransition(to size: CGSize) {
        super.viewWillTransition(to: size)
        (self.view as? SKView)?.scene?.size.height = size.height * 1.5
        (self.view as? SKView)?.scene?.size.width = size.width * 1.5
    }
}

