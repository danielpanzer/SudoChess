//
//  Board.swift
//  SudoChess
//
//  Created by Daniel Panzer on 10/14/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation
import SwiftUI

public typealias Board = ChessGrid<Piece?>

extension Board {
    
    /// A standard starting chessboard
    public static let standard: Board = {
        
        let pieces: [Piece?] = [
            
            Rook(owner: .black),
            Knight(owner: .black),
            Bishop(owner: .black),
            Queen(owner: .black),
            King(owner: .black),
            Bishop(owner: .black),
            Knight(owner: .black),
            Rook(owner: . black),
            
            Pawn(owner: .black),
            Pawn(owner: .black),
            Pawn(owner: .black),
            Pawn(owner: .black),
            Pawn(owner: .black),
            Pawn(owner: .black),
            Pawn(owner: .black),
            Pawn(owner: .black),
            
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            
            Pawn(owner: .white),
            Pawn(owner: .white),
            Pawn(owner: .white),
            Pawn(owner: .white),
            Pawn(owner: .white),
            Pawn(owner: .white),
            Pawn(owner: .white),
            Pawn(owner: .white),
            
            Rook(owner: . white),
            Knight(owner: .white),
            Bishop(owner: .white),
            Queen(owner: .white),
            King(owner: .white),
            Bishop(owner: .white),
            Knight(owner: .white),
            Rook(owner: . white)
        ]
        
        return ChessGrid(array: pieces)
    }()
    
    static let colors: ChessGrid<Color> = {
        
        let colors: [Color] = zip(standard.indices, standard)
            .map { position, piece in
                return (position.row.rawValue + position.rank.rawValue) % 2 == 0 ? .darkGray : .white
        }
        
        return ChessGrid<Color>(array: colors)
    }()
}
