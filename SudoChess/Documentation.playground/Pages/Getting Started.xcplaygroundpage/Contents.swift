//: Getting started
  
import UIKit
import SwiftUI
import SudoChess
import PlaygroundSupport

let roster = Roster(whitePlayer: .human,
                    blackPlayer: .ai(PowerPete()))

let viewModel = GameViewModel(roster: roster)
let view = GameView(viewModel: viewModel)
PlaygroundPage.current.liveView = UIHostingController(rootView: view)

//: Leveraging Combine

let stateSubscription = viewModel
    .$state
    .sink { state in print(state) }

let moveSubscription = viewModel
    .$game
    .compactMap { game in game.history.last }
    .sink { lastMove in print(lastMove) }

//: [Next](@next)
