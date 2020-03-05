//
//  PlayerSelectionView.swift
//  SudoChess
//
//  Created by Daniel Panzer on 3/4/20.
//  Copyright © 2020 CruxCode LLC. All rights reserved.
//

import SwiftUI

struct PlayerSelectionView: View {
    
    @ObservedObject private(set) var viewModel: StartGameViewModel
    
    var body: some View {
        VStack {
            
            VStack {
                Text("White Player")
                    .bold()
                Spacer()
                    .frame(height: 50)
                Picker(selection: $viewModel.whitePlayer,
                       label: EmptyView(),
                       content: {
                        ForEach(PlayerSelection.allCases, id:\.self) { selection in
                            Text(selection.description)
                        }
                })
                    .labelsHidden()
                    .frame(height: 100)
            }
            
            Spacer()
                .frame(height: 80)
            
            VStack {
                Text("Black Player")
                    .bold()
                Spacer()
                    .frame(height: 50)
                Picker(selection: $viewModel.blackPlayer,
                       label: EmptyView(),
                       content: {
                        ForEach(PlayerSelection.allCases, id:\.self) { selection in
                            Text(selection.description)
                        }
                })
                    .labelsHidden()
                    .frame(height: 100)
            }
        }
    }
}

private struct PlayerViewPreview: View {
    
    var viewModel = StartGameViewModel()
    
    var body: some View {
        PlayerSelectionView(viewModel: viewModel)
    }
}

struct PlayerView_Previews: PreviewProvider {
    
    static var previews: some View {
        PlayerViewPreview()
    }
}
