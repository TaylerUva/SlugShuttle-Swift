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
    
    convenience init(buttonText: String, buttonAction: @escaping () -> Void){
        self.init(buttonText: buttonText, size: CGSize(width: 500, height: 100), radius: 30, isHidden: false, buttonAction: buttonAction)
    }
    
    convenience init(buttonText: String, isHidden: Bool, buttonAction: @escaping () -> Void){
        self.init(buttonText: buttonText, size: CGSize(width: 500, height: 100), radius: 30, isHidden: isHidden, buttonAction: buttonAction)
    }
    
    convenience init(buttonText: String, size: CGSize, radius: CGFloat, buttonAction: @escaping () -> Void){
        self.init(buttonText: buttonText, size: size, radius: radius, isHidden: false, buttonAction: buttonAction)
    }
    
    init(buttonText: String, size: CGSize, radius: CGFloat, isHidden: Bool, buttonAction: @escaping () -> Void) {
        button = SKShapeNode(rectOf: size, cornerRadius: radius)
        button.fillColor = .darkGray
        button.strokeColor = .white
        button.alpha = CGFloat(0.75)
        button.zPosition = 1000
        
        label = SKLabelNode(text: buttonText)
        label.fontName = "Gunship"
        label.zPosition = 1000
        if  label.frame.size.width > size.width{
            label.fontSize -= abs(label.frame.size.width - size.width)
        }
        label.position.y = button.position.y - label.fontSize/3
        
        button.isHidden = isHidden
        label.isHidden = isHidden
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
        isUserInteractionEnabled = true
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

