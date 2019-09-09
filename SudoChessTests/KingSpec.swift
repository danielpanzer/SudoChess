//
//  KingSpec.swift
//  SudoChessFoundationTests
//
//  Created by Daniel Panzer on 9/11/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import SudoChess

class KingSpec: QuickSpec {
    
    private static let castleWhiteQueensideValidScenario: Game = {
        
        var board = Board()
        board[Position(.a, .one)] = Rook(owner: .white)
        board[Position(.e, .one)] = King(owner: .white)
        
        return Game(board: board)
    }()
    
    private static let castleWhiteKingsideValidScenario: Game = {
        
        var board = Board()
        board[Position(.h, .one)] = Rook(owner: .white)
        board[Position(.e, .one)] = King(owner: .white)
        
        return Game(board: board)
    }()
    
    private static let castleWhiteBothSidesValidScenario: Game = {
        
        var board = Board()
        board[Position(.a, .one)] = Rook(owner: .white)
        board[Position(.h, .one)] = Rook(owner: .white)
        board[Position(.e, .one)] = King(owner: .white)
        
        return Game(board: board)
    }()
    
    private static let castleWhiteIncorrectRookPositionScenario: Game = {
        
        var board = Board()
        board[Position(.b, .one)] = Rook(owner: .white)
        board[Position(.e, .one)] = King(owner: .white)
        
        return Game(board: board)
    }()
    
    private static let castleWhiteQueensideButCollidingPiecesScenario: Game = {
        
        var board = Board()
        board[Position(.a, .one)] = Rook(owner: .white)
        board[Position(.b, .one)] = Knight(owner: .white)
        board[Position(.e, .one)] = King(owner: .white)
        
        return Game(board: board)
    }()
    
    private static let castleWhiteKingsideValidWithCollidingPiecesOnQueensideScenario: Game = {
        
        var board = Board()
        board[Position(.h, .one)] = Rook(owner: .white)
        board[Position(.e, .one)] = King(owner: .white)
        board[Position(.d, .one)] = Queen(owner: .white)
        board[Position(.c, .one)] = Bishop(owner: .white)
        board[Position(.b, .one)] = Knight(owner: .white)
        
        return Game(board: board)
    }()
    
    private static let castleWhiteKingsideButCollidingPiecesScenario: Game = {
        
        var board = Board()
        board[Position(.h, .one)] = Rook(owner: .white)
        board[Position(.f, .one)] = Bishop(owner: .white)
        board[Position(.e, .one)] = King(owner: .white)
        
        return Game(board: board)
    }()
    
    private static let castleWhiteIncorrectKingPositionScenario: Game = {
        
        var board = Board()
        board[Position(.a, .one)] = Rook(owner: .white)
        board[Position(.h, .one)] = Rook(owner: .white)
        board[Position(.d, .one)] = King(owner: .white)
        
        return Game(board: board)
    }()
    
    private static let castleWhiteKingsideRookMovedScenario: Game = {
        
        var board = Board()
        board[Position(.h, .one)] = Rook(owner: .white)
        board[Position(.e, .one)] = King(owner: .white)
        
        let history = [
            Move(origin: Position(.h, .one), destination: Position(.h, .three), capturedPiece: nil),
            Move(origin: Position(.h, .three), destination: Position(.h, .one), capturedPiece: nil)
        ]
        
        return Game(board: board, history: history, turn: .white)
    }()
    
    private static let castleWhiteKingsideInCheckScenario: Game = {
        
        var board = Board()
        board[Position(.h, .one)] = Rook(owner: .white)
        board[Position(.e, .one)] = King(owner: .white)
        board[Position(.e, .five)] = Rook(owner: .black)
        
        return Game(board: board)
    }()
    
    private static let castleWhiteKingsideDestinationThreatenedScenario: Game = {
        
        var board = Board()
        board[Position(.h, .one)] = Rook(owner: .white)
        board[Position(.e, .one)] = King(owner: .white)
        board[Position(.g, .five)] = Rook(owner: .black)
        
        return Game(board: board)
    }()
    
    private static let castleWhiteKingsideTransitionSpaceThreatenedScenario: Game = {
        
        var board = Board()
        board[Position(.h, .one)] = Rook(owner: .white)
        board[Position(.e, .one)] = King(owner: .white)
        board[Position(.f, .five)] = Rook(owner: .black)
        
        return Game(board: board)
    }()
    
    private static let castleWhiteQueensideValidWithQueenThreateningRookAndRookTransitionSpaceScenario: Game = {
        
        var board = Board()
        board[Position(.a, .one)] = Rook(owner: .white)
        board[Position(.e, .one)] = King(owner: .white)
        board[Position(.a, .two)] = Queen(owner: .black)
        
        return Game(board: board)
    }()
    
    private static let castleBlackQueensideValidScenario: Game = {
        
        var board = Board()
        board[Position(.a, .eight)] = Rook(owner: .black)
        board[Position(.e, .eight)] = King(owner: .black)
        
        return Game(board: board)
    }()
    
    private static let castleBlackKingsideValidScenario: Game = {
        
        var board = Board()
        board[Position(.h, .eight)] = Rook(owner: .black)
        board[Position(.e, .eight)] = King(owner: .black)
        
        return Game(board: board)
    }()
    
    private var subject: King!
    private var moveGrid: BooleanChessGrid!
    private var moves: Set<Move>!
    
    override func spec() {
        
        describe("A King owned by white") {
            
            beforeEach {
                self.subject = King(owner: .white)
            }
            
            afterEach {
                self.subject = nil
            }
            
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
                    
                    let expectedMoves = ChessGrid(array: [
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        O, O, X, X, X, X, X, X,
                        X, O, X, X, X, X, X, X
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
                        X, X, O, O, O, X, X, X,
                        X, X, O, X, O, X, X, X,
                        X, X, O, O, O, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                    ])
                    expect(self.moveGrid) == expectedMoves
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
                        X, X, X, X, O, X, O, X,
                        X, X, X, X, O, O, O, X,
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
            
            context("when considering moves from d5 on an board with a friendly piece in collision") {
                
                beforeEach {
                    var board = Board()
                    board[Position(.d, .four)] = Pawn(owner: .white)
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
                        X, X, O, X, O, X, X, X,
                        X, X, O, X, O, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                    ])
                    expect(self.moveGrid) == expectedMoves
                }
            }
            
            context("when considering moves from d5 on an board with an enemy piece in collision") {
                
                beforeEach {
                    var board = Board()
                    board[Position(.d, .four)] = Pawn(owner: .black)
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
                        X, X, O, X, O, X, X, X,
                        X, X, O, O, O, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                        X, X, X, X, X, X, X, X,
                    ])
                    expect(self.moveGrid) == expectedMoves
                }
            }
            
            context("when considering moves from e1 on an board with a valid queenside castle") {
                
                beforeEach {
                    self.moves = self.subject.possibleMoves(from: Position(.e, .one), in: KingSpec.castleWhiteQueensideValidScenario)
                }
                
                afterEach {
                    self.moves = nil
                }
                
                it("generates the expected moves including a castle") {
                    let expectedMoves = [
                        Move(origin: Position(.e, .one), destination: Position(.e, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.f, .one), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.d, .one), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.f, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.d, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.c, .one), capturedPiece: nil, kind: .castle),
                    ]
                    
                    expect(self.moves) == Set(expectedMoves)
                }
            }
            
            context("when considering moves from e1 on an board with a valid kingside castle") {
                
                beforeEach {
                    self.moves = self.subject.possibleMoves(from: Position(.e, .one), in: KingSpec.castleWhiteKingsideValidScenario)
                }
                
                afterEach {
                    self.moves = nil
                }
                
                it("generates the expected moves including a castle") {
                    let expectedMoves = [
                        Move(origin: Position(.e, .one), destination: Position(.e, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.f, .one), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.d, .one), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.f, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.d, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.g, .one), capturedPiece: nil, kind: .castle),
                    ]
                    
                    expect(self.moves) == Set(expectedMoves)
                }
            }
            
            context("when considering moves from e1 on an board with two valid castling scenarios") {
                
                beforeEach {
                    self.moves = self.subject.possibleMoves(from: Position(.e, .one), in: KingSpec.castleWhiteBothSidesValidScenario)
                }
                
                afterEach {
                    self.moves = nil
                }
                
                it("generates the expected moves including both castles") {
                    let expectedMoves = [
                        Move(origin: Position(.e, .one), destination: Position(.e, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.f, .one), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.d, .one), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.f, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.d, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.g, .one), capturedPiece: nil, kind: .castle),
                        Move(origin: Position(.e, .one), destination: Position(.c, .one), capturedPiece: nil, kind: .castle)
                    ]
                    
                    expect(self.moves) == Set(expectedMoves)
                }
            }
            
            context("when considering moves from e1 on an board with valid kingside positioning but with a rook that previously moved") {
                
                beforeEach {
                    self.moves = self.subject.possibleMoves(from: Position(.e, .one), in: KingSpec.castleWhiteKingsideRookMovedScenario)
                }
                
                afterEach {
                    self.moves = nil
                }
                
                it("generates the expected non-castling moves") {
                    let expectedMoves = [
                        Move(origin: Position(.e, .one), destination: Position(.e, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.f, .one), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.d, .one), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.f, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.d, .two), capturedPiece: nil)
                    ]
                    
                    expect(self.moves) == Set(expectedMoves)
                }
            }
            
            context("when considering moves from d1 on an board with otherwise valid castling scenarios") {
                
                beforeEach {
                    self.moves = self.subject.possibleMoves(from: Position(.d, .one), in: KingSpec.castleWhiteIncorrectKingPositionScenario)
                }
                
                afterEach {
                    self.moves = nil
                }
                
                it("generates the expected non-castling moves") {
                    let expectedMoves = [
                        Move(origin: Position(.d, .one), destination: Position(.d, .two), capturedPiece: nil),
                        Move(origin: Position(.d, .one), destination: Position(.e, .one), capturedPiece: nil),
                        Move(origin: Position(.d, .one), destination: Position(.c, .one), capturedPiece: nil),
                        Move(origin: Position(.d, .one), destination: Position(.e, .two), capturedPiece: nil),
                        Move(origin: Position(.d, .one), destination: Position(.c, .two), capturedPiece: nil)
                    ]
                    
                    expect(self.moves) == Set(expectedMoves)
                }
            }
            
            context("when considering moves from e1 on an board with close to a valid castling scenario") {
                
                beforeEach {
                    self.moves = self.subject.possibleMoves(from: Position(.e, .one), in: KingSpec.castleWhiteIncorrectRookPositionScenario)
                }
                
                afterEach {
                    self.moves = nil
                }
                
                it("generates the expected non-castling moves") {
                    let expectedMoves = [
                        Move(origin: Position(.e, .one), destination: Position(.e, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.f, .one), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.d, .one), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.f, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.d, .two), capturedPiece: nil)
                    ]
                    
                    expect(self.moves) == Set(expectedMoves)
                }
            }
            
            context("when considering moves from e1 on an board with a colliding piece in an otherwise queenside scenario") {
                
                beforeEach {
                    self.moves = self.subject.possibleMoves(from: Position(.e, .one), in: KingSpec.castleWhiteQueensideButCollidingPiecesScenario)
                }
                
                afterEach {
                    self.moves = nil
                }
                
                it("generates the expected non-castling moves") {
                    let expectedMoves = [
                        Move(origin: Position(.e, .one), destination: Position(.e, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.f, .one), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.d, .one), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.f, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.d, .two), capturedPiece: nil)
                    ]
                    
                    expect(self.moves) == Set(expectedMoves)
                }
            }
            
            context("when considering moves from e1 on an board with a colliding piece in an otherwise kingside scenario") {
                
                beforeEach {
                    self.moves = self.subject.possibleMoves(from: Position(.e, .one), in: KingSpec.castleWhiteKingsideButCollidingPiecesScenario)
                }
                
                afterEach {
                    self.moves = nil
                }
                
                it("generates the expected non-castling moves") {
                    let expectedMoves = [
                        Move(origin: Position(.e, .one), destination: Position(.e, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.d, .one), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.f, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.d, .two), capturedPiece: nil)
                    ]
                    
                    expect(self.moves) == Set(expectedMoves)
                }
            }
            
            context("when considering moves from e1 on an board with a valid kingside castle and queenside piece collisions") {
                
                beforeEach {
                    self.moves = self.subject.possibleMoves(from: Position(.e, .one), in: KingSpec.castleWhiteKingsideValidWithCollidingPiecesOnQueensideScenario)
                }
                
                afterEach {
                    self.moves = nil
                }
                
                it("generates the expected moves including a castle") {
                    let expectedMoves = [
                        Move(origin: Position(.e, .one), destination: Position(.e, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.f, .one), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.f, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.d, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.g, .one), capturedPiece: nil, kind: .castle),
                    ]
                    
                    expect(self.moves) == Set(expectedMoves)
                }
            }
            
            context("when considering moves from e1 on an board where the king is in check in an otherwise kingside valid scenario") {
                
                beforeEach {
                    self.moves = self.subject.possibleMoves(from: Position(.e, .one), in: KingSpec.castleWhiteKingsideInCheckScenario)
                }
                
                afterEach {
                    self.moves = nil
                }
                
                it("generates the expected non-castling moves") {
                    let expectedMoves = [
                        Move(origin: Position(.e, .one), destination: Position(.e, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.f, .one), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.d, .one), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.f, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.d, .two), capturedPiece: nil)
                    ]
                    
                    expect(self.moves) == Set(expectedMoves)
                }
            }
            
            context("when considering moves from e1 on an board where the castling destination is threatened in an otherwise kingside valid scenario") {
                
                beforeEach {
                    self.moves = self.subject.possibleMoves(from: Position(.e, .one), in: KingSpec.castleWhiteKingsideDestinationThreatenedScenario)
                }
                
                afterEach {
                    self.moves = nil
                }
                
                it("generates the expected non-castling moves") {
                    let expectedMoves = [
                        Move(origin: Position(.e, .one), destination: Position(.e, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.f, .one), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.d, .one), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.f, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.d, .two), capturedPiece: nil)
                    ]
                    
                    expect(self.moves) == Set(expectedMoves)
                }
            }
            
            context("when considering moves from e1 on an board where the castling transition space is threatened in an otherwise kingside valid scenario") {
                
                beforeEach {
                    self.moves = self.subject.possibleMoves(from: Position(.e, .one), in: KingSpec.castleWhiteKingsideTransitionSpaceThreatenedScenario)
                }
                
                afterEach {
                    self.moves = nil
                }
                
                it("generates the expected non-castling moves") {
                    let expectedMoves = [
                        Move(origin: Position(.e, .one), destination: Position(.e, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.f, .one), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.d, .one), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.f, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.d, .two), capturedPiece: nil)
                    ]
                    
                    expect(self.moves) == Set(expectedMoves)
                }
            }
            
            context("when considering moves from e1 on an board where the queenside rook and rook transition space are threatened") {
                
                beforeEach {
                    self.moves = self.subject.possibleMoves(from: Position(.e, .one),
                                                            in: KingSpec.castleWhiteQueensideValidWithQueenThreateningRookAndRookTransitionSpaceScenario)
                }
                
                afterEach {
                    self.moves = nil
                }
                
                it("generates the expected moves including a castle") {
                    let expectedMoves = [
                        Move(origin: Position(.e, .one), destination: Position(.e, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.f, .one), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.d, .one), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.f, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.d, .two), capturedPiece: nil),
                        Move(origin: Position(.e, .one), destination: Position(.c, .one), capturedPiece: nil, kind: .castle)
                    ]
                    
                    expect(self.moves) == Set(expectedMoves)
                }
            }
        }
        
        describe("A King owned by black") {
            
            beforeEach {
                self.subject = King(owner: .black)
            }
            
            afterEach {
                self.subject = nil
            }
            
            context("when considering moves from e8 on an board with a valid queenside castle") {
                
                beforeEach {
                    self.moves = self.subject.possibleMoves(from: Position(.e, .eight), in: KingSpec.castleBlackQueensideValidScenario)
                }
                
                afterEach {
                    self.moves = nil
                }
                
                it("generates the expected moves including a castle") {
                    let expectedMoves = [
                        Move(origin: Position(.e, .eight), destination: Position(.e, .seven), capturedPiece: nil),
                        Move(origin: Position(.e, .eight), destination: Position(.f, .eight), capturedPiece: nil),
                        Move(origin: Position(.e, .eight), destination: Position(.d, .eight), capturedPiece: nil),
                        Move(origin: Position(.e, .eight), destination: Position(.f, .seven), capturedPiece: nil),
                        Move(origin: Position(.e, .eight), destination: Position(.d, .seven), capturedPiece: nil),
                        Move(origin: Position(.e, .eight), destination: Position(.c, .eight), capturedPiece: nil, kind: .castle),
                    ]
                    
                    expect(self.moves) == Set(expectedMoves)
                }
            }
            
            context("when considering moves from e8 on an board with a valid kingside castle") {
                
                beforeEach {
                    self.moves = self.subject.possibleMoves(from: Position(.e, .eight), in: KingSpec.castleBlackKingsideValidScenario)
                }
                
                afterEach {
                    self.moves = nil
                }
                
                it("generates the expected moves including a castle") {
                    let expectedMoves = [
                        Move(origin: Position(.e, .eight), destination: Position(.e, .seven), capturedPiece: nil),
                        Move(origin: Position(.e, .eight), destination: Position(.f, .eight), capturedPiece: nil),
                        Move(origin: Position(.e, .eight), destination: Position(.d, .eight), capturedPiece: nil),
                        Move(origin: Position(.e, .eight), destination: Position(.f, .seven), capturedPiece: nil),
                        Move(origin: Position(.e, .eight), destination: Position(.d, .seven), capturedPiece: nil),
                        Move(origin: Position(.e, .eight), destination: Position(.g, .eight), capturedPiece: nil, kind: .castle),
                    ]
                    
                    expect(self.moves) == Set(expectedMoves)
                }
            }
        }
    }
}
