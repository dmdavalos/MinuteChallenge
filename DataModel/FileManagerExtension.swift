//
//  FileManagerExtension.swift
//  MinuteChallengeGame Extension
//
//  Created by Daniel Davalos on 12/18/17.
//  Copyright © 2017 Daniel Davalos. All rights reserved.
//

import Foundation

public extension FileManager {
    static var documentDirectoryURL: URL {
        return (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)!
    }
}
