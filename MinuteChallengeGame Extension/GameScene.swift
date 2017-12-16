//
//  GameScene.swift
//  Watch It App Extension
//
//  Created by Daniel Davalos on 11/28/17.
//  Copyright © 2017 Daniel Davalos. All rights reserved.
//

import SpriteKit
import WatchKit

class GameScene: SKScene {
    
    var label: SKLabelNode = SKLabelNode(text: "3")
    var startTime: NSDate?
    var gameStarted: Bool = false
    var gameCounter: Int = 0
    let taskList = Tasks(numberOfTasksRequested: Tasks.oneMinuteTimeIntervals.count)
    var taskCompleted: Bool = true
    var crownWasRotated: Bool = false
    var swipeDetected: Bool = false
    var tapDetected: Bool = false
    
    let playHapticClick = SKAction.customAction(withDuration: 0) { (node, timeInterval) in
        WKInterfaceDevice.current().play(.click)
    }
    
    let playHapticStart = SKAction.customAction(withDuration: 0) { (node, timeInterval) in
        WKInterfaceDevice.current().play(.start)
    }
    
    let playHapticSuccess = SKAction.customAction(withDuration: 0) { (node, timeInterval) in
        WKInterfaceDevice.current().play(.success)
    }
    
    override func sceneDidLoad() {
        
        self.backgroundColor = UIColor.black
        self.label.fontSize = 72
        self.addChild(label)
        
        print(taskList.tasks)
        
        countDownAnimation()
        
    }
    
    // Label methods
    func countDownAnimation() {
    
        let waitOneSec = SKAction.wait(forDuration: 1)

        let grow = SKAction.scale(to: 1.2, duration: 0.25)

        let shrink = SKAction.scale(to: 1.0, duration: 0.25)

        let growAndShrink = SKAction.sequence([grow, shrink])

        let growShrinkandWait = SKAction.group([growAndShrink, waitOneSec])
        
        let changeToTwo = SKAction.customAction(withDuration: 0) { (node, elapsedTime) in
            self.label.text = "2"
        }
        
        let changeToOne = SKAction.customAction(withDuration: 0) { (node, elapsedTime) in
            self.label.text = "1"
        }
        
        let changeToGo = SKAction.customAction(withDuration: 0) { (node, elapsedTime) in
            self.label.text = "GO!"
        }
        
        let changeToDots = SKAction.customAction(withDuration: 0) { (node, elapsedTime) in
            self.label.text = "..."
        }
        
        let setGameStartedBoolean = SKAction.customAction(withDuration: 0) { (node, elapsedTime) in
            self.gameStarted = true
            self.startTime = NSDate()
        }
        
        let sequence = SKAction.sequence([playHapticClick, growShrinkandWait, changeToTwo, playHapticClick, growShrinkandWait, changeToOne, playHapticClick, growShrinkandWait, changeToGo, playHapticStart, growShrinkandWait, changeToDots, setGameStartedBoolean])
        
        label.run(sequence)
        
    }
    
    func nextTask() {
        crownWasRotated = false
        swipeDetected = false
        tapDetected = false
        if taskCompleted == false {
            gameOver()
        }
        else {
            taskCompleted = false
            self.label.text = taskList.tasks[gameCounter]
            WKInterfaceDevice.current().play(.click)
            if gameCounter != Tasks.oneMinuteTimeIntervals.count - 1 {
                gameCounter += 1
                print("gameCounter: " + gameCounter.description)
            }
        }
    }
    
    func gameOver() {
        let grow = SKAction.scale(to: 1.2, duration: 0.25)
        let shrink = SKAction.scale(to: 1.0, duration: 0.25)
        let growAndShrink = SKAction.sequence([grow, shrink])
        
        label.run(growAndShrink)
        label.text = "GAME OVER"
        label.fontSize = 45
        gameStarted = false
        WKInterfaceDevice.current().play(.failure)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameStarted == true {
            let timeSinceStart = startTime!.timeIntervalSinceNow.magnitude
            
            if timeSinceStart > Tasks.oneMinuteTimeIntervals[gameCounter] {
                nextTask()
            }
            
            
            // Game logic
            if self.label.text == "turn" {
                if (swipeDetected == true || tapDetected == true) && taskCompleted == false {
                    gameOver()
                }
                if crownWasRotated == true {
                    let grow = SKAction.scale(to: 1.2, duration: 0.25)
                    let shrink = SKAction.scale(to: 1.0, duration: 0.25)
                    let growAndShrink = SKAction.sequence([grow, shrink])
                    self.taskCompleted = true
                    self.label.text = "✅"
                    self.label.run(growAndShrink)
                    WKInterfaceDevice.current().play(.directionUp)
                }
            }
            
            if self.label.text == "swipe" {
                if (tapDetected == true || crownWasRotated == true) && taskCompleted == false {
                    gameOver()
                }
                if swipeDetected == true {
                    let grow = SKAction.scale(to: 1.2, duration: 0.25)
                    let shrink = SKAction.scale(to: 1.0, duration: 0.25)
                    let growAndShrink = SKAction.sequence([grow, shrink])
                    self.taskCompleted = true
                    self.label.text = "✅"
                    self.label.run(growAndShrink)
                    WKInterfaceDevice.current().play(.directionUp)
                }
            }
            
            if self.label.text == "tap" {
                if (swipeDetected == true || crownWasRotated == true) && taskCompleted == false {
                    gameOver()
                }
                if tapDetected == true {
                    let grow = SKAction.scale(to: 1.2, duration: 0.25)
                    let shrink = SKAction.scale(to: 1.0, duration: 0.25)
                    let growAndShrink = SKAction.sequence([grow, shrink])
                    self.taskCompleted = true
                    self.label.text = "✅"
                    self.label.run(growAndShrink)
                    WKInterfaceDevice.current().play(.directionUp)
                }
            }
            
            
            
        }
        
        if gameCounter == taskList.tasks.count - 1 && gameStarted == true {
            print(taskList.tasks.count)
            let grow = SKAction.scale(to: 1.2, duration: 0.25)
            let shrink = SKAction.scale(to: 1.0, duration: 0.25)
            let growAndShrink = SKAction.sequence([grow, shrink])
            self.label.fontSize = 60
            self.label.text = "You win! 🏆"
            self.label.run(growAndShrink)
            WKInterfaceDevice.current().play(.success)
            gameStarted = false
        }
    }
    
}
