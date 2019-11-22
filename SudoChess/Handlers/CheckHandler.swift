//
//  CheckHandler.swift
//  SudoChess
//
//  Created by Daniel Panzer on 10/1/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

protocol CheckHandlerInterface {
    func state(for team: Team, in game: Game) -> CheckHandler.State
    func validMoves(from possibleMoves: Set<Move>, in game: Game) -> Set<Move>
}

struct CheckHandler {
    
    enum State {
        case none
        case check
        case checkmate
    }
    
    struct Summary : Equatable {
        let white: State
        let black: State
        
        subscript(team: Team) -> State {
            switch team {
            case .black:
                return self.black
            case .white:
                return self.white
            }
        }
    }
    
    private func oneOfThese(scenarios: [Game], doesNotThreatenTheKingBelongingTo team: Team) -> Bool {
        scenarios
            .filter { scenario in
                let playerNewKingPosition = scenario.kingPosition(for: team)
                let opposingPlayersNewThreatenedPositions = scenario.positionsThreatened(by: team.opponent)
                let playersKingIsThreatenedInThisScenario = opposingPlayersNewThreatenedPositions[playerNewKingPosition]
                return !playersKingIsThreatenedInThisScenario
        }
        .count > 0
    }
}

extension CheckHandler : CheckHandlerInterface {
    
    func state(for team: Team, in game: Game) -> CheckHandler.State {
        
        let whiteKingPosition = game
            .kingPosition(for: .white)
        
        let blackKingPosition = game
            .kingPosition(for: .black)
        
        let whitePlayerThreatenedPositions = game
            .positionsThreatened(by: .white)
        
        let blackPlayerThreatenedPositions = game
            .positionsThreatened(by: .black)
        
        switch team {
            
        case .white:
            
            let whitePlayerStatus: State = {
                
                let whiteKingIsThreatened = blackPlayerThreatenedPositions[whiteKingPosition]
                let allPossibleWhiteMoves = game.allMoves(for: .white)
                let allPossibleNewGameStates = allPossibleWhiteMoves
                    .map {game.performing($0)}
                
                if whiteKingIsThreatened {
                    guard game.turn == .white else {return .checkmate}
                    
                    let somePossibleWhiteMoveEliminatesKingThreat = oneOfThese(scenarios: allPossibleNewGameStates, doesNotThreatenTheKingBelongingTo: .white)
                    return somePossibleWhiteMoveEliminatesKingThreat ? .check : .checkmate
                    
                } else {
                    guard game.turn == .white else {return .none}
                    
                    let somePossibleWhiteMoveDoesNotIntroduceKingThreat = oneOfThese(scenarios: allPossibleNewGameStates, doesNotThreatenTheKingBelongingTo: .white)
                    return somePossibleWhiteMoveDoesNotIntroduceKingThreat ? .none : .checkmate
                }
            }()
            
            return whitePlayerStatus
            
        case .black:
            
            let blackPlayerStatus: State = {
                
                let blackKingIsThreatened = whitePlayerThreatenedPositions[blackKingPosition]
                let allPossibleBlackMoves = game.allMoves(for: .black)
                let allPossibleNewGameStates = allPossibleBlackMoves
                    .map {game.performing($0)}
                
                if blackKingIsThreatened {
                    guard game.turn == .black else {return .checkmate}
                    
                    let somePossibleBlackMoveEliminatesKingThreat = oneOfThese(scenarios: allPossibleNewGameStates, doesNotThreatenTheKingBelongingTo: .black)
                    return somePossibleBlackMoveEliminatesKingThreat ? .check : .checkmate
                    
                } else {
                    guard game.turn == .black else {return .none}
                    
                    let somePossibleBlackMoveDoesNotIntroduceKingThreat = oneOfThese(scenarios: allPossibleNewGameStates, doesNotThreatenTheKingBelongingTo: .black)
                    return somePossibleBlackMoveDoesNotIntroduceKingThreat ? .none : .checkmate
                }
            }()
            
            return blackPlayerStatus
        }
    }
}

extension CheckHandlerInterface {
    
    func validMoves(from possibleMoves: Set<Move>, in game: Game) -> Set<Move> {
        
        let potentialNewScenarios: [Game] = possibleMoves
            .map { possibleMove in game.performing(possibleMove) }
        
        let validMoves: [Move] = zip(possibleMoves, potentialNewScenarios)
            .compactMap { possibleMove, scenario in
                guard state(for: game.turn, in: scenario) == .none else {return nil}
                return possibleMove
        }
        
        return Set(validMoves)
    }
}
