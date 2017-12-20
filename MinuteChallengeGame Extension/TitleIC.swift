//
//  TitleIC.swift
//  MinuteChallengeGame Extension
//
//  Created by Daniel Davalos on 12/4/17.
//  Copyright © 2017 Daniel Davalos. All rights reserved.
//

import UIKit
import WatchKit

class TitleIC: WKInterfaceController {
    
    @IBOutlet var winStreakLAbel: WKInterfaceLabel!
    
    override func willActivate() {
        // Set the winning streak label
        print("Winning streak is: \(DataModel.getWinningStreak())")
        winStreakLAbel.setText("Win Streak: \(DataModel.getWinningStreak())")
    }
}
