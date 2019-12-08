//
//  ChessPosition.swift
//  SudoChess
//
//  Created by Daniel Panzer on 9/2/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

/// Describes a single position on a chessboard
public struct Position : Equatable {
    
    public init(_ rank: Rank, _ row: Row) {
        self.rank = rank
        self.row = row
    }
    
    init(gridIndex: IndexPath) {
        self.row = Row(rawValue: 8 - gridIndex.row - (gridIndex.row / 8))!
        self.rank = Rank(rawValue: gridIndex.column + 1)!
    }
    
    /// A chess rank, moving from left to right
    public enum Rank : Int {
        case a = 1
        case b
        case c
        case d
        case e
        case f
        case g
        case h
    }
    
    /// A chess row, moving from bottom to top
    public enum Row : Int {
        
        case end = -1
        
        case one = 1
        case two = 2
        case three = 3
        case four = 4
        case five = 5
        case six = 6
        case seven = 7
        case eight = 8
    }
    
    /// The rank of the position
    public let rank: Rank
    
    
    /// The row of the position
    public let row: Row
    
    var gridIndex: IndexPath {
        let convertedRow = abs(row.rawValue - 8)
        let convertedRank = rank.rawValue - 1
        return IndexPath(row: convertedRow, column: convertedRank)
    }
    
    /// Generates a directed position, exposing further position logic
    /// - Parameter team: The team perspective from which to create the directed position
    public func fromPerspective(of team: Team) -> DirectedPosition {
        return DirectedPosition(position: self, perspective: team)
    }
    
    /// - Returns: True if the position is directly adjacent (on sides or corners) to the passed position; false if not
    /// - Parameter otherPosition: The position to compare
    public func isAdjacent(to otherPosition: Position) -> Bool {
        let directedPosition = DirectedPosition(position: self, perspective: .white)
        let adjacentPositions = [
            directedPosition.front,
            directedPosition.back,
            directedPosition.left,
            directedPosition.right,
            directedPosition.diagonalLeftFront,
            directedPosition.diagonalRightFront,
            directedPosition.diagonalRightBack,
            directedPosition.diagonalLeftBack
        ].compactMap({$0?.position})
        
        return adjacentPositions.contains(otherPosition)
    }
    
    static func pathConsideringCollisions(
        for team: Team,
        traversing path: [Position],
        in board: Board
        ) -> [Position] {
        
        assert(Position.isValidPath(path))
        
        var result = [Position]()
        
        for position in path {
            
            switch board[position] {
            case .none:
                result.append(position)
                continue
            case .some(let collidingPiece):
                
                if collidingPiece.owner == team.opponent {
                    result.append(position)
                }
                
                return result
            }
        }
        
        return result
    }
    
    static func isValidPath(_ array: [Position]) -> Bool {
        
        guard array.count > 0 else {return true}
        
        var iterator = array.makeIterator()
        var currentElement: Position = iterator.next()!
        
        while let nextElement = iterator.next() {
            guard currentElement.isAdjacent(to: nextElement) else {return false}
            currentElement = nextElement
        }
        
        return true
    }
    
    ///For extra efficiency during iteration
    static let positions: [Int : Position] = [
        0 : Position(.a, .eight),
        1 : Position(.b, .eight),
        2 : Position(.c, .eight),
        3 : Position(.d, .eight),
        4 : Position(.e, .eight),
        5 : Position(.f, .eight),
        6 : Position(.g, .eight),
        7 : Position(.h, .eight),
        8 : Position(.a, .seven),
        9 : Position(.b, .seven),
        10 : Position(.c, .seven),
        11 : Position(.d, .seven),
        12 : Position(.e, .seven),
        13 : Position(.f, .seven),
        14 : Position(.g, .seven),
        15 : Position(.h, .seven),
        16 : Position(.a, .six),
        17 : Position(.b, .six),
        18 : Position(.c, .six),
        19 : Position(.d, .six),
        20 : Position(.e, .six),
        21 : Position(.f, .six),
        22 : Position(.g, .six),
        23 : Position(.h, .six),
        24 : Position(.a, .five),
        25 : Position(.b, .five),
        26 : Position(.c, .five),
        27 : Position(.d, .five),
        28 : Position(.e, .five),
        29 : Position(.f, .five),
        30 : Position(.g, .five),
        31 : Position(.h, .five),
        32 : Position(.a, .four),
        33 : Position(.b, .four),
        34 : Position(.c, .four),
        35 : Position(.d, .four),
        36 : Position(.e, .four),
        37 : Position(.f, .four),
        38 : Position(.g, .four),
        39 : Position(.h, .four),
        40 : Position(.a, .three),
        41 : Position(.b, .three),
        42 : Position(.c, .three),
        43 : Position(.d, .three),
        44 : Position(.e, .three),
        45 : Position(.f, .three),
        46 : Position(.g, .three),
        47 : Position(.h, .three),
        48 : Position(.a, .two),
        49 : Position(.b, .two),
        50 : Position(.c, .two),
        51 : Position(.d, .two),
        52 : Position(.e, .two),
        53 : Position(.f, .two),
        54 : Position(.g, .two),
        55 : Position(.h, .two),
        56 : Position(.a, .one),
        57 : Position(.b, .one),
        58 : Position(.c, .one),
        59 : Position(.d, .one),
        60 : Position(.e, .one),
        61 : Position(.f, .one),
        62 : Position(.g, .one),
        63 : Position(.h, .one),
        
        64 : Position(.a, .end)
    ]
    
    static let indices: [Position : Int] = [
        Position(.a, .eight) : 0,
        Position(.b, .eight) : 1,
        Position(.c, .eight) : 2,
        Position(.d, .eight) : 3,
        Position(.e, .eight) : 4,
        Position(.f, .eight) : 5,
        Position(.g, .eight) : 6,
        Position(.h, .eight) : 7,
        Position(.a, .seven) : 8,
        Position(.b, .seven) : 9,
        Position(.c, .seven) : 10,
        Position(.d, .seven) : 11,
        Position(.e, .seven) : 12,
        Position(.f, .seven) : 13,
        Position(.g, .seven) : 14,
        Position(.h, .seven) : 15,
        Position(.a, .six) : 16,
        Position(.b, .six) : 17,
        Position(.c, .six) : 18,
        Position(.d, .six) : 19,
        Position(.e, .six) : 20,
        Position(.f, .six) : 21,
        Position(.g, .six) : 22,
        Position(.h, .six) : 23,
        Position(.a, .five) : 24,
        Position(.b, .five) : 25,
        Position(.c, .five) : 26,
        Position(.d, .five) : 27,
        Position(.e, .five) : 28,
        Position(.f, .five) : 29,
        Position(.g, .five) : 30,
        Position(.h, .five) : 31,
        Position(.a, .four) : 32,
        Position(.b, .four) : 33,
        Position(.c, .four) : 34,
        Position(.d, .four) : 35,
        Position(.e, .four) : 36,
        Position(.f, .four) : 37,
        Position(.g, .four) : 38,
        Position(.h, .four) : 39,
        Position(.a, .three) : 40,
        Position(.b, .three) : 41,
        Position(.c, .three) : 42,
        Position(.d, .three) : 43,
        Position(.e, .three) : 44,
        Position(.f, .three) : 45,
        Position(.g, .three) : 46,
        Position(.h, .three) : 47,
        Position(.a, .two) : 48,
        Position(.b, .two) : 49,
        Position(.c, .two) : 50,
        Position(.d, .two) : 51,
        Position(.e, .two) : 52,
        Position(.f, .two) : 53,
        Position(.g, .two) : 54,
        Position(.h, .two) : 55,
        Position(.a, .one) : 56,
        Position(.b, .one) : 57,
        Position(.c, .one) : 58,
        Position(.d, .one) : 59,
        Position(.e, .one) : 60,
        Position(.f, .one) : 61,
        Position(.g, .one) : 62,
        Position(.h, .one) : 63,
        
        Position(.a, .end) : 64
    ]
}

extension Position : Comparable {
    
    public static func < (lhs: Position, rhs: Position) -> Bool {
        return lhs.gridIndex < rhs.gridIndex
    }
}

extension Position : Hashable {}

extension Position : CustomStringConvertible {
    
    public var description: String {
        "\(rank)-\(row.rawValue)"
    }
}
