//
//  Pawn.swift
//  SudoChess
//
//  Created by Daniel Panzer on 9/17/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

public class Pawn : Piece {
    
    private static let doubleMoveAllowedPositionsForWhitePawns = DirectedPosition(position: Position(.a, .two), perspective: .white)
        .rightSpaces
        .map({$0.position})
        + [Position(.a, .two)]
    
    private static let doubleMoveAllowedPositionsForBlackPawns = DirectedPosition(position: Position(.a, .seven), perspective: .black)
        .leftSpaces
        .map({$0.position})
        + [Position(.a, .seven)]
    
    private static let promotionRequiredPositionsForWhitePawns = DirectedPosition(position: Position(.a, .eight), perspective: .white)
        .rightSpaces
        .map({$0.position})
        + [Position(.a, .eight)]
    
    private static let promotionRequiredPositionsForBlackPawns = DirectedPosition(position: Position(.a, .one), perspective: .black)
        .leftSpaces
        .map({$0.position})
        + [Position(.a, .one)]
    
    public required init(owner: Team) {
        super.init(owner: owner)
    }
    
    public override var value: Int {
        return 1
    }
    
    override func possibleMoves(from position: Position, in game: Game) -> Set<Move> {
        
        let directedPosition = position.fromPerspective(of: owner)
        
        let frontMove: Position? = {
            guard let space = directedPosition.front?.position else {return nil}
            let collidingPiece = game.board[space]
            
            switch collidingPiece {
            case .none:
                return space
            case .some(_):
                return nil
            }
        }()
        
        let frontLeftMove: Position? = {
            guard let space = directedPosition.diagonalLeftFront?.position else {return nil}
            
            switch game.board[space] {
            case .none:
                return nil
            case .some(let collidingPiece):
                if collidingPiece.owner == self.owner {
                    return nil
                } else {
                    return space
                }
            }
        }()
        
        let frontRightMove: Position? = {
            guard let space = directedPosition.diagonalRightFront?.position else {return nil}
            
            switch game.board[space] {
            case .none:
                return nil
            case .some(let collidingPiece):
                if collidingPiece.owner == self.owner {
                    return nil
                } else {
                    return space
                }
            }
        }()
        
        let allMovePositions = [frontMove, frontLeftMove, frontRightMove].compactMap({$0})
        let normalMoves: [Move] = allMovePositions.map { destination in
            if (owner == .white ? Pawn.promotionRequiredPositionsForWhitePawns : Pawn.promotionRequiredPositionsForBlackPawns).contains(destination) {
                return Move(origin: position, destination: destination, capturedPiece: game.board[destination], kind: .needsPromotion)
            } else {
                return Move(origin: position, destination: destination, capturedPiece: game.board[destination])
            }
        }
        
        let doubleMove = { () -> Move? in
            
            switch owner {
            case .white:
                guard Pawn.doubleMoveAllowedPositionsForWhitePawns.contains(position) else {return nil}
            case .black:
                guard Pawn.doubleMoveAllowedPositionsForBlackPawns.contains(position) else {return nil}
            }
            
            guard let front = directedPosition.front?.position, game.board[front] == nil else {return nil}
            
            guard
                let doubleMoveDestination = directedPosition
                .front?
                .front?
                .position,
                game.board[doubleMoveDestination] == nil else {
                    return nil
            }
            
            return Move(origin: position,
                        destination: doubleMoveDestination,
                        capturedPiece: game.board[doubleMoveDestination])
            
        }()
        
        let enPassantMove = { () -> Move? in
           
            guard
                let lastMove = game.history.last,
                let piece = game.board[lastMove.destination],
                let pawn = piece as? Pawn
                else {return nil}
            
            assert(pawn.owner == game.turn.opponent)
            
            switch game.turn {
            case .white:
                
                guard
                    Pawn.doubleMoveAllowedPositionsForBlackPawns.contains(lastMove.origin),
                    abs(lastMove.origin.row.rawValue - lastMove.destination.row.rawValue) == 2
                    else {return nil}
                
            case .black:
                
                guard
                Pawn.doubleMoveAllowedPositionsForWhitePawns.contains(lastMove.origin),
                abs(lastMove.origin.row.rawValue - lastMove.destination.row.rawValue) == 2
                else {return nil}
            }
            
            guard lastMove.destination != directedPosition.left?.position else {
                return Move(origin: position,
                            destination: directedPosition.diagonalLeftFront!.position,
                            capturedPiece: game.board[lastMove.destination],
                            kind: .enPassant)
            }
            
            guard lastMove.destination != directedPosition.right?.position else {
                return Move(origin: position,
                            destination: directedPosition.diagonalRightFront!.position,
                            capturedPiece: game.board[lastMove.destination],
                            kind: .enPassant)
            }
            
            return nil
        }()
        
        return Set(normalMoves + [doubleMove, enPassantMove].compactMap{$0})
    }

    override func threatenedPositions(from position: Position, in game: Game) -> BooleanChessGrid {
        
        let directedPosition = position.fromPerspective(of: owner)
        
        let frontLeftThreat: Position? = {
            guard let space = directedPosition.diagonalLeftFront?.position else {return nil}
            
            switch game.board[space] {
            case .none:
                return space
            case .some(let collidingPiece):
                if collidingPiece.owner == self.owner {
                    return nil
                } else {
                    return space
                }
            }
        }()
        
        let frontRightThreat: Position? = {
            guard let space = directedPosition.diagonalRightFront?.position else {return nil}
            
            switch game.board[space] {
            case .none:
                return space
            case .some(let collidingPiece):
                if collidingPiece.owner == self.owner {
                    return nil
                } else {
                    return space
                }
            }
        }()
        
        return BooleanChessGrid(positions: [frontLeftThreat, frontRightThreat].compactMap{$0})
    }
}
