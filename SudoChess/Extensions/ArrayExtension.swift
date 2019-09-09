//
//  ArrayExtension.swift
//  SudoChess
//
//  Created by Daniel Panzer on 11/3/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

extension Array where Element : Hashable {
    
    func toSet() -> Set<Element> {
        return Set(self)
    }
}
