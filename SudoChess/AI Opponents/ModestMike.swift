//
//  ModestMike.swift
//  SudoChess
//
//  Created by Daniel Panzer on 10/23/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

/// AI written around conserving piece values. Will make generally intelligent moves and go after your most valuable pieces
public class ModestMike {
    
    public init() {}
    
    private struct ScenarioAnalysis {
        
        let mostValuablePieceThreatenedByOpponent: Piece?
        let mostValuablePieceThreatenedByUs: Piece?
        
        var opponentThreatValue: Int {
            return mostValuablePieceThreatenedByOpponent?.value ?? 0
        }
        
        var ourThreatValue: Int {
            return mostValuablePieceThreatenedByUs?.value ?? 0
        }
        
        var threatScore: Int {
            return ourThreatValue - opponentThreatValue
        }
    }
    
    private struct MoveAnalysis {
        let capturedPiece: Piece?
        let oldScenario: ScenarioAnalysis
        let newScenario: ScenarioAnalysis
        let move: Move
        
        var exchangeRatio: Int {
            (capturedPiece?.value ?? 0) - newScenario.opponentThreatValue
        }
        
        var threatScore: Int {
            return newScenario.threatScore - oldScenario.threatScore
        }
        
        func isObjectivelyBetter(than otherAnalysis: MoveAnalysis) -> Bool {
            
            guard self.exchangeRatio == otherAnalysis.exchangeRatio else {
                return self.exchangeRatio > otherAnalysis.exchangeRatio
            }
            
            return self.threatScore > otherAnalysis.threatScore
        }
    }
    
    private func analysis(for move: Move, by team: Team, in game: Game) -> MoveAnalysis {
        
        let currentMostValuablePieceThreatenedByOpponent = mostValuablePieceThreatened(by: team.opponent, in: game)
        let currentMostValuablePieceThreatenedByUs = mostValuablePieceThreatened(by: team, in: game)
        let oldScenarioAnalysis = ScenarioAnalysis(mostValuablePieceThreatenedByOpponent: currentMostValuablePieceThreatenedByOpponent,
                                                   mostValuablePieceThreatenedByUs: currentMostValuablePieceThreatenedByUs)
        
        let newScenario = game.performing(move)
        
        let newMostValuablePieceThreatenedByOpponent = mostValuablePieceThreatened(by: team.opponent, in: newScenario)
        let newMostValuablePieceThreatenedByUs = mostValuablePieceThreatened(by: team, in: newScenario)
        let newScenarioAnalysis = ScenarioAnalysis(mostValuablePieceThreatenedByOpponent: newMostValuablePieceThreatenedByOpponent,
                                                   mostValuablePieceThreatenedByUs: newMostValuablePieceThreatenedByUs)
        
        return MoveAnalysis(capturedPiece: move.capturedPiece,
                            oldScenario: oldScenarioAnalysis,
                            newScenario: newScenarioAnalysis,
                            move: move)
    }
    
    private func mostValuablePieceThreatened(by team: Team, in game: Game) -> Piece? {
        
        let threatenedPositions = game.positionsThreatened(by: team)
        
        return zip(threatenedPositions.indices, threatenedPositions)
            .filter { position, isThreatened in isThreatened }
            .compactMap { position, isThreatened in
                guard let piece = game.board[position] else {return nil}
                return piece
        }
        .sorted(by: {$0.value > $1.value})
        .first
    }
    
}

extension ModestMike : ArtificialOpponent {
    
    public var name: String {
        "Modest Mike"
    }
    
    public func nextMove(in game: Game, completion: @escaping (Move) -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let moves = game.currentMoves()
            let analysies = moves
                .map { move in
                    self.analysis(for: move, by: game.turn, in: game)
            }
            .sorted(by: {$0.isObjectivelyBetter(than: $1)})

            DispatchQueue.main.async {
                completion(analysies.first!.move)
            }
        }
    }
}
