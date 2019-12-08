//
//  GameViewModel.swift
//  SudoChess
//
//  Created by Daniel Panzer on 10/23/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

protocol GameViewModelInterface {
    func select(_ position: Position)
    func reverseLastMove()
    func handlePromotion(with promotionType: Piece.Type)
}

/// A view model that handles the flow of game logic, alternating turns, and AI opponents
public class GameViewModel : ObservableObject, Identifiable {
    
    private typealias ValidMoveCollection = Set<Move>
    
    /// The possible view states
    public enum State : Equatable, CustomStringConvertible {
        case awaitingHumanInput
        case working
        case computerThinking(name: String)
        case stalemate
        case gameOver(Team)
        
        public var description: String {
            switch self {
            case .awaitingHumanInput:
                return "Make your move..."
            case .working:
                return "Processing..."
            case .computerThinking(let name):
                return "\(name) is thinking..."
            case .stalemate:
                return "Stalemate!"
            case .gameOver(let winner):
                return "\(winner) has won!"
            }
        }
    }
    
    /// A board selection
    public struct Selection {
        public let moves: Set<Move>
        public let origin: Position
        
        var grid: BooleanChessGrid {
            return BooleanChessGrid(positions: moves.map {$0.destination})
        }
        
        public func move(for position: Position) -> Move? {
            return moves.first(where: {$0.destination == position})
        }
    }
    
    //MARK: Public Properties
    
    /// The assignment of players for this game
    public let roster: Roster
    
    /// The current game state
    @Published public private(set) var game: Game
    
    /// The current view state
    @Published public private(set) var state: State
    
    /// The current view selection
    @Published public private(set) var selection: Selection?
    
    /// Trigger for a piece promotion prompt
    public var shouldPromptForPromotion = PassthroughSubject<Move, Never>()
    
    //MARK: Private Properties
    
    private let checkHandler: CheckHandlerInterface
    private var validMoveGrid = ChessGrid(repeatingElement: ValidMoveCollection())
    
    //MARK: Lifecycle
    
    public init(roster: Roster, game: Game = Game.standard) {
        self.roster = roster
        self.game = game
        self.checkHandler = CheckHandler()
        self.state = .working
        
        self.beginNextTurn()
    }
    
    init(game: Game,
         roster: Roster = Roster(whitePlayer: .human, blackPlayer: .human),
         selection: Selection? = nil,
         checkHandler: CheckHandlerInterface = CheckHandler()) {
        
        self.game = game
        self.roster = roster
        self.selection = selection
        self.checkHandler = checkHandler
        self.state = .working
        
        self.beginNextTurn()
    }
    
    //MARK: Private Methods
    
    private func regenerateValidMoveGrid(completion: @escaping () -> ()) {
        self.state = .working
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.validMoveGrid = ChessGrid(repeatingElement: ValidMoveCollection())
            let allMoves = self.game.allMoves(for: self.game.turn)
            let validMoves = self.checkHandler.validMoves(from: allMoves, in: self.game)
            
            for validMove in validMoves {
                self.validMoveGrid[validMove.origin].insert(validMove)
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    private func beginNextTurn() {
        self.selection = nil
        
        guard checkHandler.state(for: self.game.turn, in: self.game) != .checkmate else {
            self.state = .gameOver(self.game.turn.opponent)
            return
        }
        
        switch roster[game.turn] {
        case .human:
            regenerateValidMoveGrid {
                self.state = .awaitingHumanInput
            }
        case .ai(let artificialOpponent):
            regenerateValidMoveGrid {
                self.performAIMove(for: artificialOpponent) {
                    self.beginNextTurn()
                }
            }
        }
    }
    
    private func performAIMove(for artificialOpponent: ArtificialOpponent, callback: () -> ()) {
        self.state = .computerThinking(name: artificialOpponent.name)
        
        let minimumThinkingTime = DispatchTime.now() + DispatchTimeInterval.seconds(1)
        
        artificialOpponent.nextMove(in: self.game) { nextMove in
            
            DispatchQueue.main.asyncAfter(deadline: minimumThinkingTime) {
                
                self.select(nextMove.origin)
                
                let selectionDelay = DispatchTime.now() + DispatchTimeInterval.milliseconds(600)
                DispatchQueue.main.asyncAfter(deadline: selectionDelay) {
                    self.perform(nextMove)
                }
            }
        }
    }
    
    private func perform(_ move: Move) {
        game = game.performing(move)
        
        if case .needsPromotion = move.kind {
            
            guard case .human = roster[game.turn.opponent] else {
                handlePromotion(with: Queen.self)
                return
            }
            
            shouldPromptForPromotion.send(move)
        } else {
            beginNextTurn()
        }
    }
    
    private func moves(for position: Position) -> Set<Move>? {
        let moves = validMoveGrid[position]
        return moves.isEmpty ? nil : moves
    }
}

extension GameViewModel : GameViewModelInterface {
    
    //MARK: Public Methods
    
    /// Select a current position on the board
    /// - Parameter position: The position to select
    public func select(_ position: Position) {
        switch selection {
        case .none:
            
            guard let moves = moves(for: position) else {return}
            self.selection = Selection(moves: moves, origin: position)
            
        case .some(let selection):

            if let moves = moves(for: position) {
                self.selection = Selection(moves: moves, origin: position)
            } else if let selectedMove = selection.move(for: position) {
                perform(selectedMove)
                return
            } else {
                self.selection = nil
            }
        }
    }
    
    /// Reverse the last move
    public func reverseLastMove() {
        self.game = game.reversingLastMove()
        
        if case .ai(_) = roster[self.game.turn] {
            self.game = game.reversingLastMove()
        }
        
        beginNextTurn()
    }
    
    /// Handle the promotion of a pawn that has reached the end of the board
    /// - Parameter promotionType: the type of piece to promote to
    public func handlePromotion(with promotionType: Piece.Type) {
        
        let moveToPromote = game.history.last!
        assert(moveToPromote.kind == .needsPromotion)
        
        game = game.reversingLastMove()
        
        let promotionMove = Move(origin: moveToPromote.origin,
                                 destination: moveToPromote.destination,
                                 capturedPiece: moveToPromote.capturedPiece,
                                 kind: .promotion(promotionType.init(owner: game.turn)))
        
        game = game.performing(promotionMove)
        beginNextTurn()
    }
}

