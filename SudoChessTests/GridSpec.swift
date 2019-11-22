//
//  GridSpec.swift
//  SudoChessFoundationTests
//
//  Created by Daniel Panzer on 9/9/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import SudoChess

class GridSpec: QuickSpec {

    private var nullableSubject: Grid<Int?>!
    private var nonnullSubject: Grid<Int>!
    
    override func spec() {
        
        describe("an empty 3x3 nullable integer grid") {
            
            beforeEach {
                self.nullableSubject = Grid(rowSize: 3, columnSize: 3)
            }
            
            afterEach {
                self.nullableSubject = nil
            }
            
            it("reports nil for index 0,0") {
                expect(self.nullableSubject[0,0]).to(beNil())
            }
            
            it("reports nil for index 1,1") {
                expect(self.nullableSubject[1,1]).to(beNil())
            }
            
            it("reports an empty array when compactMapped") {
                expect(self.nullableSubject.compactMap({$0}).isEmpty) == true
            }
            
            context("when setting index 1,1 to 5") {
                
                beforeEach {
                    self.nullableSubject[1,1] = 5
                }
                
                it("continues to report nil for index 0,0") {
                    expect(self.nullableSubject[0,0]).to(beNil())
                }
                
                it("reports 5 for index 1,1") {
                    expect(self.nullableSubject[1,1]) == 5
                }
                
                it("reports an array with one element 5 when compactMapped") {
                    expect(self.nullableSubject.compactMap({$0})) == [5]
                }
            }
            
            context("when setting index 0,0 to 2 and index 0,1 to 4") {
                
                beforeEach {
                    self.nullableSubject[0,0] = 2
                    self.nullableSubject[0,1] = 4
                }
                
                it("continues to report nil for index 1,1") {
                    expect(self.nullableSubject[1,1]).to(beNil())
                }
                
                it("reports 2 for index 0,0") {
                    expect(self.nullableSubject[0,0]) == 2
                }
                
                it("reports 4 for index 0,1") {
                    expect(self.nullableSubject[0,1]) == 4
                }
                
                it("reports an array of [2,4] when compactMapped") {
                    expect(self.nullableSubject.compactMap({$0})) == [2, 4]
                }
                
                it("reports the expected array when mapped") {
                    let expectedArray: [Int?] = [2, 4, nil, nil, nil, nil, nil, nil, nil]
                    expect(self.nullableSubject.map({$0})) == expectedArray
                }
            }
            
            context("when setting index 0,0 to 3 and index 2,2 to 6") {
                
                beforeEach {
                    self.nullableSubject[0,0] = 3
                    self.nullableSubject[2,2] = 6
                }
                
                it("continues to report nil for index 1,1") {
                    expect(self.nullableSubject[1,1]).to(beNil())
                }
                
                it("reports 3 for index 0,0") {
                    expect(self.nullableSubject[0,0]) == 3
                }
                
                it("reports 6 for index 2,2") {
                    expect(self.nullableSubject[2,2]) == 6
                }
                
                it("reports an array of [3,6] when compactMapped") {
                    expect(self.nullableSubject.compactMap({$0})) == [3, 6]
                }
                
                it("reports the expected array when mapped") {
                    let expectedArray: [Int?] = [3, nil, nil, nil, nil, nil, nil, nil, 6]
                    expect(self.nullableSubject.map({$0})) == expectedArray
                }
            }
        }
        
        describe("A 3x3 nullable integer grid initialized with an array") {
            
            let array = [nil, 2, 3, 4, 5, 6, 7, 8, 9]
            
            beforeEach {
                self.nullableSubject = Grid<Int?>(rowSize: 3, columnSize: 3, using: array)
            }
            
            afterEach {
                self.nullableSubject = nil
            }
            
            it("reports the expected value for 0,0") {
                expect(self.nullableSubject[0,0]).to(beNil())
            }
            
            it("reports the expected value for 0,1") {
                expect(self.nullableSubject[0,1]) == 2
            }
            
            it("reports the expected value for 1,0") {
                expect(self.nullableSubject[1,0]) == 4
            }
            
            it("reports the expected value for 2,2") {
                expect(self.nullableSubject[2,2]) == 9
            }
            
            it("reports the original array when mapped") {
                expect(self.nullableSubject.map({$0})) == array
            }
            
            it("reports the expected last element") {
                expect(self.nullableSubject.last) == 9
            }
            
            it("reports the correct reverse map") {
                expect(self.nullableSubject.reversed()) == array.reversed()
            }
        }
        
        describe("A 3x3 nonnull integer grid initialized with an array") {
            
            beforeEach {
                self.nonnullSubject = Grid<Int>(rowSize: 3, columnSize: 3, using: [1, 2, 3, 4, 5, 6, 7, 8, 9])
            }
            
            afterEach {
                self.nonnullSubject = nil
            }
            
            it("reports the expected value for 0,0") {
                expect(self.nonnullSubject[0,0]) == 1
            }
            
            it("reports the expected value for 0,1") {
                expect(self.nonnullSubject[0,1]) == 2
            }
            
            it("reports the expected value for 1,0") {
                expect(self.nonnullSubject[1,0]) == 4
            }
            
            it("reports the expected value for 2,2") {
                expect(self.nonnullSubject[2,2]) == 9
            }
            
            it("reports the original array when mapped") {
                let expectedArray: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9]
                expect(self.nonnullSubject.map({$0})) == expectedArray
            }
        }
    }
}
