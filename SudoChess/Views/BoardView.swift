//
//  BoardView.swift
//  SudoChess
//
//  Created by Daniel Panzer on 10/2/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import SwiftUI

/// View encapsulating a fully functional chessboard
public struct BoardView: View {
    
    public init(viewModel: GameViewModel) {
        self.viewModel = viewModel
    }
    
    @ObservedObject private var viewModel: GameViewModel
    @State private var isShowingPromotionSheet: Bool = false
    
    private func position(_ row: Int, _ column: Int) -> Position {
        return Position(gridIndex: IndexPath(row: row, column: column))
    }
    
    private static let spacing: CGFloat = {
        return UIDevice.current.userInterfaceIdiom == .phone ? 4 : 8
    }()
    
    public var body: some View {
        ZStack {
            
            VStack(spacing: BoardView.spacing) {
                ForEach(0..<8) { row in
                    HStack(spacing: BoardView.spacing) {
                        ForEach(0..<8) { column in
                            TileView(viewModel: self.viewModel,
                                     position: self.position(row, column))
                        }
                    }
                }
            }
        }
        .padding(BoardView.spacing)
        .border(Color.black, width: 1)
        .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
            
        .onReceive(viewModel.shouldPromptForPromotion) { moveNeedingPromotion in
            self.isShowingPromotionSheet = true
        }
            
        .actionSheet(isPresented: $isShowingPromotionSheet, content: {
            ActionSheet(title: Text("Promotion"),
                        message: Text("Please select a piece for promotion"),
                        buttons:
                
                [Queen.self, Rook.self, Bishop.self, Knight.self].map { promotionType in
                    let title = String(describing: promotionType)
                    return ActionSheet.Button.default(Text(title)) {
                        self.viewModel.handlePromotion(with: promotionType)
                        self.isShowingPromotionSheet = false
                    }
                }
            )
        })
    }
}

private struct BoardViewPreview: View {
    
    @ObservedObject var viewModel: GameViewModel = GameViewModel(game: .standard)
    
    var body: some View {
        BoardView(viewModel: viewModel)
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardViewPreview()
            .previewLayout(.fixed(width: 600, height: 600))
    }
}
