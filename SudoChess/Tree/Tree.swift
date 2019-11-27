//
//  Tree.swift
//  SudoChess
//
//  Created by Daniel Panzer on 11/27/19.
//  Copyright © 2019 CruxCode LLC. All rights reserved.
//

import Foundation

final class Tree<Value> {
    
    final class Node<Value> {

        init(value: Value) {
            self.value = value
        }
        
        let value: Value
        private(set) var children: [Node] = []
        weak var parent: Node<Value>?
        
        func isLeaf() -> Bool {
            return children.isEmpty
        }
        
        func add(child node: Node) {
            children.append(node)
            node.parent = self
        }
    }
    
    init(root: Node<Value>) {
        self.root = root
    }
    
    let root: Node<Value>
}

extension Tree {
    
    var leaves: [Node<Value>] {
        return root
            .allDescendants
            .filter { $0.isLeaf() }
    }
}

extension Tree.Node {
    
    var parents: [Tree.Node<Value>] {
        switch parent {
        case .none:
            return [self]
        case .some(let parent):
            return parent.parents
        }
    }
    
    var allDescendants: [Tree.Node<Value>] {
        
        let extended = children
            .reduce([Tree.Node]()) { (nextPartialResult, subchild) -> [Tree.Node<Value>] in return nextPartialResult + subchild.allDescendants }
        
        return children + extended
    }
}
