//
//  HistoryView.swift
//  SudoChess
//
//  Created by Daniel Panzer on 10/10/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
    
    @EnvironmentObject private var viewModel: GameViewModel
    
    var body: some View {
        List {
            ForEach(self.viewModel.game.history, id: \.self) { move in
                Text(move.description)
            }
        }
    .frame(minWidth: 50, idealWidth: 200, maxWidth: 200,
           minHeight: 200, idealHeight: 300, maxHeight: 300)
    }
}

private struct HistoryViewPreview: View {
    
    @State var viewModel: GameViewModel = GameViewModel(game: .standard)
    
    var body: some View {
        HistoryView()
            .environmentObject(viewModel)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryViewPreview()
            .previewLayout(.fixed(width: 200, height: 600))
    }
}
