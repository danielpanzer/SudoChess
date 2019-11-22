//
//  IndexPathExtension.swift
//  SudoChess
//
//  Created by Daniel Panzer on 9/2/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import Foundation

extension IndexPath {
    
    init(row: Int, column: Int) {
        self.init(indexes: [column, row])
    }
    
    var row: Int {
        return self[1]
    }
    
    var column: Int {
        return self[0]
    }
}
