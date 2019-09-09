//
//  CheckHandlerSpec.swift
//  SudoChessFoundationTests
//
//  Created by Daniel Panzer on 10/14/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import SudoChess

class CheckHandlerSpec: QuickSpec {
    
    private static let blackNoValidMoveScenario: Board = {
        
        let rook1 = Rook(owner: .white)
        let rook2 = Rook(owner: .white)
        
        let pieces: [Piece?] = [
            King(owner: .black), nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, rook1,
            nil, rook2, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, King(owner: .white), nil, nil, nil, nil
        ]
        
        return ChessGrid(array: pieces)
    }()
    
    private static let blackInCheckAndNoValidMoveScenario: Board = {
        
        let rook1 = Rook(owner: .white)
        let rook2 = Rook(owner: .white)
        let bishop = Bishop(owner: .white)
        
        let pieces: [Piece?] = [
            King(owner: .black), nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, rook1,
            nil, rook2, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, bishop, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, King(owner: .white), nil, nil, nil, nil
        ]
        
        return ChessGrid(array: pieces)
    }()
    
    private static let blackInCheckScenario: Board = {
        
        let king1 = King(owner: .black)
        let rook1 = Rook(owner: .white)
        let rook2 = Rook(owner: .white)
        let king2 = King(owner: .white)
        
        let pieces: [Piece?] = [
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, king1, nil, nil, nil, nil, nil, rook1,
            nil, rook2, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, king2, nil, nil, nil, nil
        ]
        
        return ChessGrid(array: pieces)
    }()
    
    private var subject: CheckHandler!
    private var scenario: Game!
    
    override func spec() {
        
        describe("A CheckHandler") {
            
            beforeEach {
                self.subject = CheckHandler()
            }
            
            afterEach {
                self.subject = nil
            }
            
            context("when presented with the standard starting scenario") {
                
                beforeEach {
                    self.scenario = Game.standard
                }
                
                afterEach {
                    self.scenario = nil
                }
                
                it("does not report white is in check or checkmate") {
                    expect(self.subject.state(for: .white, in: self.scenario)) == CheckHandler.State.none
                }
                
                it("does not report black is in check or checkmate") {
                    expect(self.subject.state(for: .black, in: self.scenario)) == CheckHandler.State.none
                }
            }
            
            context("when presented with a scenario where black is in check and it is black's move") {
                
                beforeEach {
                    self.scenario = Game(board: CheckHandlerSpec.blackInCheckScenario, turn: .black)
                }
                
                afterEach {
                    self.scenario = nil
                }
                
                it("does not report white is in check or checkmate") {
                    expect(self.subject.state(for: .white, in: self.scenario)) == CheckHandler.State.none
                }
                
                it("reports black is in check") {
                    expect(self.subject.state(for: .black, in: self.scenario)) == CheckHandler.State.check
                }
            }
            
            context("when presented with a scenario where black has no valid moves and it is black's move") {
                
                beforeEach {
                    self.scenario = Game(board: CheckHandlerSpec.blackNoValidMoveScenario, turn: .black)
                }
                
                afterEach {
                    self.scenario = nil
                }
                
                it("does not report white is in check or checkmate") {
                    expect(self.subject.state(for: .white, in: self.scenario)) == CheckHandler.State.none
                }
                
                it("reports black is in checkmate") {
                    expect(self.subject.state(for: .black, in: self.scenario)) == CheckHandler.State.checkmate
                }
            }
            
            context("when presented with a scenario where black has no valid moves and it is white's move") {
                
                beforeEach {
                    self.scenario = Game(board: CheckHandlerSpec.blackNoValidMoveScenario, turn: .white)
                }
                
                afterEach {
                    self.scenario = nil
                }
                
                it("does not report white is in check or checkmate") {
                    expect(self.subject.state(for: .white, in: self.scenario)) == CheckHandler.State.none
                }
                
                it("does not report black is in check or checkmate") {
                    expect(self.subject.state(for: .black, in: self.scenario)) == CheckHandler.State.none
                }
            }
        }
    }
}
