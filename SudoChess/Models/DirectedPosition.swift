//
//  DirectedPosition.swift
//  SudoChess
//
//  Created by Daniel Panzer on 9/9/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

/// A chess position from the perspective of a particular team
public struct DirectedPosition {
    
    public let position: Position
    public let perspective: Team
    
    /// - Returns: A new directed position that represents the position in front of this position, from the same perspective, or nil if no such position exists on the board
    public var front: DirectedPosition? {
        
        guard let newRow = Position.Row(
            rawValue: perspective == .white ? position.row.rawValue + 1 : position.row.rawValue - 1
            ) else {
                return nil
        }
        
        let newPosition = Position(position.rank, newRow)
        return DirectedPosition(position: newPosition, perspective: perspective)
    }
    
    /// - Returns: A new directed position that represents the position in back of this position, from the same perspective, or nil if no such position exists on the board
    public var back: DirectedPosition? {
        
        guard let newRow = Position.Row(
            rawValue: perspective == .white ? position.row.rawValue - 1 : position.row.rawValue + 1
            ) else {
                return nil
        }
        
        let newPosition = Position(position.rank, newRow)
        return DirectedPosition(position: newPosition, perspective: perspective)
    }
    
    /// - Returns: A new directed position that represents the position to the left of this position, from the same perspective, or nil if no such position exists on the board
    public var left: DirectedPosition? {
        
        guard let newRank = Position.Rank(
            rawValue: perspective == .white ? position.rank.rawValue - 1 : position.rank.rawValue + 1
            ) else {
                return nil
        }
        
        let newPosition = Position(newRank, position.row)
        return DirectedPosition(position: newPosition, perspective: perspective)
    }
    
    /// - Returns: A new directed position that represents the position to the right of this position, from the same perspective, or nil if no such position exists on the board
    public var right: DirectedPosition? {
        
        guard let newRank = Position.Rank(
            rawValue: perspective == .white ? position.rank.rawValue + 1 : position.rank.rawValue - 1
            ) else {
                return nil
        }
        
        let newPosition = Position(newRank, position.row)
        return DirectedPosition(position: newPosition, perspective: perspective)
    }
    
    /// - Returns: A new directed position that represents the position to the front left corner of this position, from the same perspective, or nil if no such position exists on the board
    public var diagonalLeftFront: DirectedPosition? {
        return self
            .front?
            .left
    }
    
    /// - Returns: A new directed position that represents the position to the front right corner of this position, from the same perspective, or nil if no such position exists on the board
    public var diagonalRightFront: DirectedPosition? {
        return self
            .front?
            .right
    }
    
    /// - Returns: A new directed position that represents the position to the rear left corner of this position, from the same perspective, or nil if no such position exists on the board
    public var diagonalLeftBack: DirectedPosition? {
        return self
            .back?
            .left
    }
    
    /// - Returns: A new directed position that represents the position to the rear right corner of this position, from the same perspective, or nil if no such position exists on the board
    public var diagonalRightBack: DirectedPosition? {
        return self
            .back?
            .right
    }
    
    /// - Returns: All available positions in a line in front of this position, all from the same perspective
    public var frontSpaces: [DirectedPosition] {
        return allSpaces(using: { position in position.front })
    }
    
    /// - Returns: All available positions in a line in back of this position, all from the same perspective
    public var backSpaces: [DirectedPosition] {
        return allSpaces(using: { position in position.back })
    }
    
    /// - Returns: All available positions in a line to the left of this position, all from the same perspective
    public var leftSpaces: [DirectedPosition] {
        return allSpaces(using: { position in position.left })
    }
    
    /// - Returns: All available positions in a line to the right of this position, all from the same perspective
    public var rightSpaces: [DirectedPosition] {
        return allSpaces(using: { position in position.right })
    }
    
    /// - Returns: All available positions in a line on a left front diagonal from this position, all from the same perspective
    public var diagonalLeftFrontSpaces: [DirectedPosition] {
        return allSpaces(using: { position in position.diagonalLeftFront })
    }
    
    /// - Returns: All available positions in a line on a right front diagonal from this position, all from the same perspective
    public var diagonalRightFrontSpaces: [DirectedPosition] {
        return allSpaces(using: { position in position.diagonalRightFront })
    }
    
    /// - Returns: All available positions in a line on a left rear diagonal from this position, all from the same perspective
    public var diagonalLeftBackSpaces: [DirectedPosition] {
        return allSpaces(using: { position in position.diagonalLeftBack })
    }
    
    /// - Returns: All available positions in a line on a right rear diagonal from this position, all from the same perspective
    public var diagonalRightBackSpaces: [DirectedPosition] {
        return allSpaces(using: { position in position.diagonalRightBack })
    }
    
    private func allSpaces(using calculateNextPosition: (DirectedPosition) -> DirectedPosition?) -> [DirectedPosition] {
        
        var result = [DirectedPosition]()
        var currentPosition = self
        
        while let nextPosition = calculateNextPosition(currentPosition) {
            result.append(nextPosition)
            currentPosition = nextPosition
        }
        
        return result
    }
}
