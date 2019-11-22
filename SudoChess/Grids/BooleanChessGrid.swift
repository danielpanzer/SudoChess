//
//  BooleanGrid.swift
//  SudoChess
//
//  Created by Daniel Panzer on 9/17/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

public let O = BooleanChessGrid.O
public let X = BooleanChessGrid.X

public typealias BooleanChessGrid = ChessGrid<Bool>

extension BooleanChessGrid {
    
    static let O = true
    static let X = false
    
    static let `false` = BooleanChessGrid(array: Array(repeating: false, count: 64))
    static let `true` = BooleanChessGrid(array: Array(repeating: true, count: 64))
    
    public init() {
        self = BooleanChessGrid(array: Array(repeating: false, count: 64))
    }
    
    init(positions: [Position]) {
        self = BooleanChessGrid()
        for position in positions {
            self[position] = true
        }
    }
    
    func toMoves(from origin: Position, in board: Board) -> Set<Move> {
        assert(self[origin] == false, "we shouldn't be creating moves where the origin and destination are the same")
        return zip(self.indices, self)
            .compactMap { destination, canMove in
                guard canMove else {return nil}
                return Move(origin: origin, destination: destination, capturedPiece: board[destination])
        }
        .toSet()
    }
}

extension BooleanChessGrid : SetAlgebra {
    
    public var isEmpty: Bool {
        return self == BooleanChessGrid.false
    }
    
    public func union(_ other: BooleanChessGrid) -> BooleanChessGrid {
        let newArray = zip(self, other).map{$0 || $1}
        return BooleanChessGrid(array: newArray)
    }
    
    public func intersection(_ other: BooleanChessGrid) -> BooleanChessGrid {
        let newArray = zip(self, other).map{$0 && $1}
        return BooleanChessGrid(array: newArray)
    }
    
    public func symmetricDifference(_ other: BooleanChessGrid) -> BooleanChessGrid {
        let newArray = zip(self, other)
            .map {(Int(truncating: NSNumber(value: $0)) ^ Int(truncating: NSNumber(value: $1))) == 1}
        return BooleanChessGrid(array: newArray)
    }
    
    public mutating func insert(_ newMember: Bool) -> (inserted: Bool, memberAfterInsert: Bool) {
        return (false, false)
    }
    
    public mutating func remove(_ member: Bool) -> Bool? {
        return nil
    }
    
    public mutating func update(with newMember: Bool) -> Bool? {
        return nil
    }
    
    public mutating func formUnion(_ other: BooleanChessGrid) {
        let newArray = zip(self, other).map{$0 || $1}
        self = BooleanChessGrid(array: newArray)
    }
    
    public mutating func formIntersection(_ other: BooleanChessGrid) {
        let newArray = zip(self, other).map{$0 && $1}
        self = BooleanChessGrid(array: newArray)
    }
    
    public mutating func formSymmetricDifference(_ other: BooleanChessGrid) {
        let newArray = zip(self, other)
        .map {(Int(truncating: NSNumber(value: $0)) ^ Int(truncating: NSNumber(value: $1))) == 1}
        self = BooleanChessGrid(array: newArray)
    }
    
    
}

