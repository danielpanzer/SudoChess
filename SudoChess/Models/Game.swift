//
//  Game.swift
//  SudoChess
//
//  Created by Daniel Panzer on 9/18/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

/// A game of chess
public struct Game : Equatable {
    
    /// Game of chess with a standard starting board
    public static let standard = Game(board: .standard)
    private static let validator = CheckHandler()
    
    //MARK: Lifecycle
    
    public init(board: Board) {
        self = Game(board: board, history: [], turn: .white)
    }
    
    init(board: Board,
         history: [Move] = [],
         turn: Team = .white) {
        
        self.board = board
        self.history = history
        self.turn = turn
    }
    
    //MARK: Public Properties
    
    ///The chessboard
    public let board: Board
    
    //The history of all moves performed
    public let history: [Move]
    
    //The current turn
    public let turn: Team
    
    //MARK: Public Modifiers
    
    /// Performs a move
    /// - Returns: A new version of the game with the move performed
    /// - Parameter move: The move to perform
    public func performing(_ move: Move) -> Game {
        
        var newBoard = board
        var newHistory = history
        let newTurn = turn.opponent
        
        let pieceToMove = board[move.origin]!
        newBoard[move.origin] = nil
        newBoard[move.destination] = pieceToMove
        
        switch move.kind {
            
        case .standard, .needsPromotion:
            
            break
            
        case .enPassant:
            
            let capturedPosition =
                DirectedPosition(position: move.destination, perspective: turn)
                    .back!
                    .position
            
            newBoard[capturedPosition] = nil
            
        case .castle:
            
            let isKingsideCastle = move.origin.rank.rawValue < move.destination.rank.rawValue
            let newRookRank = Position.Rank(rawValue:
                isKingsideCastle ? move.destination.rank.rawValue - 1 : move.destination.rank.rawValue + 1
                )!
            let rookDestination = Position(newRookRank, move.destination.row)
            let rookOrigin = Position(isKingsideCastle ? .h : .a, pieceToMove.owner == .white ? .one : .eight)
            
            assert(newBoard[rookOrigin] is Rook)
            
            let rook = board[rookOrigin]!
            newBoard[rookOrigin] = nil
            newBoard[rookDestination] = rook
            
        case .promotion(let promotionPiece):
            
            newBoard[move.destination] = promotionPiece
            
        }
        
        newHistory.append(move)
        
        return Game(board: newBoard, history: newHistory, turn: newTurn)
    }
    
    /// Reverses the last move made. If no moves have been made, this method has no effect on the state of the game
    /// - Returns: A new version of the game with the move reversed
    public func reversingLastMove() -> Game {
        
        var newBoard = board
        var newHistory = history
        let newTurn = turn.opponent
        
        guard let move = newHistory.popLast() else {return self}
        
        switch move.kind {
            
        case .standard, .needsPromotion:
            
            let pieceToReverse = newBoard[move.destination]!
            newBoard[move.origin] = pieceToReverse
            newBoard[move.destination] = move.capturedPiece
            
        case .enPassant:
            
            let pieceToReverse = board[move.destination]!
            newBoard[move.origin] = pieceToReverse
            newBoard[move.destination] = nil
            
            let capturedPosition =
                DirectedPosition(position: move.destination, perspective: turn.opponent)
                    .back!
                    .position
            
            newBoard[capturedPosition] = move.capturedPiece
            
        case .castle:
            
            let pieceToReverse = board[move.destination]!
            newBoard[move.origin] = pieceToReverse
            newBoard[move.destination] = nil
            
            let isKingsideCastle = move.origin.rank.rawValue < move.destination.rank.rawValue
            let rookToReverseRank = Position.Rank(rawValue:
                isKingsideCastle ? move.destination.rank.rawValue - 1 : move.destination.rank.rawValue + 1
                )!
            let rookCurrentPosition = Position(rookToReverseRank, move.destination.row)
            let rookDestination = Position(isKingsideCastle ? .h : .a, pieceToReverse.owner == .white ? .one : .eight)
            
            let rook = board[rookCurrentPosition]!
            newBoard[rookCurrentPosition] = nil
            newBoard[rookDestination] = rook
            
        case .promotion(_):
            
            let pieceToReverse = Pawn(owner: turn.opponent)
            newBoard[move.origin] = pieceToReverse
            newBoard[move.destination] = move.capturedPiece
            
        }
        
        return Game(board: newBoard, history: newHistory, turn: newTurn)
    }
    
    //MARK: Public Methods
    
    /// - Returns: The position of the king for a particular team
    /// - Parameter team: The team with which to perform a lookup
    public func kingPosition(for team: Team) -> Position {
        return zip(board.indices, board)
            .first(where: { position, piece in
                piece is King && piece?.owner == team
            })!.0
    }
    
    /// - Returns: A grid of threatened positions by a particular team. `true` on the grid represents a position that is threatened
    /// - Parameter team: The team with which to perform a lookup
    public func positionsThreatened(by team: Team) -> BooleanChessGrid {
        
        return zip(board.indices, board)
            .compactMap { position, piece in
                guard piece?.owner == team else {return nil}
                return piece?.threatenedPositions(from: position, in: self)
        }
        .reduce(BooleanChessGrid.false) { (nextPartialResult, moves) -> BooleanChessGrid in
            nextPartialResult.union(moves)
        }
    }
    
    /// - Returns: All moves that are available to the current turn
    public func currentMoves() -> Set<Move> {
        return Game
            .validator
            .validMoves(from: allMoves(for: turn),
                        in: self)
    }
    
    //MARK: Internal Methods
    
    func moves(forPieceAt position: Position) -> Set<Move>? {
        guard let piece = board[position] else {return nil}
        return piece.possibleMoves(from: position, in: self)
    }
    
    func allMoves(for team: Team) -> Set<Move> {
        
        return board.indices
            .reduce(Set<Move>()) { (nextPartialResult, position) -> Set<Move> in
                
                guard let piece = board[position], piece.owner == team else {return nextPartialResult}
                return nextPartialResult.union(piece.possibleMoves(from: position, in: self))
        }
    }
}

