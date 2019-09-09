//
//  BooleanChessGridSpec.swift
//  SudoChessFoundationTests
//
//  Created by Daniel Panzer on 10/14/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import SudoChess

class BooleanChessGridSpec: QuickSpec {
    
    private var subject: BooleanChessGrid!
    
    override func spec() {
        
        describe("A boolean chess grid created from the union of two grids") {
            
            beforeEach {
                let grid1 = BooleanChessGrid(array: [
                O, O, O, O, O, O, O, O,
                X, X, O, O, X, X, X, O,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                O, X, X, X, X, X, X, X,
                ])
                
                let grid2 = BooleanChessGrid(array: [
                O, O, O, X, X, X, X, X,
                X, X, X, X, X, X, X, O,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, O, O, O, X,
                X, X, X, X, X, X, X, X,
                O, X, X, X, X, X, X, X,
                ])
                
                self.subject = grid1.union(grid2)
            }
            
            afterEach {
                self.subject = nil
            }
            
            it("contains the expected content") {
                let expectedGrid = BooleanChessGrid(array: [
                O, O, O, O, O, O, O, O,
                X, X, O, O, X, X, X, O,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, X, X, X, X,
                X, X, X, X, O, O, O, X,
                X, X, X, X, X, X, X, X,
                O, X, X, X, X, X, X, X,
                ])
                
                expect(self.subject) == expectedGrid
            }
        }
    }
}
