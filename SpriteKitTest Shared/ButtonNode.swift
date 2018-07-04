//
//  ButtonNode.swift
//  SpriteKitTest
//
//  Created by Tayler Uva on 7/3/18.
//  Copyright © 2018 Tayler Uva. All rights reserved.
//

import SpriteKit

class ButtonNode: SKNode {
    var button: SKShapeNode
    var label: SKLabelNode
    var action: () -> Void
    
    init(buttonText: String, size: CGSize, radius: CGFloat, buttonAction: @escaping () -> Void) {
        button = SKShapeNode(rectOf: size, cornerRadius: radius)
        button.fillColor = .darkGray
        button.strokeColor = .white
        button.zPosition = 1000
        
        label = SKLabelNode(text: buttonText)
        label.fontName = "Gunship"
        label.fontSize = 20
        label.zPosition = 1000
        label.position.y = button.position.y - 7
        
        button.isHidden = false
        label.isHidden = false
        action = buttonAction
        
        super.init()
        isUserInteractionEnabled = true
        addChild(label)
        addChild(button)
    }
    
    /**
     Required so XCode doesn't throw warnings
     */
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showButton(){
        button.isHidden = false
        label.isHidden = false
    }
    
    func hideButton(){
        button.isHidden = true
        label.isHidden = true
        isUserInteractionEnabled = false
    }


}
#if os(OSX)
extension ButtonNode {
    override func mouseDown(with event: NSEvent) {
        let touchLocation = event.location(in: self)
        // Check if the location of the touch is within the button's bounds
        if !button.isHidden && button.contains(touchLocation) {
            action()
        }
    }
}
#endif

#if os(iOS) || os(tvOS)
extension ButtonNode {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchLocation:CGPoint = (touches.first?.location(in: self))!
        // Check if the location of the touch is within the button's bounds
        if !button.isHidden && button.contains(touchLocation) {
            action()
        }
    }
}
#endif

