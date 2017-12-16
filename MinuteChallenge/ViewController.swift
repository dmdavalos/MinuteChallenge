//
//  ViewController.swift
//  MinuteChallenge
//
//  Created by Daniel Davalos on 12/4/17.
//  Copyright © 2017 Daniel Davalos. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var instructionsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionsLabel.text = "Please start the game\nfrom your Apple Watch. ⌚️"
    }
}

