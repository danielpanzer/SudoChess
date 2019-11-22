//
//  KnightSpec.swift
//  SudoChessFoundationTests
//
//  Created by Daniel Panzer on 9/11/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import SudoChess

class KnightSpec: QuickSpec {
    
    private var subject: Knight!
    private var moveGrid: BooleanChessGrid!
    
    override func spec() {
        
        describe("A Knight owned by white") {
            
            beforeEach {
                self.subject = Knight(owner: .white)
            }
            
            afterEach {
                self.subject = nil
            }
            
            let expectedA1Positions = ChessGrid(array: [
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, O, X, X, X, X, X, X,
                X, X, O, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
            ])
            
            let expectedD5Positions = ChessGrid(array: [
                X, X, X, X, X, X, X, X,
                X, X, O, X, O, X, X, X,
                X, O, X, X, X, O, X, X,
                X, X, X, X, X, X, X, X,
                X, O, X, X, X, O, X, X,
                X, X, O, X, O, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
            ])
            
            let expectedF8Positions = ChessGrid(array: [
                X, X, X, X, X, X, X, X,
                X, X, X, O, X, X, X, O,
                X, X, X, X, O, X, O, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
            ])
            
            let expectedF8PositionsWithFriendlyCollisions = ChessGrid(array: [
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, O, X, O, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
            ])
            
            let expectedF8PositionsWithEnemyCollisions = ChessGrid(array: [
                X, X, X, X, X, X, X, X,
                X, X, X, O, X, X, X, O,
                X, X, X, X, O, X, O, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
            ])
            
            context("when considering moves from a1 on an empty board") {
                
                beforeEach {
                    let emptyBoard = Board()
                    let moves = self.subject.possibleMoves(from: Position(.a, .one), in: Game(board: emptyBoard))
                    self.moveGrid = BooleanChessGrid(positions: moves.map{$0.destination})
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected grid of moves") {
                        expect(self.moveGrid) == expectedA1Positions
                }
            }
            
            context("when considering threatened positions from a1 on an empty board") {
                
                beforeEach {
                    let emptyBoard = Board()
                    self.moveGrid = self.subject.threatenedPositions(from: Position(.a, .one), in: Game(board: emptyBoard))
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected threat grid") {
                    expect(self.moveGrid) == expectedA1Positions
                }
            }

            context("when considering moves from d5 on an empty board") {
                
                beforeEach {
                    let emptyBoard = Board()
                    let moves = self.subject.possibleMoves(from: Position(.d, .five), in: Game(board: emptyBoard))
                    self.moveGrid = BooleanChessGrid(positions: moves.map{$0.destination})
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected grid of moves") {
                        expect(self.moveGrid) == expectedD5Positions
                }
            }
            
            context("when considering threatened positions from d5 on an empty board") {
                
                beforeEach {
                    let emptyBoard = Board()
                    self.moveGrid = self.subject.threatenedPositions(from: Position(.d, .five), in: Game(board: emptyBoard))
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected threat grid") {
                    expect(self.moveGrid) == expectedD5Positions
                }
            }
            
            context("when considering moves from f8 on an empty board") {
                
                beforeEach {
                    let emptyBoard = Board()
                    let moves = self.subject.possibleMoves(from: Position(.f, .eight), in: Game(board: emptyBoard))
                    self.moveGrid = BooleanChessGrid(positions: moves.map{$0.destination})
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected grid of moves") {
                        expect(self.moveGrid) == expectedF8Positions
                }
            }
            
            context("when considering threatened positions from f8 on an empty board") {
                
                beforeEach {
                    let emptyBoard = Board()
                    self.moveGrid = self.subject.threatenedPositions(from: Position(.f, .eight), in: Game(board: emptyBoard))
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected threat grid") {
                    expect(self.moveGrid) == expectedF8Positions
                }
            }
            
            context("when considering moves from f8 on a board with friendly collisions") {
                
                beforeEach {
                    var boardWithFriendlyCollisions = Board()
                    boardWithFriendlyCollisions[Position(.d, .seven)] = Rook(owner: .white)
                    boardWithFriendlyCollisions[Position(.h, .seven)] = Rook(owner: .white)
                    let moves = self.subject.possibleMoves(from: Position(.f, .eight), in: Game(board: boardWithFriendlyCollisions))
                    self.moveGrid = BooleanChessGrid(positions: moves.map{$0.destination})
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected grid of moves") {
                    expect(self.moveGrid) == expectedF8PositionsWithFriendlyCollisions
                }
            }
            
            context("when considering threatened positions from f8 on a board with friendly collisions") {
                
                beforeEach {
                    var boardWithFriendlyCollisions = Board()
                    boardWithFriendlyCollisions[Position(.d, .seven)] = Rook(owner: .white)
                    boardWithFriendlyCollisions[Position(.h, .seven)] = Rook(owner: .white)
                    self.moveGrid = self.subject.threatenedPositions(from: Position(.f, .eight), in: Game(board: boardWithFriendlyCollisions))
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected threat grid") {
                    expect(self.moveGrid) == expectedF8PositionsWithFriendlyCollisions
                }
            }
            
            context("when considering moves from f8 on a board with enemy collisions") {
                
                beforeEach {
                    var boardWithEnemyCollisions = Board()
                    boardWithEnemyCollisions[Position(.d, .seven)] = Rook(owner: .black)
                    boardWithEnemyCollisions[Position(.h, .seven)] = Rook(owner: .black)
                    let moves = self.subject.possibleMoves(from: Position(.f, .eight), in: Game(board: boardWithEnemyCollisions))
                    self.moveGrid = BooleanChessGrid(positions: moves.map{$0.destination})
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected grid of moves") {
                    expect(self.moveGrid) == expectedF8PositionsWithEnemyCollisions
                }
            }
            
            context("when considering threatened positions from f8 on a board with enemy collisions") {
                
                beforeEach {
                    var boardWithEnemyCollisions = Board()
                    boardWithEnemyCollisions[Position(.d, .seven)] = Rook(owner: .black)
                    boardWithEnemyCollisions[Position(.h, .seven)] = Rook(owner: .black)
                    self.moveGrid = self.subject.threatenedPositions(from: Position(.f, .eight), in: Game(board: boardWithEnemyCollisions))
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected grid of moves") {
                    expect(self.moveGrid) == expectedF8PositionsWithEnemyCollisions
                }
            }
        }
    }
}
