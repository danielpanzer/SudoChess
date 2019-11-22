//
//  Queen.swift
//  SudoChess
//
//  Created by Daniel Panzer on 9/17/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

public class Queen : Piece {
    
    public required init(owner: Team) {
        super.init(owner: owner)
    }
    
    public override var value: Int {
        return 9
    }
    
    override func possibleMoves(from position: Position, in game: Game) -> Set<Move> {
        return threatenedPositions(from: position, in: game)
            .toMoves(from: position, in: game.board)
    }
    
    override func threatenedPositions(from position: Position, in game: Game) -> BooleanChessGrid {
        
        let directedPosition = DirectedPosition(position: position, perspective: owner)
        
        let frontMoves = Position
            .pathConsideringCollisions(for: owner,
                                       traversing: directedPosition.frontSpaces.map({$0.position}),
                                       in: game.board)
        
        let backMoves = Position
            .pathConsideringCollisions(for: owner,
                                       traversing: directedPosition.backSpaces.map({$0.position}),
                                       in: game.board)
        
        let leftMoves = Position
            .pathConsideringCollisions(for: owner,
                                       traversing: directedPosition.leftSpaces.map({$0.position}),
                                       in: game.board)
        
        let rightMoves = Position
            .pathConsideringCollisions(for: owner,
                                       traversing: directedPosition.rightSpaces.map({$0.position}),
                                       in: game.board)
        
        let frontLeftDiagonal = Position
            .pathConsideringCollisions(for: owner,
                                       traversing: directedPosition.diagonalLeftFrontSpaces.map({$0.position}),
                                       in: game.board)
        
        let frontRightDiagonal = Position
            .pathConsideringCollisions(for: owner,
                                       traversing: directedPosition.diagonalRightFrontSpaces.map({$0.position}),
                                       in: game.board)
        
        let backLeftDiagonal = Position
            .pathConsideringCollisions(for: owner,
                                       traversing: directedPosition.diagonalLeftBackSpaces.map({$0.position}),
                                       in: game.board)
        
        let backRightDiagonal = Position
            .pathConsideringCollisions(for: owner,
                                       traversing: directedPosition.diagonalRightBackSpaces.map({$0.position}),
                                       in: game.board)
        
        let allMoves = frontMoves + backMoves + leftMoves + rightMoves +
            frontLeftDiagonal + frontRightDiagonal + backLeftDiagonal + backRightDiagonal
        
        return BooleanChessGrid(positions: allMoves)
    }
}
