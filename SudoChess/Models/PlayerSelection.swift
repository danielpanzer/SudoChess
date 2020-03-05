//
//  PlayerSelection.swift
//  SudoChess
//
//  Created by Daniel Panzer on 3/4/20.
//  Copyright © 2020 CruxCode LLC. All rights reserved.
//

import Foundation

enum PlayerSelection : Hashable, CaseIterable {
    case human
    case stupidSteve
    case modestMike
    
    var player: Player {
        switch self {
        case .human:
            return .human
        case .stupidSteve:
            return .ai(StupidSteve())
        case .modestMike:
            return .ai(ModestMike())
        }
    }
    
    var description: String {
        self.player.description
    }
}
