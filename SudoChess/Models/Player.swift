//
//  Player.swift
//  SudoChess
//
//  Created by Daniel Panzer on 10/23/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

/// Describes the possible kinds of chess players
public enum Player {
    case human
    case ai(ArtificialOpponent)
}

extension Player : CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .human:
            return "Human"
        case .ai(let artificialOpponent):
            return artificialOpponent.name
        }
    }
}
