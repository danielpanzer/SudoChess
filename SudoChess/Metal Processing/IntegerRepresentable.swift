//
//  IntegerRepresentable.swift
//  SudoChess
//
//  Created by Daniel Panzer on 12/7/19.
//  Copyright © 2019 CruxCode LLC. All rights reserved.
//

import Foundation

protocol IntegerRepresentable {
    
    init?(_ integer: Int)
    var integerRepresentation: Int {get}
    
}
