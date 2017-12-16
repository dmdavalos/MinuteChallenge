//
//  Tasks.swift
//  Watch It
//
//  Created by Daniel Davalos on 11/29/17.
//  Copyright © 2017 Daniel Davalos. All rights reserved.
//

import Foundation

class Tasks {
    
    var tasks: [String] = []
    
    static let oneMinuteTimeIntervals: [Double] = [     0, 3.5, 7.0, 10.5,
                                                     13.0, 15.5, 18.0, 20.5, 23.0, 25.5, 28.0, 30.5,
                                                     32.5, 34.5, 36.5, 38.5, 40.5, 42.5, 44.5,
                                                     46.0, 47.5, 49.0, 50.5, 52.0, 53.5, 55.0, 56.5, 58.0, 59.5
                                                     ]
    
    init(numberOfTasksRequested: Int) {
        generateArray(numberOfTasks: numberOfTasksRequested)
    }
    
    func generateArray(numberOfTasks: Int) {
        for _ in 0...numberOfTasks - 1 {
            let selection = arc4random_uniform(3)
            switch selection {
            case 0:
                self.tasks.append("swipe")
            case 1:
                self.tasks.append("tap")
            case 2:
                self.tasks.append("turn")
            default:
                self.tasks.append("ERROR")
            }
        }
    }
    
}
