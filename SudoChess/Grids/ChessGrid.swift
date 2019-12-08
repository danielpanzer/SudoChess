//
//  ChessGrid.swift
//  SudoChess
//
//  Created by Daniel Panzer on 9/2/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

/// A generalized grid data structure that speaks in chess positions
public struct ChessGrid<Element> {
    
    /// Creates a grid from an array of values, which will populate from the upper left to lower right
    /// - Precondition: Array count must exactly match the number of grid elements (rowSize * columnSize)
    /// - Parameter array: The list of values with which to populate the grid
    public init(array: [Element]) {
        self.grid = Grid<Element>(rowSize: 8, columnSize: 8, using: array)
    }
    
    /// Creates a grid from a single value. This single value will be repeated for every position of the grid
    /// - Parameter repeatingElement: The element with which to populate the grid
    public init(repeatingElement prototypeElement: Element) {
        self.grid = Grid<Element>(rowSize: 8, columnSize: 8, using: Array(repeating: prototypeElement, count: 64))
    }
    
    private var grid: Grid<Element>
    
    public subscript(position: Position) -> Element {
        get {
            return grid[position.gridIndex]
        }
        set {
            grid[position.gridIndex] = newValue
        }
    }
}

extension ChessGrid : Equatable where Element : Equatable {}

extension ChessGrid : Hashable where Element : Hashable {}

extension ChessGrid : ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: Element...) {
        self = ChessGrid(array: elements)
    }
    
    public typealias ArrayLiteralElement = Element
    
}

extension ChessGrid where Element : ExpressibleByNilLiteral {
    
    init() {
        self.grid = Grid<Element>(rowSize: 8, columnSize: 8)
    }
}

extension ChessGrid : Collection {
    
    public typealias Index = Position
    
    public var startIndex: Position {
        return Position(.a, .eight)
    }
    
    public var endIndex: Position {
        return Position(.a, .end)
    }
    
    public func index(after i: Position) -> Position {
        return Position.positions[Position.indices[i]! + 1]!
    }
}

extension ChessGrid : BidirectionalCollection {
    
    public func index(before i: Position) -> Position {
        return Position.positions[Position.indices[i]! - 1]!
    }
}

extension ChessGrid : RandomAccessCollection {}

extension ChessGrid : CustomStringConvertible {
    
    public var description: String {
        return grid.description
    }
}

extension ChessGrid : CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return grid.debugDescription
    }
}

