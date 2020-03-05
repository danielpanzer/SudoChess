//
//  MainView.swift
//  SudoChess
//
//  Created by Daniel Panzer on 3/4/20.
//  Copyright © 2020 CruxCode LLC. All rights reserved.
//

import SwiftUI

public struct MainView : View {
    
    public init() {}
    
    @ObservedObject private var viewModel = StartGameViewModel()
    
    var gameViewModel: GameViewModel {
        GameViewModel(
            roster: viewModel.roster
        )
    }
    
    public var body: some View {
        NavigationView {
            VStack {
            
                PlayerSelectionView(viewModel: viewModel)
                    .navigationBarTitle("Player Selection")
                
                NavigationLink(
                destination: GameView(viewModel: self.gameViewModel),
                label: {Text("Play!")})
                
            }.padding()
        }
    }
}

private struct MainViewPreview: View {
    
    var body: some View {
        MainView()
    }
}

struct MainView_Previews: PreviewProvider {
    
    static var previews: some View {
        MainViewPreview()
    }
}
