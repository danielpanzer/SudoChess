//
//  CheckHandlerPerformanceSpec.swift
//  SudoChessTests
//
//  Created by Daniel Panzer on 11/15/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import XCTest

@testable import SudoChess

class CheckHandlerPerformanceSpec: XCTestCase {

    private var subject: CheckHandler!
    private var summary: CheckHandler.State!
    private var moves: Set<Move>!
    
    override func setUp() {
        self.subject = CheckHandler()
    }

    override func tearDown() {
        self.subject = nil
        self.summary = nil
        self.moves = nil
    }

    func test_CheckHandler_validMovesForStandardGame_performance() {
        
        let game = Game
            .standard
        
        let allMoves = game
            .allMoves(for: .white)
        
        self.measure {
            self.moves = self.subject.validMoves(from: allMoves, in: game)
        }
    }
    
    func test_CheckHandler_checkSummaryForStandardGame_performance() {
        
        let game = Game
            .standard
        
        self.measure {
            self.summary = self.subject.state(for: .white, in: game)
        }
    }
}
