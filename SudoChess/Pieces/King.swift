//
//  King.swift
//  SudoChess
//
//  Created by Daniel Panzer on 9/17/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

public class King : Piece {
    
    public required init(owner: Team) {
        super.init(owner: owner)
    }
    
    public override var value: Int {
        return 99999
    }
    
    override func threatenedPositions(from position: Position, in game: Game) -> BooleanChessGrid {
        return standardMoveGrid(from: position, in: game)
    }
    
    override func possibleMoves(from position: Position, in game: Game) -> Set<Move> {
        let standardMoves = standardMoveGrid(from: position, in: game)
            .toMoves(from: position, in: game.board)
        
        let castleMoves: Set<Move> = {
            
            let startingPosition = owner == .white ? Position(.e, .one) : Position(.e, .eight)
            let movesFromStartingPosition = game.history
                .filter {$0.origin == startingPosition}
            
            guard
                position == startingPosition,
                movesFromStartingPosition.count == 0
                else {return Set()}
            
            let directedPosition = DirectedPosition(position: position, perspective: owner)
            
            let queensideCastle: Move? = {
                
                let rookPosition = owner == .white ? Position(.a, .one) : Position(.a, .eight)
                let movesFromRookPosition = game.history
                    .filter {$0.origin == rookPosition}
                
                guard
                    let _ = game.board[rookPosition] as? Rook,
                    movesFromRookPosition.count == 0
                    else {return nil}
                
                let spacesThatAreRequiredToBeEmpty =
                    (owner == .white ? directedPosition.leftSpaces : directedPosition.rightSpaces)
                    .dropLast()
                    .map {$0.position}
                
                for space in spacesThatAreRequiredToBeEmpty {
                    guard game.board[space] == nil else {return nil}
                }

                let spacesThatAreRequiredToBeUnthreatened = spacesThatAreRequiredToBeEmpty
                    .dropLast()
                
                let positionsThreatenedByOpponent = game
                    .positionsThreatened(by: owner.opponent)
                
                for space in spacesThatAreRequiredToBeUnthreatened {
                    guard !positionsThreatenedByOpponent[space] else {return nil}
                }
                
                let destination: Position! =
                    (owner == .white ?
                        directedPosition
                            .left?
                            .left :
                        directedPosition
                            .right?
                            .right
                        )?
                        .position
                
                guard
                !positionsThreatenedByOpponent[position],
                !positionsThreatenedByOpponent[destination]
                    else {return nil}
                
                return Move(origin: position, destination: destination, capturedPiece: nil, kind: .castle)
            }()
            
            let kingsideCastle: Move? = {
                
                let rookPosition = owner == .white ? Position(.h, .one) : Position(.h, .eight)
                let movesFromRookPosition = game.history
                    .filter {$0.origin == rookPosition}
                
                guard
                    let _ = game.board[rookPosition] as? Rook,
                    movesFromRookPosition.count == 0
                    else {return nil}
                
                let spacesThatAreRequiredToBeEmptyAndUnthreatened =
                    (owner == .white ? directedPosition.rightSpaces : directedPosition.leftSpaces)
                    .dropLast()
                    .map {$0.position}
                
                for space in spacesThatAreRequiredToBeEmptyAndUnthreatened {
                    guard game.board[space] == nil else {return nil}
                }
                
                let positionsThreatenedByOpponent = game
                    .positionsThreatened(by: owner.opponent)
                
                for space in spacesThatAreRequiredToBeEmptyAndUnthreatened {
                    guard !positionsThreatenedByOpponent[space] else {return nil}
                }
                
                let destination: Position! =
                    (owner == .white ?
                        directedPosition
                            .right?
                            .right :
                        directedPosition
                            .left?
                            .left
                        )?
                        .position
                
                guard
                !positionsThreatenedByOpponent[position],
                !positionsThreatenedByOpponent[destination]
                    else {return nil}
                
                return Move(origin: position, destination: destination, capturedPiece: nil, kind: .castle)
            }()
            
            return [queensideCastle, kingsideCastle]
                .compactMap {$0}
                .toSet()
        }()
        
        return standardMoves.union(castleMoves)
    }
    
    private func standardMoveGrid(from position: Position, in game: Game) -> BooleanChessGrid {
        
        let directedPosition = DirectedPosition(position: position, perspective: owner)
        
        let frontMove = Position
            .pathConsideringCollisions(for: owner,
                                       traversing: [directedPosition.front?.position].compactMap({$0}),
                                       in: game.board)
        
        let backMove = Position
            .pathConsideringCollisions(for: owner,
                                       traversing: [directedPosition.back?.position].compactMap({$0}),
                                       in: game.board)
        
        let leftMove = Position
            .pathConsideringCollisions(for: owner,
                                       traversing: [directedPosition.left?.position].compactMap({$0}),
                                       in: game.board)
        
        let rightMove = Position
            .pathConsideringCollisions(for: owner,
                                       traversing: [directedPosition.right?.position].compactMap({$0}),
                                       in: game.board)
        
        let frontLeftDiagonal = Position
            .pathConsideringCollisions(for: owner,
                                       traversing: [directedPosition.diagonalLeftFront?.position].compactMap({$0}),
                                       in: game.board)
        
        let frontRightDiagonal = Position
            .pathConsideringCollisions(for: owner,
                                       traversing: [directedPosition.diagonalRightFront?.position].compactMap({$0}),
                                       in: game.board)
        
        let backLeftDiagonal = Position
            .pathConsideringCollisions(for: owner,
                                       traversing: [directedPosition.diagonalLeftBack?.position].compactMap({$0}),
                                       in: game.board)
        
        let backRightDiagonal = Position
            .pathConsideringCollisions(for: owner,
                                       traversing: [directedPosition.diagonalRightBack?.position].compactMap({$0}),
                                       in: game.board)
        
        let allMoves = frontMove + backMove + leftMove + rightMove +
            frontLeftDiagonal + frontRightDiagonal + backLeftDiagonal + backRightDiagonal
        
        return BooleanChessGrid(positions: allMoves)
    }
}
