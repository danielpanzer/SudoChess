//
//  PowerPete.swift
//  SudoChess
//
//  Created by Daniel Panzer on 10/23/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

/// AI written around conserving piece values. Will make generally intelligent moves and go after your most valuable pieces
public class PowerPete {
    
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

extension PowerPete: ArtificialOpponent {
    
    private struct MoveThread {
        let moves: [Move]
        
        
    }
    
    public var name: String {
        "Power Pete"
    }
    
    public func nextMove(in game: Game) -> Move {
        
        let depth = 3
        
        let tree = Tree(root: Tree.Node(value: game))
        
        for _ in stride(from: 0, to: depth, by: 1) {
            let currentLeaves = tree.leaves
            for leaf in currentLeaves {
                
                let scenario = leaf.value
                let newPossibleScenarios = scenario
                    .currentMoves()
                    .map { scenario.performing($0) }
                
                newPossibleScenarios
                    .forEach { newScenario in leaf.add(child: Tree.Node(value: newScenario))}
            }
        }
        
        let bestLeaf = tree.leaves
            .sorted(by: { firstLeaf, secondLeaf in
                let firstAnalysis = analysis(for: firstLeaf.value.history.last!, by: firstLeaf.value.turn.opponent, in: firstLeaf.parent!.value)
                let secondAnalysis = analysis(for: secondLeaf.value.history.last!, by: secondLeaf.value.turn.opponent, in: secondLeaf.parent!.value)
                return firstAnalysis.isObjectivelyBetter(than: secondAnalysis)
        })
        .first!
     
        return bestLeaf
            .parents
            .dropFirst()
            .first!
            .value
            .history
            .last!
    }
}
