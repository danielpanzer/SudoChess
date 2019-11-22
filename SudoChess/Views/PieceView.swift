//
//  PieceView.swift
//  SudoChess
//
//  Created by Daniel Panzer on 10/14/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import SwiftUI

struct PieceView: View {
    
    let piece: Piece?
    
    var body: some View {
        ZStack {
            self.piece?.image
            .resizable()
            .scaledToFit()
        }
        //.rotationEffect(piece?.owner == .black ? .degrees(180) : .degrees(0))
    }
}

struct PieceView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
        
            PieceView(piece: Pawn(owner: .black))
            .previewLayout(.fixed(width: 200, height: 200))
            
            PieceView(piece: Pawn(owner: .white))
            .previewLayout(.fixed(width: 200, height: 200))
        }
        
    }
}
