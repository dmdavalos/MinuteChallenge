//
//  GameScene.swift
//  Watch It App Extension
//
//  Created by Daniel Davalos on 11/28/17.
//  Copyright © 2017 Daniel Davalos. All rights reserved.
//

import SpriteKit
import WatchKit

protocol MinuteChallengeDelegate {
    func returnToTitle()
}

class GameScene: SKScene {
    
    // MARK: Variables
    var label: SKLabelNode = SKLabelNode(text: "3")
    var startTime: NSDate?
    var gameCounter: Int = 0
    
    var gameStarted: Bool = false
    var taskCompleted: Bool = true
    var turnDetected: Bool = false
    var swipeDetected: Bool = false
    var tapDetected: Bool = false
    
    // Delegate
    var minuteChallengeDelegate: MinuteChallengeDelegate?
    
    // MARK: Constants
    let taskList = Tasks(numberOfTasksRequested: Tasks.oneMinuteTimeIntervals.count)
    
    // MARK: Haptic functions wrapped in SKActions
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
        
        countDownAnimation()
    }
    
    // MARK: Label methods
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
    
    // MARK: Game methods
    func nextTask() {
        turnDetected = false
        swipeDetected = false
        tapDetected = false
        if taskCompleted == false {
            gameOver()
        }
        else if taskCompleted == true {
            gameCounter += 1
            print("gameCounter: " + gameCounter.description)
            
            // See if we've won yet. If not, load the next task.
            if gameCounter == taskList.tasks.count - 1 {
                winGame()
            }
            else {
                taskCompleted = false
                switch taskList.tasks[gameCounter] {
                case .swipe:
                    self.label.text = "Swipe"
                case .tap:
                    self.label.text = "Tap"
                case .turn:
                    self.label.text = "Turn"
                }
                WKInterfaceDevice.current().play(.click)
            }
        }
    }
    
    func taskIsCorrect() {
        let grow = SKAction.scale(to: 1.2, duration: 0.25)
        let shrink = SKAction.scale(to: 1.0, duration: 0.25)
        let growAndShrink = SKAction.sequence([grow, shrink])
        
        self.taskCompleted = true
        self.label.run(growAndShrink)
        self.label.text = "OK!"
        WKInterfaceDevice.current().play(.directionUp)
    }
    
    func returnToTitle() {
        // SKActions that'll return the user to the title screen after 3 seconds.
        let waitThreeSeconds = SKAction.wait(forDuration: 3)
        let activateReturnToTitle = SKAction.customAction(withDuration: 0) { (node, timeInterval) in
            self.minuteChallengeDelegate?.returnToTitle()
        }
        let waitThenReturn = SKAction.sequence([waitThreeSeconds, activateReturnToTitle])
        
        self.label.run(waitThenReturn)
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
        DataModel.setWinningStreak(points: 0)
        
        returnToTitle()
        
        // SKActions that'll return the user to the title screen after 3 seconds.
//        let waitThreeSeconds = SKAction.wait(forDuration: 3)
//        let activateReturnToTitle = SKAction.customAction(withDuration: 0) { (node, timeInterval) in
//            self.minuteChallengeDelegate?.returnToTitle()
//        }
//        let waitThenReturn = SKAction.sequence([waitThreeSeconds, activateReturnToTitle])
//
//        self.label.run(waitThenReturn)
        
    }
    
    func winGame() {
        print(taskList.tasks.count)
        let grow = SKAction.scale(to: 1.2, duration: 0.25)
        let shrink = SKAction.scale(to: 1.0, duration: 0.25)
        let growAndShrink = SKAction.sequence([grow, shrink])
        self.label.fontSize = 60
        self.label.text = "You win!"
        self.label.run(growAndShrink)
        WKInterfaceDevice.current().play(.success)
        gameStarted = false
        DataModel.setWinningStreak(points: DataModel.getWinningStreak() + 1)
        returnToTitle()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameStarted == true {
            let timeSinceStart = startTime!.timeIntervalSinceNow.magnitude
            
            // Compare the time the next sequence starts from the time since start.
            if timeSinceStart > Tasks.oneMinuteTimeIntervals[gameCounter] {
                nextTask()
            }
            
            
            // MARK: Game logic
            switch taskList.tasks[gameCounter] {
            case .tap:
                if (swipeDetected == true || turnDetected == true) && taskCompleted == false {
                    gameOver()
                }
                else if tapDetected == true && taskCompleted == false {
                    taskIsCorrect()
                }
            case .swipe:
                if (tapDetected == true || turnDetected == true) && taskCompleted == false {
                    gameOver()
                }
                else if swipeDetected == true && taskCompleted == false {
                    taskIsCorrect()
                }
            case .turn:
                if (tapDetected == true || swipeDetected == true) && taskCompleted == false {
                    gameOver()
                }
                else if turnDetected == true && taskCompleted == false {
                    taskIsCorrect()
                }
            }
            
            
        }
    }
    
}
