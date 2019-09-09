//
//  QueenSpec.swift
//  SudoChessFoundationTests
//
//  Created by Daniel Panzer on 9/11/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import SudoChess

class QueenSpec: QuickSpec {
    
    private var subject: Queen!
    private var moveGrid: BooleanChessGrid!
    
    override func spec() {
        
        describe("A Queen owned by white") {
            
            beforeEach {
                self.subject = Queen(owner: .white)
            }
            
            afterEach {
                self.subject = nil
            }
            
            let expectedA1Positions = ChessGrid(array: [
                O, X, X, X, X, X, X, O,
                O, X, X, X, X, X, O, X,
                O, X, X, X, X, O, X, X,
                O, X, X, X, O, X, X, X,
                O, X, X, O, X, X, X, X,
                O, X, O, X, X, X, X, X,
                O, O, X, X, X, X, X, X,
                X, O, O, O, O, O, O, O
            ])
            
            let expectedD5Positions = ChessGrid(array: [
                O, X, X, O, X, X, O, X,
                X, O, X, O, X, O, X, X,
                X, X, O, O, O, X, X, X,
                O, O, O, X, O, O, O, O,
                X, X, O, O, O, X, X, X,
                X, O, X, O, X, O, X, X,
                O, X, X, O, X, X, O, X,
                X, X, X, O, X, X, X, O,
            ])
            
            let expectedF8Positions = ChessGrid(array: [
                O, O, O, O, O, X, O, O,
                X, X, X, X, O, O, O, X,
                X, X, X, O, X, O, X, O,
                X, X, O, X, X, O, X, X,
                X, O, X, X, X, O, X, X,
                O, X, X, X, X, O, X, X,
                X, X, X, X, X, O, X, X,
                X, X, X, X, X, O, X, X,
            ])
            
            context("when considering moves from a1 on an empty board") {
                
                beforeEach {
                    let emptyGame = Game(board: Board())
                    let moves = self.subject.possibleMoves(from: Position(.a, .one), in: emptyGame)
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
                    let emptyGame = Game(board: Board())
                    self.moveGrid = self.subject.threatenedPositions(from: Position(.a, .one), in: emptyGame)
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
                    let emptyGame = Game(board: Board())
                    let moves = self.subject.possibleMoves(from: Position(.d, .five), in: emptyGame)
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
                    let emptyGame = Game(board: Board())
                    self.moveGrid = self.subject.threatenedPositions(from: Position(.d, .five), in: emptyGame)
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
                    let emptyGame = Game(board: Board())
                    let moves = self.subject.possibleMoves(from: Position(.f, .eight), in: emptyGame)
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
                    let emptyGame = Game(board: Board())
                    self.moveGrid = self.subject.threatenedPositions(from: Position(.f, .eight), in: emptyGame)
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected threat grid") {
                    expect(self.moveGrid) == expectedF8Positions
                }
            }
        }
    }
}
