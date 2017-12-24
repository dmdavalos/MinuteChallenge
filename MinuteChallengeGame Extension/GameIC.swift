//
//  GameIC.swift
//  MinuteChallenge App Extension
//
//  Created by Daniel Davalos on 11/28/17.
//  Copyright © 2017 Daniel Davalos. All rights reserved.
//

import WatchKit
import Foundation

class GameIC: WKInterfaceController, WKCrownDelegate {

    @IBOutlet var skInterface: WKInterfaceSKScene!
    
    let scene = GameScene()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        scene.size.height = 390
        scene.size.width = 312
        
        scene.anchorPoint.x = 0.5
        scene.anchorPoint.y = 0.5
        
        scene.scaleMode = .aspectFill
        
        self.skInterface.presentScene(scene)
        
    }
    
    // MARK: Swipe detection methods
    
    func swipeDetected() {
        print("Swipe detected!")
        scene.swipeDetected = true
    }
    
    @IBAction func swipeRightDetected(_ sender: Any) {
        swipeDetected()
    }
    @IBAction func swipeLeftDetected(_ sender: Any) {
        swipeDetected()
    }
    @IBAction func swipeUpDetected(_ sender: Any) {
        swipeDetected()
    }
    @IBAction func swipeDownDetected(_ sender: Any) {
        swipeDetected()
    }
    @IBAction func tapDetected(_ sender: Any) {
        print("Tap detected!")
        scene.tapDetected = true
    }
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        print("Crown rotation detected! \(rotationalDelta)")
        scene.turnDetected = true
    }
    
    // MARK: willActivate method
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        crownSequencer.focus()
        crownSequencer.delegate = self
    }
    
    // MARK: Pop method
    // This is used to return to the title screen when the player loses.
}
