//
//  Move.swift
//  SudoChess
//
//  Created by Daniel Panzer on 9/18/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

///A chess move
public struct Move : Hashable {
    
    init(origin: Position,
         destination: Position,
         capturedPiece: Piece?,
         kind: Kind = .standard) {
        self.origin = origin
        self.destination = destination
        self.capturedPiece = capturedPiece
        self.kind = kind
    }
    
    /// The kind of chess move, to differentiate between a normal move and other moves that have special rules
    public enum Kind : Hashable {
        case standard
        case castle
        case enPassant
        case needsPromotion
        case promotion(Piece)
    }
    
    /// The starting position of the moved piece
    public let origin: Position
    
    /// The destination of the moved piece
    public let destination: Position
    
    /// The piece that was potentially captured by this move
    public let capturedPiece: Piece?
    
    /// The kind of move
    public let kind: Kind
}

extension Move : CustomStringConvertible {
    
    public var description: String {
        switch kind {
        case .standard:
            return "\(origin) -> \(destination)"
        case .castle:
            return "\(origin) -> \(destination) : Castle"
        case .enPassant:
            return "\(origin) -> \(destination) : En Passant"
        case .needsPromotion:
            return "\(origin) -> \(destination) : Needs Promotion"
        case .promotion(_):
            return "\(origin) -> \(destination) : Promotion"
        }
    }
}
