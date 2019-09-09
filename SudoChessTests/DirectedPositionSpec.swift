//
//  DirectedPositionSpec.swift
//  SudoChessFoundationTests
//
//  Created by Daniel Panzer on 9/9/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import SudoChess

class DirectedPositionSpec: QuickSpec {

    private var subject: DirectedPosition!
    
    override func spec() {
        
        describe("Position a1 from white's perspective") {
            
            beforeEach {
                self.subject = DirectedPosition(position: Position(.a, .one), perspective: .white)
            }
            
            afterEach {
                self.subject = nil
            }
            
            it("reports a2 as its front") {
                expect(self.subject.front?.position) == Position(.a, .two)
            }
            
            it("reports no back") {
                expect(self.subject.back?.position).to(beNil())
            }
            
            it("reports no left") {
                expect(self.subject.left?.position).to(beNil())
            }
            
            it("reports b1 as its right") {
                expect(self.subject.right?.position) == Position(.b, .one)
            }
            
            it("reports no left front diagonal") {
                expect(self.subject.diagonalLeftFront?.position).to(beNil())
            }
            
            it("reports b2 as its right front diagonal") {
                expect(self.subject.diagonalRightFront?.position) == Position(.b, .two)
            }
            
            it("reports no left back diagonal") {
                expect(self.subject.diagonalLeftBack?.position).to(beNil())
            }
            
            it("reports no right back diagonal") {
                expect(self.subject.diagonalRightBack?.position).to(beNil())
            }
            
            it("reports a2 - a8 as its front spaces") {
                let expectedResult = [
                    Position(.a, .two),
                    Position(.a, .three),
                    Position(.a, .four),
                    Position(.a, .five),
                    Position(.a, .six),
                    Position(.a, .seven),
                    Position(.a, .eight),
                ]
                expect(self.subject.frontSpaces.map({$0.position})) == expectedResult
            }
            
            it("reports no back spaces") {
                expect(self.subject.backSpaces).to(beEmpty())
            }
            
            it("reports no left spaces") {
                expect(self.subject.leftSpaces).to(beEmpty())
            }
            
            it("reports b1 - h1 as its right spaces") {
                let expectedResult = [
                    Position(.b, .one),
                    Position(.c, .one),
                    Position(.d, .one),
                    Position(.e, .one),
                    Position(.f, .one),
                    Position(.g, .one),
                    Position(.h, .one),
                ]
                expect(self.subject.rightSpaces.map({$0.position})) == expectedResult
            }
        }
        
        describe("Position a1 from black's perspective") {
            
            beforeEach {
                self.subject = DirectedPosition(position: Position(.a, .one), perspective: .black)
            }
            
            afterEach {
                self.subject = nil
            }
            
            it("reports no front") {
                expect(self.subject.front?.position).to(beNil())
            }
            
            it("reports a2 as its back") {
                expect(self.subject.back?.position) == Position(.a, .two)
            }
            
            it("reports b1 as its left") {
                expect(self.subject.left?.position) == Position(.b, .one)
            }
            
            it("reports no right") {
                expect(self.subject.right?.position).to(beNil())
            }
            
            it("reports no left front diagonal") {
                expect(self.subject.diagonalLeftFront?.position).to(beNil())
            }
            
            it("reports no right front diagonal") {
                expect(self.subject.diagonalRightFront?.position).to(beNil())
            }
            
            it("reports b2 as its left back diagonal") {
                expect(self.subject.diagonalLeftBack?.position) == Position(.b, .two)
            }
            
            it("reports no right back diagonal") {
                expect(self.subject.diagonalRightBack?.position).to(beNil())
            }
        }
        
        describe("Position d5 from white's perspective") {
            
            beforeEach {
                self.subject = DirectedPosition(position: Position(.d, .five), perspective: .white)
            }
            
            afterEach {
                self.subject = nil
            }
            
            it("reports d6 as its front") {
                expect(self.subject.front?.position) == Position(.d, .six)
            }
            
            it("reports d4 as its back") {
                expect(self.subject.back?.position) == Position(.d, .four)
            }
            
            it("reports c5 as its left") {
                expect(self.subject.left?.position) == Position(.c, .five)
            }
            
            it("reports e5 as its right") {
                expect(self.subject.right?.position) == Position(.e, .five)
            }
            
            it("reports c6 left front diagonal") {
                expect(self.subject.diagonalLeftFront?.position) == Position(.c, .six)
            }
            
            it("reports e6 as its right front diagonal") {
                expect(self.subject.diagonalRightFront?.position) == Position(.e, .six)
            }
            
            it("reports c4 as its left back diagonal") {
                expect(self.subject.diagonalLeftBack?.position) == Position(.c, .four)
            }
            
            it("reports e4 as its right back diagonal") {
                expect(self.subject.diagonalRightBack?.position) == Position(.e, .four)
            }
        }
        
        describe("Position d5 from black's perspective") {
            
            beforeEach {
                self.subject = DirectedPosition(position: Position(.d, .five), perspective: .black)
            }
            
            afterEach {
                self.subject = nil
            }
            
            it("reports d4 as its front") {
                expect(self.subject.front?.position) == Position(.d, .four)
            }
            
            it("reports d6 as its back") {
                expect(self.subject.back?.position) == Position(.d, .six)
            }
            
            it("reports e5 as its left") {
                expect(self.subject.left?.position) == Position(.e, .five)
            }
            
            it("reports c5 as its right") {
                expect(self.subject.right?.position) == Position(.c, .five)
            }
            
            it("reports e4 left front diagonal") {
                expect(self.subject.diagonalLeftFront?.position) == Position(.e, .four)
            }
            
            it("reports c4 as its right front diagonal") {
                expect(self.subject.diagonalRightFront?.position) == Position(.c, .four)
            }
            
            it("reports e6 as its left back diagonal") {
                expect(self.subject.diagonalLeftBack?.position) == Position(.e, .six)
            }
            
            it("reports c6 as its right back diagonal") {
                expect(self.subject.diagonalRightBack?.position) == Position(.c, .six)
            }
        }
        
        describe("Position f8 from white's perspective") {
            
            beforeEach {
                self.subject = DirectedPosition(position: Position(.f, .eight), perspective: .white)
            }
            
            afterEach {
                self.subject = nil
            }
            
            it("reports no front") {
                expect(self.subject.front?.position).to(beNil())
            }
            
            it("reports f7 as its back") {
                expect(self.subject.back?.position) == Position(.f, .seven)
            }
            
            it("reports e8 as its left") {
                expect(self.subject.left?.position) == Position(.e, .eight)
            }
            
            it("reports g8 as its right") {
                expect(self.subject.right?.position) == Position(.g, .eight)
            }
            
            it("reports no left front diagonal") {
                expect(self.subject.diagonalLeftFront?.position).to(beNil())
            }
            
            it("reports no right front diagonal") {
                expect(self.subject.diagonalRightFront?.position).to(beNil())
            }
            
            it("reports e7 as its left back diagonal") {
                expect(self.subject.diagonalLeftBack?.position) == Position(.e, .seven)
            }
            
            it("reports g7 as its right back diagonal") {
                expect(self.subject.diagonalRightBack?.position) == Position(.g, .seven)
            }
        }
    }
}
