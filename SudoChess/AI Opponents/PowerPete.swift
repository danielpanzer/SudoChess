//
//  PowerPete.swift
//  SudoChess
//
//  Created by Daniel Panzer on 10/23/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

/// AI that searches several moves deep to find the best outcome
public class PowerPete: ObservableObject {
    
    private typealias Leaf = Tree<Game>.Node<Game>
    
    public init() {}
    
    @Published public var numberOfNodes: Int = 0
    @Published public var numberOfPotentialScenarios: Int = 0
    @Published public var numberOfAnalysesFinished: Int = 0
    
    private var tree: Tree<Game>!
    private var uiUpdater: Timer?
    
    private struct ScenarioAnalysis {
        
        let mostValuablePieceThreatenedByOpponent: Piece?
        let mostValuablePieceThreatenedByUs: Piece?
        let opponentPieceValue: Int
        let ourPieceValue: Int
        
        var opponentThreatValue: Int {
            return mostValuablePieceThreatenedByOpponent?.value ?? 0
        }
        
        var ourThreatValue: Int {
            return mostValuablePieceThreatenedByUs?.value ?? 0
        }
        
        var threatScore: Int {
            return ourThreatValue - opponentThreatValue
        }
        
        var pieceScore: Int {
            return ourPieceValue - opponentPieceValue
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
        
        var pieceScore: Int {
            return newScenario.pieceScore - oldScenario.pieceScore
        }
        
        func isObjectivelyBetter(than otherAnalysis: MoveAnalysis) -> Bool {
            
            guard self.pieceScore >= otherAnalysis.pieceScore else {
                return false
            }
            
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
                                                   mostValuablePieceThreatenedByUs: currentMostValuablePieceThreatenedByUs,
                                                   opponentPieceValue: pieceValue(of: team.opponent, in: game),
                                                   ourPieceValue: pieceValue(of: team, in: game))
        
        let newScenario = game.performing(move)
        
        let newMostValuablePieceThreatenedByOpponent = mostValuablePieceThreatened(by: team.opponent, in: newScenario)
        let newMostValuablePieceThreatenedByUs = mostValuablePieceThreatened(by: team, in: newScenario)
        let newScenarioAnalysis = ScenarioAnalysis(mostValuablePieceThreatenedByOpponent: newMostValuablePieceThreatenedByOpponent,
                                                   mostValuablePieceThreatenedByUs: newMostValuablePieceThreatenedByUs,
                                                   opponentPieceValue: pieceValue(of: team.opponent, in: newScenario),
                                                   ourPieceValue: pieceValue(of: team, in: newScenario))
        
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
    
    private func pieceValue(of team: Team, in game: Game) -> Int {
        return game
            .board
            .compactMap {$0}
            .filter {$0.owner == team && !($0 is King)}
            .reduce(0) {currentValue, piece in return currentValue + piece.value}
    }
}

extension PowerPete: ArtificialOpponent {
    
    public var name: String {
        "Power Pete"
    }
    
    public func nextMove(in game: Game, completion: @escaping (Move) -> ()) {
        
        DispatchQueue.main.async {
            self.numberOfNodes = 0
            self.numberOfPotentialScenarios = 0
            self.numberOfAnalysesFinished = 0
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let depth = 3
            
            self.tree = Tree(root: Tree.Node(value: game))
            
            for _ in stride(from: 0, to: depth, by: 1) {
                
                let currentLeaves: [Leaf] = {
                    let leaves = self.tree.leaves
                    return leaves.count > 0 ? leaves : [self.tree.root]
                }()
                
                let calculateChildrenForIteration = DispatchGroup()
                
                for leaf in currentLeaves {
                    
                    calculateChildrenForIteration.enter()
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        
                        let scenario = leaf.value
                        let newPossibleScenarios = scenario
                            .currentMoves()
                            .map { scenario.performing($0) }
                        
                        newPossibleScenarios
                            .forEach {
                                newScenario in leaf.add(child: Tree.Node(value: newScenario))
                        }
                        
                        DispatchQueue.main.async {
                            self.numberOfNodes += newPossibleScenarios.count
                            calculateChildrenForIteration.leave()
                        }
                    }
                }
                
                calculateChildrenForIteration.wait()
            }
            
            DispatchQueue.main.async {
                self.numberOfPotentialScenarios = self.tree.leaves.count
            }
            
            self.analyses(for: self.tree.leaves) { leavesAndAnalyses in
                
                let bestLeafAndAnalysis = leavesAndAnalyses
                    .sorted(by: { firstLeafAndAnalysis, secondLeafAndAnalysis in
                        let firstAnalysis = firstLeafAndAnalysis.analysis
                        let secondAnalysis = secondLeafAndAnalysis.analysis
                        return firstAnalysis.isObjectivelyBetter(than: secondAnalysis)
                    })
                    .first!
                
                let result = bestLeafAndAnalysis
                    .leaf
                    .parents
                    .dropFirst()
                    .first!
                    .value
                    .history
                    .last!
                
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    private func analyses(for leaves: [Leaf], callback: @escaping ([(leaf: Leaf, analysis: MoveAnalysis)]) -> ()) {
        
        var result = [(Leaf, MoveAnalysis)]()
        let mutex = DispatchQueue(label: "AnalysesForLeavesMutex", qos: .userInitiated)
        let calculations = DispatchGroup()
        
        for leaf in leaves {
            calculations.enter()
            
            DispatchQueue.global(qos: .userInitiated).async {
                let data = self.analysis(for: leaf.value.history.last!,
                                         by: leaf.value.turn.opponent,
                                         in: leaf.parent!.value)
                
                let entry = (leaf, data)
                
                mutex.async {
                    result.append(entry)
                    calculations.leave()
                }
            }
        }
        
        DispatchQueue.main.async {
            self.uiUpdater = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                
                mutex.async {
                    let count = result.count
                    
                    DispatchQueue.main.async {
                        self.numberOfAnalysesFinished = count
                    }
                }
            }
        }
        
        calculations.notify(queue: mutex) {
            self.uiUpdater?.fire()
            self.uiUpdater?.invalidate()
            self.uiUpdater = nil
            callback(result)
        }
    }
}
