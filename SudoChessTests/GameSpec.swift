//
//  GameSpec.swift
//  SudoChessFoundationTests
//
//  Created by Daniel Panzer on 10/2/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import SudoChess

class GameSpec: QuickSpec {
    
    private static let enPassantValidScenario: Game = {
        
        var board = Board()
        board[Position(.a, .four)] = Pawn(owner: .white)
        board[Position(.b, .four)] = Pawn(owner: .black)
        
        let history = [
            Move(origin: Position(.a, .two), destination: Position(.a, .four), capturedPiece: nil)
        ]
        
        return Game(board: board, history: history, turn: .black)
    }()
    
    private static let castleQueensideValidScenario: Game = {
        
        var board = Board()
        board[Position(.a, .one)] = Rook(owner: .white)
        board[Position(.e, .one)] = King(owner: .white)
        
        return Game(board: board)
    }()
    
    private static let castleKingsideValidScenario: Game = {
        
        var board = Board()
        board[Position(.h, .one)] = Rook(owner: .white)
        board[Position(.e, .one)] = King(owner: .white)
        
        return Game(board: board)
    }()
    
    private static let queensideCastle = Move(origin: Position(.e, .one),
                                              destination: Position(.c, .one),
                                              capturedPiece: nil, kind: .castle)
    
    private static let kingsideCastle = Move(origin: Position(.e, .one),
                                             destination: Position(.g, .one),
                                             capturedPiece: nil, kind: .castle)
    
    private var subject: Game!
    private var moves: Set<Move>!
    
    override func spec() {
        
        describe("A game with a standard starting chessboard") {
            
            beforeEach {
                self.subject = Game(board: Board.standard)
            }
            
            afterEach {
                self.subject = nil
            }
            
            context("when querying for valid moves for a tile with no piece") {
                
                beforeEach {
                    self.moves = self.subject.moves(forPieceAt: Position(.a, .four))
                }
                
                afterEach {
                    self.moves = nil
                }
                
                it("reports nil") {
                    expect(self.moves).to(beNil())
                }
            }
            
            context("when querying for valid moves on the white pawn at a2") {
                
                beforeEach {
                    self.moves = self.subject.moves(forPieceAt: Position(.a, .two))
                }
                
                afterEach {
                    self.moves = nil
                }
                
                it("reports all expected pawn moves") {
                    let expectedMoves = [
                        Move(origin: Position(.a, .two),
                             destination: Position(.a, .three),
                             capturedPiece: nil),
                        Move(origin: Position(.a, .two),
                             destination: Position(.a, .four),
                             capturedPiece: nil)
                        
                        ].toSet()
                    expect(self.moves) == expectedMoves
                }
            }
            
            context("when performing a basic pawn move") {
                
                let fromPosition = Position(.a, .two)
                let toPosition = Position(.a, .three)
                let move = Move(origin: fromPosition,
                                destination: toPosition,
                                capturedPiece: nil)
                
                beforeEach {
                    self.subject = self.subject.performing(move)
                }
                
                it("performs the move") {
                    var expectedBoard = Board.standard
                    let pieceToMove = expectedBoard[fromPosition]
                    expectedBoard[fromPosition] = nil
                    expectedBoard[toPosition] = pieceToMove
                    
                    expect(self.subject.board) == expectedBoard
                }
                
                it("adds the move to history") {
                    expect(self.subject.history) == [move]
                }
                
                it("alternates the turn") {
                    expect(self.subject.turn) == .black
                }
            }
            
            context("when reversing the last move with no moves to reverse") {
                
                beforeEach {
                    self.subject = self.subject.reversingLastMove()
                }
                
                it("does nothing to board") {
                    expect(self.subject.board) == Board.standard
                }
                
                it("does nothing to move history") {
                    expect(self.subject.history).to(beEmpty())
                }
                
                it("does nothing to current turn") {
                    expect(self.subject.turn) == .white
                }
            }
        }
        
        describe("A game after a basic pawn move") {
            
            beforeEach {
                
                let fromPosition = Position(.a, .two)
                let toPosition = Position(.a, .three)
                let move = Move(origin: fromPosition,
                                destination: toPosition,
                                capturedPiece: nil)
                
                self.subject = Game.standard
                self.subject = self.subject.performing(move)
            }
            
            afterEach {
                self.subject = nil
            }
            
            context("when reversing the move") {
                
                beforeEach {
                    self.subject = self.subject.reversingLastMove()
                }
                
                it("undoes the move") {
                    expect(self.subject.board) == Board.standard
                }
                
                it("removes the move from history") {
                    expect(self.subject.history).to(beEmpty())
                }
                
                it("reverses the turn") {
                    expect(self.subject.turn) == .white
                }
            }
        }
        
        describe("A game in an en passant valid scenario") {
            
            beforeEach {
                self.subject = GameSpec.enPassantValidScenario
            }
            
            afterEach {
                self.subject = nil
            }
            
            context("after performing the en passant move") {
                
                beforeEach {
                    let move = Move(origin: Position(.b, .four),
                                    destination: Position(.a, .three),
                                    capturedPiece: Pawn(owner: .white),
                                    kind: .enPassant)
                    self.subject = self.subject.performing(move)
                }
                
                it("performs the move") {
                    var expectedBoard = Board()
                    expectedBoard[Position(.a, .three)] = Pawn(owner: .black)
                    
                    expect(self.subject.board) == expectedBoard
                }
                
                it("adds the move to history") {
                    let expectedHistory = [
                        Move(origin: Position(.a, .two),
                             destination: Position(.a, .four),
                             capturedPiece: nil),
                        Move(origin: Position(.b, .four),
                             destination: Position(.a, .three),
                             capturedPiece: Pawn(owner: .white),
                             kind: .enPassant)
                    ]
                    
                    expect(self.subject.history) == expectedHistory
                }
                
                it("alternates the turn") {
                    expect(self.subject.turn) == .white
                }
            }
        }
        
        describe("A game after just performing an en passant") {
            
            beforeEach {
                let game = GameSpec.enPassantValidScenario
                let move = Move(origin: Position(.b, .four),
                                destination: Position(.a, .three),
                                capturedPiece: Pawn(owner: .white),
                                kind: .enPassant)
                self.subject = game.performing(move)
            }
            
            afterEach {
                self.subject = nil
            }
            
            context("when reversing the move") {
                
                beforeEach {
                    self.subject = self.subject.reversingLastMove()
                }
                
                it("restores the expected state") {
                    expect(self.subject) == GameSpec.enPassantValidScenario
                }
            }
        }
        
        describe("A game in a queenside castling valid scenario") {
            
            beforeEach {
                self.subject = GameSpec.castleQueensideValidScenario
            }
            
            afterEach {
                self.subject = nil
            }
            
            context("when performing the castle") {
                
                beforeEach {
                    self.subject = self.subject.performing(GameSpec.queensideCastle)
                }
                
                it("performs the move") {
                    var expectedBoard = Board()
                    expectedBoard[Position(.c, .one)] = King(owner: .white)
                    expectedBoard[Position(.d, .one)] = Rook(owner: .white)
                    
                    expect(self.subject.board) == expectedBoard
                }
                
                it("adds the move to history") {
                    expect(self.subject.history) == [GameSpec.queensideCastle]
                }
                
                it("alternates the turn") {
                    expect(self.subject.turn) == .black
                }
            }
        }
        
        describe("A game in a kingside castling valid scenario") {
            
            beforeEach {
                self.subject = GameSpec.castleKingsideValidScenario
            }
            
            afterEach {
                self.subject = nil
            }
            
            context("when performing the castle") {
                
                beforeEach {
                    self.subject = self.subject.performing(GameSpec.kingsideCastle)
                }
                
                it("performs the move") {
                    var expectedBoard = Board()
                    expectedBoard[Position(.g, .one)] = King(owner: .white)
                    expectedBoard[Position(.f, .one)] = Rook(owner: .white)
                    
                    expect(self.subject.board) == expectedBoard
                }
                
                it("adds the move to history") {
                    expect(self.subject.history) == [GameSpec.kingsideCastle]
                }
                
                it("alternates the turn") {
                    expect(self.subject.turn) == .black
                }
            }
        }
        
        describe("A game after just performing a queenside castle") {
            
            beforeEach {
                let game = GameSpec.castleQueensideValidScenario
                self.subject = game.performing(GameSpec.queensideCastle)
            }
            
            afterEach {
                self.subject = nil
            }
            
            context("when reversing the move") {
                
                beforeEach {
                    self.subject = self.subject.reversingLastMove()
                }
                
                it("restores the expected state") {
                    expect(self.subject) == GameSpec.castleQueensideValidScenario
                }
            }
        }
        
        describe("A game after just performing a kingside castle") {
            
            beforeEach {
                let game = GameSpec.castleKingsideValidScenario
                self.subject = game.performing(GameSpec.kingsideCastle)
            }
            
            afterEach {
                self.subject = nil
            }
            
            context("when reversing the move") {
                
                beforeEach {
                    self.subject = self.subject.reversingLastMove()
                }
                
                it("restores the expected state") {
                    expect(self.subject) == GameSpec.castleKingsideValidScenario
                }
            }
        }
    }
}
