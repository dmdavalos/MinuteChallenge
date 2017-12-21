//
//  Model.swift
//  MinuteChallengeGame Extension
//
//  Created by Daniel Davalos on 12/18/17.
//  Copyright © 2017 Daniel Davalos. All rights reserved.
//

import Foundation

class DataModel {
    
    // Location of the winningStreak.min file
    static let winningStreakURL = FileManager.documentDirectoryURL.appendingPathComponent("winningStreak").appendingPathExtension("min")
    
    static var winningStreakArray: [UInt8]?
    
    // MARK: getWinningStreak
    static func getWinningStreak() -> Int {
        var result: Int?
        
        if dataExists() {
            do {
                let winningStreakData = try! Data(contentsOf: winningStreakURL)
                winningStreakArray = try! Array(winningStreakData)
                result = Int(winningStreakArray![0])
            }
            catch {
                print("Error retrieving data!")
            }
            return result!
        }
        else {
            initalizeData()
            return Int(winningStreakArray![0])
        }
    }
    
    // MARK: initalizeData
    static func initalizeData() -> Bool {
        do {
            winningStreakArray = [0]
            let winningStreakData = try! Data(winningStreakArray!)
            try! winningStreakData.write(to: winningStreakURL)
            print("Save data initalized!")
            return true
        }
    }
    
    // MARK: setWinningStreak
    static func setWinningStreak(points: Int) -> Bool {
        if points < 0 || points > 255 { // Need to make sure that it's an 8-bit integer
            print("Error: Invalid score. Must be between 0 and 255")
            return false
        }
        else {
            var result: Bool?
            if dataExists() {
                do {
                    winningStreakArray![0] = UInt8(points)
                    let winningStreakData = Data(winningStreakArray!)
                    try winningStreakData.write(to: winningStreakURL)
                    result = true
                }
                catch {
                    print("Error writing to disk!")
                    result = false
                }
                return result!
            }
            else {
                return false
            }
        }
    }
    
    // MARK: dataExists
    static func dataExists() -> Bool {
        do {
            let winningStreakData = try Data(contentsOf: winningStreakURL)
            winningStreakArray = try Array(winningStreakData)
            return true
        }
        catch {
            print("Error fetching WinningStreak! Data might not exist!")
            return false
        }
    }
}
