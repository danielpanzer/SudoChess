//
//  Piece.swift
//  SudoChess
//
//  Created by Daniel Panzer on 9/2/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import SwiftUI

public class Piece {
    
    required init(owner: Team) {
        self.owner = owner
    }
    
    public let owner: Team
    
    public var value: Int {
        return 0
    }
    
    var image: Image {
        
        let color = owner.description
        let piece = String(describing: type(of: self)).lowercased()
        return Image("\(piece)_\(color)", bundle: Bundle(for: type(of: self)))
        
    }
    
    func possibleMoves(from position: Position, in game: Game) -> Set<Move> {
        fatalError("must be overridden by subclass")
    }
    
    func threatenedPositions(from position: Position, in game: Game) -> BooleanChessGrid {
        fatalError("must be overridden by subclass")
    }
}

extension Piece : Equatable {
    
    public static func == (lhs: Piece, rhs: Piece) -> Bool {
        guard
            lhs.owner == rhs.owner &&
                type(of: lhs) == type(of: rhs)
            else {return false}
        
        return true
    }
}

extension Piece : Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(owner)
        hasher.combine(String(describing: type(of: self)))
    }
}
