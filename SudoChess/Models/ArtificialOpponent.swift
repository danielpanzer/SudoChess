//
//  ArtificialOpponent.swift
//  SudoChess
//
//  Created by Daniel Panzer on 10/23/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

public protocol ArtificialOpponent : class {
    
    /// Displayed name of the AI
    var name: String {get}
    
    /// This method is called by the game when it needs the AI to decide the next move. Implement your decision making code here
    /// - Parameter game: The current state of the game
    /// - Returns: The AI's move decision
    func nextMove(in game: Game) -> Move
    
}
