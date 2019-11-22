//
//  SudoChessFoundationTests.swift
//  SudoChessFoundationTests
//
//  Created by Daniel Panzer on 9/9/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import SudoChess

class PositionSpec: QuickSpec {

    private var subject: Position!
    private var indexPath: IndexPath!
    private var positionPath: [Position]!
    
    override func spec() {
        
        describe("The upper left chess position") {
            
            beforeEach {
                self.subject = Position(.a, .eight)
            }
            
            afterEach {
                self.subject = nil
            }
            
            it("translates to the correct grid index") {
                let expectedResult = IndexPath(row: 0, column: 0)
                expect(self.subject.gridIndex).to(equal(expectedResult))
            }
        }
        
        describe("The lower left chess position") {
            
            beforeEach {
                self.subject = Position(.a, .one)
            }
            
            afterEach {
                self.subject = nil
            }
            
            it("translates to the correct grid index") {
                let expectedResult = IndexPath(row: 7, column: 0)
                expect(self.subject.gridIndex).to(equal(expectedResult))
            }
        }
        
        describe("The upper right chess position") {
            
            beforeEach {
                self.subject = Position(.h, .eight)
            }
            
            afterEach {
                self.subject = nil
            }
            
            it("translates to the correct grid index") {
                let expectedResult = IndexPath(row: 0, column: 7)
                expect(self.subject.gridIndex).to(equal(expectedResult))
            }
        }
        
        describe("The lower right chess position") {
            
            beforeEach {
                self.subject = Position(.h, .one)
            }
            
            afterEach {
                self.subject = nil
            }
            
            it("translates to the correct grid index") {
                let expectedResult = IndexPath(row: 7, column: 7)
                expect(self.subject.gridIndex).to(equal(expectedResult))
            }
        }
        
        describe("A mid board chess position") {
            
            beforeEach {
                self.subject = Position(.c, .three)
            }
            
            afterEach {
                self.subject = nil
            }
            
            it("translates to the correct grid index") {
                let expectedResult = IndexPath(row: 5, column: 2)
                expect(self.subject.gridIndex).to(equal(expectedResult))
            }
        }
        
        describe("The upper left grid IndexPath") {
            
            beforeEach {
                self.indexPath = IndexPath(row: 0, column: 0)
            }
            
            afterEach {
                self.indexPath = nil
            }
            
            it("converts to the correct chess position") {
                let expectedResult = Position(.a, .eight)
                let conversion = Position(gridIndex: self.indexPath)
                expect(conversion) == expectedResult
            }
        }
        
        describe("The lower right grid IndexPath") {
            
            beforeEach {
                self.indexPath = IndexPath(row: 7, column: 7)
            }
            
            afterEach {
                self.indexPath = nil
            }
            
            it("converts to the correct chess position") {
                let expectedResult = Position(.h, .one)
                let conversion = Position(gridIndex: self.indexPath)
                expect(conversion) == expectedResult
            }
        }
        
        describe("A mid board grid IndexPath") {
            
            beforeEach {
                self.indexPath = IndexPath(row: 3, column: 5)
            }
            
            afterEach {
                self.indexPath = nil
            }
            
            it("converts to the correct chess position") {
                let expectedResult = Position(.f, .five)
                let conversion = Position(gridIndex: self.indexPath)
                expect(conversion) == expectedResult
            }
        }
        
        describe("An IndexPath that is out of bounds for a chess grid") {
            
            beforeEach {
                self.indexPath = IndexPath(row: 10, column: 0)
            }
            
            afterEach {
                self.indexPath = nil
            }
            
            it("converts to a null chess position") {
                let conversion = Position(gridIndex: self.indexPath)
                expect(conversion).to(beNil())
            }
        }
        
        describe("A straight line of positions") {
            
            beforeEach {
                self.positionPath = [
                    Position(.a, .one),
                    Position(.a, .two),
                    Position(.a, .three)
                ]
            }
            
            afterEach {
                self.positionPath = nil
            }
            
            it("is a valid path") {
                expect(Position.isValidPath(self.positionPath)) == true
            }
        }
        
        describe("A diagonal line of positions") {
            
            beforeEach {
                self.positionPath = [
                    Position(.a, .one),
                    Position(.b, .two),
                    Position(.c, .three)
                ]
            }
            
            afterEach {
                self.positionPath = nil
            }
            
            it("is a valid path") {
                expect(Position.isValidPath(self.positionPath)) == true
            }
        }
        
        describe("A disjoined line of positions") {
            
            beforeEach {
                self.positionPath = [
                    Position(.a, .one),
                    Position(.a, .three),
                    Position(.a, .four)
                ]
            }
            
            afterEach {
                self.positionPath = nil
            }
            
            it("is not a valid path") {
                expect(Position.isValidPath(self.positionPath)) == false
            }
        }
    }
}
