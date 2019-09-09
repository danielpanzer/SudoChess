//
//  Roster.swift
//  SudoChess
//
//  Created by Daniel Panzer on 10/23/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

/// An assignment of two players to teams
public struct Roster {
    
    public init(whitePlayer: Player, blackPlayer: Player) {
        self.whitePlayer = whitePlayer
        self.blackPlayer = blackPlayer
    }
    
    public let whitePlayer: Player
    public let blackPlayer: Player
    
    public subscript(team: Team) -> Player {
        switch team {
        case .white:
            return whitePlayer
        case .black:
            return blackPlayer
        }
    }
}
