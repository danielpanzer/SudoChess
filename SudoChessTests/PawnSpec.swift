//
//  PawnSpec.swift
//  SudoChessFoundationTests
//
//  Created by Daniel Panzer on 9/11/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import SudoChess

class PawnSpec: QuickSpec {
    
    private static let enPassantValidScenario: Game = {
        
        var board = Board()
        board[Position(.a, .four)] = Pawn(owner: .white)
        board[Position(.b, .four)] = Pawn(owner: .black)
        
        let history = [
            Move(origin: Position(.a, .two), destination: Position(.a, .four), capturedPiece: nil)
        ]
        
        return Game(board: board, history: history, turn: .black)
    }()
    
    private static let enPassantExpiredScenario: Game = {
        
        var board = Board()
        board[Position(.a, .four)] = Pawn(owner: .white)
        board[Position(.b, .four)] = Pawn(owner: .black)
        board[Position(.h, .eight)] = Rook(owner: .black)
        board[Position(.h, .one)] = Rook(owner: .white)
        
        let history = [
            Move(origin: Position(.a, .two), destination: Position(.a, .four), capturedPiece: nil),
            Move(origin: Position(.h, .eight), destination: Position(.h, .seven), capturedPiece: nil),
            Move(origin: Position(.h, .one), destination: Position(.h, .two), capturedPiece: nil)
        ]
        
        return Game(board: board, history: history, turn: .black)
    }()
    
    private static let enPassantAlmostScenario: Game = {
        
        var board = Board()
        board[Position(.a, .four)] = Pawn(owner: .white)
        board[Position(.b, .four)] = Pawn(owner: .black)
        board[Position(.h, .eight)] = Rook(owner: .black)
        board[Position(.h, .one)] = Rook(owner: .white)
        
        let history = [
            Move(origin: Position(.a, .two), destination: Position(.a, .three), capturedPiece: nil),
            Move(origin: Position(.h, .eight), destination: Position(.h, .seven), capturedPiece: nil),
            Move(origin: Position(.a, .three), destination: Position(.a, .four), capturedPiece: nil)
        ]
        
        return Game(board: board, history: history, turn: .black)
    }()
    
    private var subject: Pawn!
    private var moveGrid: BooleanChessGrid!
    private var moves: Set<Move>!
    
    override func spec() {
        
        describe("A Pawn owned by white") {
            
            beforeEach {
                self.subject = Pawn(owner: .white)
            }
            
            afterEach {
                self.subject = nil
            }
            
            context("when considering moves from b2 on an empty board") {
                
                beforeEach {
                    let emptyBoard = Board()
                    let moves = self.subject.possibleMoves(from: Position(.b, .two), in: Game(board: emptyBoard))
                    self.moveGrid = BooleanChessGrid(positions: moves.map{$0.destination})
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected grid of moves") {
                    
                    let expectedMoves = BooleanChessGrid(array: [
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, O, X, X, X, X, X, X,
                        X, O, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                    ])
                    expect(self.moveGrid) == expectedMoves
                }
            }
            
            context("when considering threatened positions from b2 on an empty board") {
                
                beforeEach {
                    let emptyBoard = Board()
                    self.moveGrid = self.subject.threatenedPositions(from: Position(.b, .two), in: Game(board: emptyBoard))
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected threat grid") {
                    
                    let expectedMoves = BooleanChessGrid(array: [
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        O, X, O, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                    ])
                    expect(self.moveGrid) == expectedMoves
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
                    
                    let expectedMoves = ChessGrid(array: [
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, O, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                    ])
                    expect(self.moveGrid) == expectedMoves
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
                    
                    let expectedThreat = ChessGrid(array: [
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, O, X, O, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                    ])
                    expect(self.moveGrid) == expectedThreat
                }
            }
            
            context("when considering moves from d5 on a board with two diagonal captures") {
                
                beforeEach {
                    var board = Board()
                    board[Position(.c, .six)] = Pawn(owner: .black)
                    board[Position(.e, .six)] = Rook(owner: .black)
                    let moves = self.subject.possibleMoves(from: Position(.d, .five), in: Game(board: board))
                    self.moveGrid = BooleanChessGrid(positions: moves.map{$0.destination})
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected grid of moves") {
                    
                    let expectedMoves = ChessGrid(array: [
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, O, O, O, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                    ])
                    expect(self.moveGrid) == expectedMoves
                }
            }
            
            context("when considering threatened positions from d5 on a board with two diagonal captures") {
                
                beforeEach {
                    var board = Board()
                    board[Position(.c, .six)] = Pawn(owner: .black)
                    board[Position(.e, .six)] = Rook(owner: .black)
                    self.moveGrid = self.subject.threatenedPositions(from: Position(.d, .five), in: Game(board: board))
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected threat grid") {
                    
                    let expectedThreat = ChessGrid(array: [
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, O, X, O, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                    ])
                    expect(self.moveGrid) == expectedThreat
                }
            }
            
            context("when considering moves from d5 on a board with two diagonal friendly pieces") {
                
                beforeEach {
                    var board = Board()
                    board[Position(.c, .six)] = Pawn(owner: .white)
                    board[Position(.e, .six)] = Rook(owner: .white)
                    let moves = self.subject.possibleMoves(from: Position(.d, .five), in: Game(board: board))
                    self.moveGrid = BooleanChessGrid(positions: moves.map{$0.destination})
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected grid of moves") {
                    
                    let expectedMoves = ChessGrid(array: [
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, O, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                    ])
                    expect(self.moveGrid) == expectedMoves
                }
            }
            
            context("when considering threatened positions from d5 on a board with two diagonal friendly pieces") {
                
                beforeEach {
                    var board = Board()
                    board[Position(.c, .six)] = Pawn(owner: .white)
                    board[Position(.e, .six)] = Rook(owner: .white)
                    self.moveGrid = self.subject.threatenedPositions(from: Position(.d, .five), in: Game(board: board))
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected threat grid") {
                    
                    let expectedThreat = ChessGrid(array: [
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                    ])
                    expect(self.moveGrid) == expectedThreat
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
                    
                    let expectedMoves = ChessGrid(array: [
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                    ])
                    expect(self.moveGrid) == expectedMoves
                }
            }
            
            context("when considering moves from a2 on a board with a colliding friendly piece") {
                
                beforeEach {
                    var board = Board()
                    board[Position(.a, .three)] = Pawn(owner: .white)
                    let moves = self.subject.possibleMoves(from: Position(.a, .two), in: Game(board: board))
                    self.moveGrid = BooleanChessGrid(positions: moves.map{$0.destination})
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected grid of moves") {
                    
                    let expectedMoves = ChessGrid(array: [
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                    ])
                    expect(self.moveGrid) == expectedMoves
                }
            }
            
            context("when considering moves from a2 on a board with a colliding enemy piece directly in front") {
                
                beforeEach {
                    var board = Board()
                    board[Position(.a, .three)] = Pawn(owner: .black)
                    let moves = self.subject.possibleMoves(from: Position(.a, .two), in: Game(board: board))
                    self.moveGrid = BooleanChessGrid(positions: moves.map{$0.destination})
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected grid of moves") {
                    
                    let expectedMoves = ChessGrid(array: [
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                    ])
                    expect(self.moveGrid) == expectedMoves
                }
            }
            
            context("when considering threatened positions from a2 on a board with a colliding enemy piece directly in front") {
                
                beforeEach {
                    var board = Board()
                    board[Position(.a, .three)] = Pawn(owner: .black)
                    self.moveGrid = self.subject.threatenedPositions(from: Position(.a, .two), in: Game(board: board))
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected threat grid") {
                    
                    let expectedThreat = ChessGrid(array: [
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, O, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                    ])
                    expect(self.moveGrid) == expectedThreat
                }
            }
            
            context("when considering moves from a2 on a board with a colliding enemy piece two squares in front") {
                
                beforeEach {
                    var board = Board()
                    board[Position(.a, .four)] = Pawn(owner: .black)
                    let moves = self.subject.possibleMoves(from: Position(.a, .two), in: Game(board: board))
                    self.moveGrid = BooleanChessGrid(positions: moves.map{$0.destination})
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected grid of moves") {
                    
                    let expectedMoves = ChessGrid(array: [
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        O, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                    ])
                    expect(self.moveGrid) == expectedMoves
                }
            }
            
            context("when considering threatened positions from a2 on a board with a colliding enemy piece two squares in front") {
                
                beforeEach {
                    var board = Board()
                    board[Position(.a, .four)] = Pawn(owner: .black)
                    self.moveGrid = self.subject.threatenedPositions(from: Position(.a, .two), in: Game(board: board))
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected threat grid") {
                    
                    let expectedThreat = ChessGrid(array: [
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, O, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                    ])
                    expect(self.moveGrid) == expectedThreat
                }
            }
            
            context("when considering moves from a2 on a board with a colliding friendly piece and diagonal capture") {
                
                beforeEach {
                    var board = Board()
                    board[Position(.a, .three)] = Pawn(owner: .white)
                    board[Position(.b, .three)] = Rook(owner: .black)
                    let moves = self.subject.possibleMoves(from: Position(.a, .two), in: Game(board: board))
                    self.moveGrid = BooleanChessGrid(positions: moves.map{$0.destination})
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected grid of moves") {
                    
                    let expectedMoves = ChessGrid(array: [
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, O, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                    ])
                    expect(self.moveGrid) == expectedMoves
                }
            }
            
            context("when considering threatened positions from a2 on a board with a colliding friendly piece and diagonal capture") {
                
                beforeEach {
                    var board = Board()
                    board[Position(.a, .three)] = Pawn(owner: .white)
                    board[Position(.b, .three)] = Rook(owner: .black)
                    self.moveGrid = self.subject.threatenedPositions(from: Position(.a, .two), in: Game(board: board))
                }
                
                afterEach {
                    self.moveGrid = nil
                }
                
                it("generates the expected threat grid") {
                    
                    let expectedThreat = ChessGrid(array: [
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, O, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                    ])
                    expect(self.moveGrid) == expectedThreat
                }
            }
            
            context("when considering moves from a7 in an empty board") {
                
                beforeEach {
                    let emptyBoard = Board()
                    self.moves = self.subject.possibleMoves(from: Position(.a, .seven), in: Game(board: emptyBoard))
                }
                
                afterEach {
                    self.moves = nil
                }
                
                it("generates the expected moves") {
                    
                    let expectedMoves = [
                        Move(origin: Position(.a, .seven), destination: Position(.a, .eight), capturedPiece: nil, kind: .needsPromotion),
                    ]
                    expect(self.moves) == Set(expectedMoves)
                }
            }
        }
    
        describe("A Pawn owned by black") {
            
            beforeEach {
                self.subject = Pawn(owner: .black)
            }
            
            afterEach {
                self.subject = nil
            }
            
            context("when considering moves from b4 in a valid en passant scenario") {
                
                beforeEach {
                    let scenario = PawnSpec.enPassantValidScenario
                    let moves = self.subject.possibleMoves(from: Position(.b, .four), in: scenario)
                    self.moveGrid = BooleanChessGrid(positions: moves.map{$0.destination})
                    self.moves = moves
                }
                
                afterEach {
                    self.moveGrid = nil
                    self.moves = nil
                }
                
                it("generates the expected grid of moves") {
                    
                    let expectedMoves = BooleanChessGrid(array: [
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        O, O, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                    ])
                    expect(self.moveGrid) == expectedMoves
                }
                
                it("generates the expected moves") {
                    
                    let expectedMoves = [
                        Move(origin: Position(.b, .four), destination: Position(.b, .three), capturedPiece: nil),
                        Move(origin: Position(.b, .four), destination: Position(.a, .three), capturedPiece: Pawn(owner: .white), kind: .enPassant)
                    ]
                    expect(self.moves) == Set(expectedMoves)
                }
            }
            
            context("when considering moves from b4 in an expired en passant scenario") {
                
                beforeEach {
                    let scenario = PawnSpec.enPassantExpiredScenario
                    let moves = self.subject.possibleMoves(from: Position(.b, .four), in: scenario)
                    self.moveGrid = BooleanChessGrid(positions: moves.map{$0.destination})
                    self.moves = moves
                }
                
                afterEach {
                    self.moveGrid = nil
                    self.moves = nil
                }
                
                it("generates the expected grid of moves") {
                    
                    let expectedMoves = BooleanChessGrid(array: [
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, O, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                    ])
                    expect(self.moveGrid) == expectedMoves
                }
                
                it("generates the expected moves") {
                    
                    let expectedMoves = [
                        Move(origin: Position(.b, .four), destination: Position(.b, .three), capturedPiece: nil),
                    ]
                    expect(self.moves) == Set(expectedMoves)
                }
            }
            
            context("when considering moves from b4 in an almost en passant scenario") {
                
                beforeEach {
                    let scenario = PawnSpec.enPassantAlmostScenario
                    let moves = self.subject.possibleMoves(from: Position(.b, .four), in: scenario)
                    self.moveGrid = BooleanChessGrid(positions: moves.map{$0.destination})
                    self.moves = moves
                }
                
                afterEach {
                    self.moveGrid = nil
                    self.moves = nil
                }
                
                it("generates the expected grid of moves") {
                    
                    let expectedMoves = BooleanChessGrid(array: [
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, O, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                    ])
                    expect(self.moveGrid) == expectedMoves
                }
                
                it("generates the expected moves") {
                    
                    let expectedMoves = [
                        Move(origin: Position(.b, .four), destination: Position(.b, .three), capturedPiece: nil),
                    ]
                    expect(self.moves) == Set(expectedMoves)
                }
            }
            
            context("when considering moves from a2 in a board with a diagonal capture") {
                
                beforeEach {
                    var board = Board()
                    board[Position(.b, .one)] = Knight(owner: .white)
                    self.moves = self.subject.possibleMoves(from: Position(.a, .two), in: Game(board: board))
                }
                
                afterEach {
                    self.moves = nil
                }
                
                it("generates the expected moves") {
                    
                    let expectedMoves = [
                        Move(origin: Position(.a, .two),
                             destination: Position(.a, .one),
                             capturedPiece: nil,
                             kind: .needsPromotion),
                        Move(origin: Position(.a, .two),
                             destination: Position(.b, .one),
                             capturedPiece: Knight(owner: .white),
                             kind: .needsPromotion)
                    ]
                    expect(self.moves) == Set(expectedMoves)
                }
            }
        }
    }
}
