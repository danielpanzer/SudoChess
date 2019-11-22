//
//  GameView.swift
//  SudoChess
//
//  Created by Daniel Panzer on 10/10/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import SwiftUI

/// View that includes a board and basic game layout
public struct GameView: View {
    
    public init(viewModel: GameViewModel) {
        self.viewModel = viewModel
    }
    
    @ObservedObject private var viewModel: GameViewModel
    
    public var body: some View {
        VStack {
            Text("\(viewModel.roster.blackPlayer.description) (black)")
            BoardView(viewModel: viewModel)
                .layoutPriority(11)
            Text("\(viewModel.roster.whitePlayer.description) (white)")
            //.rotationEffect(.degrees(180))
            HStack(alignment: .center) {
                ConsoleView(viewModel: self.viewModel)
            }
        }
        .padding()
    }
}

private struct GameViewPreview: View {
    
    @ObservedObject var viewModel = GameViewModel(game: Game.standard,
                                                  checkHandler: CheckHandler())
    
    var body: some View {
        GameView(viewModel: viewModel)
    }
}

struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            
            //            GameViewPreview()
            //                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
            //                .previewDisplayName("iPhone SE")
            
            GameViewPreview()
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
                .previewDisplayName("iPhone 11")
            
            //            GameViewPreview()
            //                .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
            //                .previewDisplayName("iPad Pro (11-inch)")
        }
        
    }
}
