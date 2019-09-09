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
    
    init?(gridIndex: IndexPath) {
        
        guard gridIndex != IndexPath(row: 8, column: 0) else {
            self = Position(.a, .end)
            return
        }
        
        guard
            let row = Row(rawValue: 8 - gridIndex.row),
            let rank = Rank(rawValue: gridIndex.column + 1)
            else {return nil}
        
        self.rank = rank
        self.row = row
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
