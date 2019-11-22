//
//  Knight.swift
//  SudoChess
//
//  Created by Daniel Panzer on 9/17/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

public class Knight : Piece {
    
    public required init(owner: Team) {
        super.init(owner: owner)
    }
    
    public override var value: Int {
        return 3
    }
    
    override func possibleMoves(from position: Position, in game: Game) -> Set<Move> {
        return threatenedPositions(from: position, in: game)
            .toMoves(from: position, in: game.board)
    }
    
    override func threatenedPositions(from position: Position, in game: Game) -> BooleanChessGrid {
        
        let directedPosition = DirectedPosition(position: position, perspective: owner)
        
        let upperLeftA =
            directedPosition
                .left?
                .front?
                .front
        
        let upperLeftB =
            directedPosition
                .left?
                .left?
                .front
        
        let upperRightA =
            directedPosition
                .right?
                .front?
                .front
        
        let upperRightB =
            directedPosition
                .right?
                .right?
                .front
        
        let lowerLeftA =
            directedPosition
                .left?
                .back?
                .back
        
        let lowerLeftB =
            directedPosition
                .left?
                .left?
                .back
        
        let lowerRightA =
            directedPosition
                .right?
                .back?
                .back
        
        let lowerRightB =
            directedPosition
                .right?
                .right?
                .back
        
        let allMoves = [upperLeftA, upperLeftB, upperRightA, upperRightB,
                        lowerLeftA, lowerLeftB, lowerRightA, lowerRightB]
            .compactMap { $0?.position }
            .filter { switch game.board[$0] {
            case .some(let collidingPiece):
                return collidingPiece.owner != self.owner
            case .none:
                return true
                }
        }
        
        return BooleanChessGrid(positions: allMoves)
    }
}
