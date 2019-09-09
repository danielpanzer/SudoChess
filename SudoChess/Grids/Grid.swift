//
//  Grid.swift
//  SudoChess
//
//  Created by Daniel Panzer on 9/2/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

struct Grid<Element> {
    
    private typealias Column = [Element]
    
    //MARK: Lifecycle
    
    init(rowSize: Int, columnSize: Int, using array: [Element]) {
        precondition(array.count == rowSize * columnSize, "passed array must match the grid size")
        
        var columns = Array(repeating: Column(), count: rowSize)
        var currentColumn = 0
        for element in array {
            columns[currentColumn].append(element)
            if currentColumn == columns.count - 1 {
                currentColumn = 0
            } else {
                currentColumn += 1
            }
        }
        
        self.columns = columns
        self.rowSize = rowSize
        self.columnSize = columnSize
    }
    
    //MARK: Public Interface
    
    let rowSize: Int
    let columnSize: Int
    
    subscript(row: Int, column: Int) -> Element {
        get {
            return columns[column][row]
        }
        set {
            columns[column][row] = newValue
        }
    }
    
    subscript(position: IndexPath) -> Element {
        get {
            return self[position.row, position.column]
        }
        set {
            self[position.row, position.column] = newValue
        }
    }
    
    //MARK: Private Properties
    
    private var columns: [Column]
    
}

extension Grid : Collection {
    
    func index(after index: IndexPath) -> IndexPath {
        if (index.column == columnSize - 1) {
            return IndexPath(row: index.row + 1, column: 0)
        } else {
            return IndexPath(row: index.row, column: index.column + 1)
        }
    }
    
    typealias Index = IndexPath
    
    var startIndex: IndexPath {
        return IndexPath(indexes: [0, 0])
    }
    
    var endIndex: IndexPath {
        return IndexPath(indexes: [0, columnSize])
    }
}

extension Grid : BidirectionalCollection {
    
    func index(before index: IndexPath) -> IndexPath {
        if (index.column == 0) {
            return IndexPath(row: index.row - 1, column: columnSize - 1)
        } else {
            return IndexPath(row: index.row, column: index.column - 1)
        }
    }
}

extension Grid : RandomAccessCollection {}

extension Grid : CustomStringConvertible {
    
    var description: String {
        return columns.reduce("", { (currentResult, column) -> String in
            return currentResult + String(describing: column) + "\n"
        })
    }
}

extension Grid : CustomDebugStringConvertible {
    
    var debugDescription: String {
        return description
    }
}

extension Grid where Element : ExpressibleByNilLiteral {
    
    init(rowSize: Int, columnSize: Int) {
        let emptyArray = Array<Element>(repeating: nil, count: rowSize*columnSize)
        self = Grid(rowSize: rowSize, columnSize: columnSize, using: emptyArray)
    }
}

extension Grid : Equatable where Element : Equatable {}

extension Grid : Hashable where Element : Hashable {}
