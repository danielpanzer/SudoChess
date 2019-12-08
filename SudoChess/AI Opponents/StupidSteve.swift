//
//  StupidSteve.swift
//  SudoChess
//
//  Created by Daniel Panzer on 10/23/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

/// Extremely simple AI full of bad move decisions
public class StupidSteve {
    public init() {}
}

extension StupidSteve : ArtificialOpponent {
    
    public var name: String {
        "Stupid Steve"
    }
    
    public func nextMove(in game: Game, completion: @escaping (Move) -> ()) {
        
        let validMoves = game.currentMoves()
        let piecesWeCanCapture: [(piece: Piece, move: Move)] = validMoves
            .compactMap { move in
                guard let potentiallyCapturedPiece = game.board[move.destination] else {
                    return nil
                }
                
                return (potentiallyCapturedPiece, move)
        }
        
        if piecesWeCanCapture.count > 0 {
            
            let mostValuableCapture = piecesWeCanCapture
                .sorted(by: {return $0.piece.value > $1.piece.value})
                .first!
            
            DispatchQueue.main.async {
                completion(mostValuableCapture.move)
            }
            
        } else {
            
            DispatchQueue.main.async {
                completion(validMoves.randomElement()!)
            }
        }
    }
}
