//
//  ChessColor.swift
//  SudoChess
//
//  Created by Daniel Panzer on 9/2/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation
import SwiftUI

/// Describes the two possible teams, white and black
public enum Team {
    case white
    case black
    
    public var opponent: Team {
        switch self {
        case .white:
            return .black
        case .black:
            return .white
        }
    }
    
    var color: Color {
        switch self {
        case .white:
            return .white
        case .black:
            return .black
        }
    }
}

extension Team : CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .white:
            return "white"
        case .black:
            return "black"
        }
    }
}
