//
//  StartGameViewModel.swift
//  SudoChess
//
//  Created by Daniel Panzer on 3/4/20.
//  Copyright © 2020 CruxCode LLC. All rights reserved.
//

import SwiftUI
import Combine

class StartGameViewModel : ObservableObject {
    
    @Published var whitePlayer: PlayerSelection = .human
    @Published var blackPlayer: PlayerSelection = .modestMike
    
    var roster: Roster {
        Roster(whitePlayer: whitePlayer.player,
               blackPlayer: blackPlayer.player)
    }
}
