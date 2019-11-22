//
//  PieceCell.swift
//  SudoChess
//
//  Created by Daniel Panzer on 10/9/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import SwiftUI

struct TileView: View {
    
    private let shouldShowPosition = false
    
    init(viewModel: GameViewModel, position: Position) {
        self.viewModel = viewModel
        self.position = position
    }
    
    @ObservedObject private var viewModel: GameViewModel
    let position: Position
    
    private var isCurrentlyHighlighted: Bool {
        return viewModel.selection?.grid[position] ?? false
    }
    
    private var highlightColor: Color {
        
        guard viewModel.selection?.origin != self.position else {
            return Color.green
        }
        
        guard !isCurrentlyHighlighted else {
            if let piece = viewModel.game.board[self.position], piece.owner != viewModel.game.turn {
                return Color.red
            } else {
                return Color.blue
            }
        }
        
        return Color.clear
    }
    
    var body: some View {
        
        Button(action: {
            guard self.viewModel.state == .awaitingHumanInput else {return}
            self.viewModel.select(self.position)
        }, label: {
            ZStack {
                Board.colors[position]
                self.highlightColor.opacity(0.5)
                PieceView(piece: self.viewModel.game.board[position])
                
                VStack {
                    Spacer()
                    Text(shouldShowPosition ? self.position.description : "")
                        .font(Font.caption)
                        .bold()
                        .foregroundColor(.black)
                }
            }
            .border(Color.black, width: 1)
        })
    }
}

private struct PieceCellPreview : View {
    
    @ObservedObject private var viewModelNoHighlighting = GameViewModel(game: .standard)
    
    @ObservedObject private var viewModelYesHighlighting = GameViewModel(
        game: .standard,
        selection: GameViewModel.Selection(
            moves: Set(arrayLiteral: Move(
                origin: Position(.b, .one),
                destination: Position(.a, .one),
                capturedPiece: nil)
            ), origin: Position(.a, .one)
        )
    )
    
    let isHighlighted: Bool
    let position: Position
    
    var body: some View {
        TileView(viewModel: isHighlighted ? viewModelYesHighlighting : viewModelNoHighlighting,
                 position: position)
    }
}

struct PieceCell_Previews: PreviewProvider {
    
    static var previews: some View {
        return Group {
            
            PieceCellPreview(isHighlighted: false,
                             position: Position(.b, .two))
                .previewLayout(.fixed(width: 200, height: 200))
//
//            PieceCellPreview(isHighlighted: false,
//                             position: Position(.b, .two))
//                .previewLayout(.fixed(width: 200, height: 200))
//
//            PieceCellPreview(isHighlighted: false,
//                             position: Position(.g, .six))
//                .previewLayout(.fixed(width: 200, height: 200))
//
//            PieceCellPreview(isHighlighted: false,
//                             position: Position(.g, .six))
//                .previewLayout(.fixed(width: 200, height: 200))
//
//            PieceCellPreview(isHighlighted: true,
//                             position: Position(.b, .two))
//                .previewLayout(.fixed(width: 200, height: 200))
//
//            PieceCellPreview(isHighlighted: true,
//                             position: Position(.b, .two))
//                .previewLayout(.fixed(width: 200, height: 200))
//
//            PieceCellPreview(isHighlighted: true,
//                             position: Position(.g, .six))
//                .previewLayout(.fixed(width: 200, height: 200))
//
//            PieceCellPreview(isHighlighted: true,
//                             position: Position(.g, .six))
//                .previewLayout(.fixed(width: 200, height: 200))
            
        }
    }
}
