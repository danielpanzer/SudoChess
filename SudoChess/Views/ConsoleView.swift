//
//  ConsoleView.swift
//  SudoChess
//
//  Created by Daniel Panzer on 10/10/19.
//  Copyright © 2019 Daniel Panzer. All rights reserved.
//

import SwiftUI

struct ConsoleView: View {
    
    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
    }
    
    @ObservedObject private var viewModel: GameViewModel
    
    var body: some View {
        VStack {
            HStack {
                //            Button(action: {self.viewModel.reverseLastMove()},
                //                   label: {
                //                    Text("REVERSE MOVE")
                //                    .fontWeight(.bold)
                //                    .padding(12)
                //                    .background(Color.blue)
                //                    .cornerRadius(20)
                //                    .foregroundColor(.white)
                //                    .padding(5)
                //            })
                //                .disabled(self.viewModel.state != .awaitingHumanInput)
                //                .opacity(self.viewModel.state == .awaitingHumanInput ? 1 : 0.5)
                //            Spacer(minLength: 20)
                Text("\(self.viewModel.state.description)")
                    .lineLimit(1)
                Spacer(minLength: 8)
                Text("Turn: \(self.viewModel.game.turn.description.capitalized)")
            }
            Spacer()
        }
        .padding(.vertical)
        .frame(minHeight: 100, maxHeight: 200)
    }
}

private struct ConsoleViewPreview: View {
    
    @ObservedObject var viewModel: GameViewModel = GameViewModel(game: .standard)
    
    var body: some View {
        ConsoleView(viewModel: viewModel)
    }
}

struct ConsoleView_Previews: PreviewProvider {
    static var previews: some View {
        ConsoleViewPreview()
            .previewLayout(.fixed(width: 600, height: 250))
    }
}
