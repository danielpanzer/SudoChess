//
//  RookSpec.swift
//  SudoChessFoundationTests
//
//  Created by Daniel Panzer on 9/11/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import SudoChess

class RookSpec: QuickSpec {
    
    private var subject: Rook!
    private var moveGrid: BooleanChessGrid!
    
    override func spec() {
        
        describe("A rook owned by white") {
            
            beforeEach {
                self.subject = Rook(owner: .white)
            }
            
            afterEach {
                self.subject = nil
            }
            
            let expectedA1Positions = BooleanChessGrid(array: [
                O, X, X, X, X, X, X, X,
                O, X, X, X, X, X, X, X,
                O, X, X, X, X, X, X, X,
                O, X, X, X, X, X, X, X,
                O, X, X, X, X, X, X, X,
                O, X, X, X, X, X, X, X,
                O, X, X, X, X, X, X, X,
                X, O, O, O, O, O, O, O
            ])
            
            let expectedD5Positions = ChessGrid(array: [
                X, X, X, O, X, X, X, X,
                X, X, X, O, X, X, X, X,
                X, X, X, O, X, X, X, X,
                O, O, O, X, O, O, O, O,
                X, X, X, O, X, X, X, X,
                X, X, X, O, X, X, X, X,
                X, X, X, O, X, X, X, X,
                X, X, X, O, X, X, X, X,
            ])
            
            let expectedF8Positions = ChessGrid(array: [
                O, O, O, O, O, X, O, O,
                X, X, X, X, X, O, X, X,
                X, X, X, X, X, O, X, X,
                X, X, X, X, X, O, X, X,
                X, X, X, X, X, O, X, X,
                X, X, X, X, X, O, X, X,
                X, X, X, X, X, O, X, X,
                X, X, X, X, X, O, X, X,
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
                
                it("generates the expected grid of moves") {
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
                
                it("generates the expected grid of moves") {
                    expect(self.moveGrid) == expectedF8Positions
                }
            }
        }
        
        describe("A rook owned by black") {
            
            beforeEach {
                self.subject = Rook(owner: .black)
            }
            
            afterEach {
                self.subject = nil
            }
            
            let expectedA8Positions = ChessGrid(array: [
                X, O, O, O, X, X, X, X,
                O, X, X, X, X, X, X, X,
                O, X, X, X, X, X, X, X,
                O, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
            ])
            
            let expectedH8Positions = ChessGrid(array: [
                X, X, X, X, O, O, O, X,
                X, X, X, X, X, X, X, O,
                X, X, X, X, X, X, X, O,
                X, X, X, X, X, X, X, O,
                X, X, X, X, X, X, X, O,
                X, X, X, X, X, X, X, O,
                X, X, X, X, X, X, X, O,
                X, X, X, X, X, X, X, X,
            ])
            
            context("when considering moves from a8 on a board with colliding friendly pieces") {
                
                beforeEach {
                    var board = Board()
                    board[Position(.a, .four)] = Pawn(owner: .black)
                    board[Position(.e, .eight)] = Rook(owner: .black)
                    let moves = self.subject.possibleMoves(from: Position(.a, .eight), in: Game(board: board))
                    self.moveGrid = BooleanChessGrid(positions: moves.map{$0.destination})
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected grid of moves") {
                    expect(self.moveGrid) == expectedA8Positions
                }
            }
            
            context("when considering threatened positions from a8 on a board with colliding friendly pieces") {
                
                beforeEach {
                    var board = Board()
                    board[Position(.a, .four)] = Pawn(owner: .black)
                    board[Position(.e, .eight)] = Rook(owner: .black)
                    self.moveGrid = self.subject.threatenedPositions(from: Position(.a, .eight), in: Game(board: board))
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected threat grid") {
                    expect(self.moveGrid) == expectedA8Positions
                }
            }
            
            context("when considering moves from h8 on a board with colliding enemy pieces") {
                
                beforeEach {
                    var board = Board()
                    board[Position(.h, .two)] = Pawn(owner: .white)
                    board[Position(.e, .eight)] = Queen(owner: .white)
                    let moves = self.subject.possibleMoves(from: Position(.h, .eight), in: Game(board: board))
                    self.moveGrid = BooleanChessGrid(positions: moves.map{$0.destination})
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected grid of moves") {
                    expect(self.moveGrid) == expectedH8Positions
                }
            }
            
            context("when considering threatened positions from h8 on a board with colliding enemy pieces") {
                
                beforeEach {
                    var board = Board()
                    board[Position(.h, .two)] = Pawn(owner: .white)
                    board[Position(.e, .eight)] = Queen(owner: .white)
                    self.moveGrid = self.subject.threatenedPositions(from: Position(.h, .eight), in: Game(board: board))
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected threat grid") {
                    expect(self.moveGrid) == expectedH8Positions
                }
            }
        }
    }
}
