//: [Previous](@previous)

import Foundation
import SudoChess
import SwiftUI
import PlaygroundSupport

//: Create your own scenario

let customBoard: Board = {
    
    let pieces: [Piece?] = [
        
        Knight(owner: .black),
        Knight(owner: .black),
        Knight(owner: .black),
        Queen(owner: .black),
        King(owner: .black),
        Knight(owner: .black),
        Knight(owner: .black),
        Knight(owner: .black),
        
        Knight(owner: .black),
        Knight(owner: .black),
        Knight(owner: .black),
        Knight(owner: .black),
        Knight(owner: .black),
        Knight(owner: .black),
        Knight(owner: .black),
        Knight(owner: .black),
        
        nil, nil, nil, nil, nil, nil, nil, nil,
        nil, nil, nil, nil, nil, nil, nil, nil,
        nil, nil, nil, nil, nil, nil, nil, nil,
        nil, nil, nil, nil, nil, nil, nil, nil,
        
        Knight(owner: .white),
        Knight(owner: .white),
        Knight(owner: .white),
        Knight(owner: .white),
        Knight(owner: .white),
        Knight(owner: .white),
        Knight(owner: .white),
        Knight(owner: .white),
        
        Knight(owner: .white),
        Knight(owner: .white),
        Knight(owner: .white),
        Queen(owner: .white),
        King(owner: .white),
        Knight(owner: .white),
        Knight(owner: .white),
        Knight(owner: .white)
    ]
    
    return Board(array: pieces)
}()

let roster = Roster(whitePlayer: .ai(ModestMike()),
                    blackPlayer: .ai(ModestMike()))

let customGame = Game(board: customBoard)

let viewModel = GameViewModel(roster: roster, game: customGame)
let view = BoardView(viewModel: viewModel)
PlaygroundPage.current.liveView = UIHostingController(rootView: view)

