//
//  BishopSpec.swift
//  SudoChessFoundationTests
//
//  Created by Daniel Panzer on 9/11/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import SudoChess

class BishopSpec: QuickSpec {
    
    private var subject: Bishop!
    private var grid: BooleanChessGrid!
    
    override func spec() {
        
        describe("A Bishop owned by white") {
            
            beforeEach {
                self.subject = Bishop(owner: .white)
            }
            
            afterEach {
                self.subject = nil
            }
            
            let expectedA1Positions = ChessGrid(array: [
                X, X, X, X, X, X, X, O,
                X, X, X, X, X, X, O, X,
                X, X, X, X, X, O, X, X,
                X, X, X, X, O, X, X, X,
                X, X, X, O, X, X, X, X,
                X, X, O, X, X, X, X, X,
                X, O, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
            ])
            
            let expectedD5Positions = ChessGrid(array: [
                O, X, X, X, X, X, O, X,
                X, O, X, X, X, O, X, X,
                X, X, O, X, O, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, O, X, O, X, X, X,
                X, O, X, X, X, O, X, X,
                O, X, X, X, X, X, O, X,
                X, X, X, X, X, X, X, O,
            ])
            
            let expectedF8Positions = ChessGrid(array: [
                X, X, X, X, X, X, X, X,
                X, X, X, X, O, X, O, X,
                X, X, X, O, X, X, X, O,
                X, X, O, X, X, X, X, X,
                X, O, X, X, X, X, X, X,
                O, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
            ])
            
            context("when considering moves from a1 on an empty board") {
                
                beforeEach {
                    let emptyBoard = Board()
                    let moves = self.subject.possibleMoves(from: Position(.a, .one), in: Game(board: emptyBoard))
                    self.grid = BooleanChessGrid(positions: moves.map{$0.destination})
                }
                
                afterEach {
                    self.grid = nil
                }
                
                it("generates the expected grid of moves") {
                    expect(self.grid) == expectedA1Positions
                }
            }
            
            context("when considering threatened positions from a1 on an empty board") {
                
                beforeEach {
                    let emptyBoard = Board()
                    self.grid = self.subject.threatenedPositions(from: Position(.a, .one), in: Game(board: emptyBoard))
                }
                
                afterEach {
                    self.grid = nil
                }
                
                it("generates the expected threat grid") {
                    expect(self.grid) == expectedA1Positions
                }
            }
            
            context("when considering moves from d5 on an empty board") {
                
                beforeEach {
                    let emptyBoard = Board()
                    let moves = self.subject.possibleMoves(from: Position(.d, .five), in: Game(board: emptyBoard))
                    self.grid = BooleanChessGrid(positions: moves.map{$0.destination})
                }
                
                afterEach {
                    self.grid = nil
                }
                
                it("generates the expected grid of moves") {
                    expect(self.grid) == expectedD5Positions
                }
            }
            
            context("when considering threatened positions from d5 on an empty board") {
                
                beforeEach {
                    let emptyBoard = Board()
                    self.grid = self.subject.threatenedPositions(from: Position(.d, .five), in: Game(board: emptyBoard))
                }
                
                afterEach {
                    self.grid = nil
                }
                
                it("generates the expected threat grid") {
                    expect(self.grid) == expectedD5Positions
                }
            }
            
            context("when considering moves from f8 on an empty board") {
                
                beforeEach {
                    let emptyBoard = Board()
                    let moves = self.subject.possibleMoves(from: Position(.f, .eight), in: Game(board: emptyBoard))
                    self.grid = BooleanChessGrid(positions: moves.map{$0.destination})
                }
                
                afterEach {
                    self.grid = nil
                }
                
                it("generates the expected grid of moves") {
                    expect(self.grid) == expectedF8Positions
                }
            }
            
            context("when considering threatened positions from f8 on an empty board") {
                
                beforeEach {
                    let emptyBoard = Board()
                    self.grid = self.subject.threatenedPositions(from: Position(.f, .eight), in: Game(board: emptyBoard))
                }
                
                afterEach {
                    self.grid = nil
                }
                
                it("generates the expected threat grid") {
                    expect(self.grid) == expectedF8Positions
                }
            }
        }
    }
}
