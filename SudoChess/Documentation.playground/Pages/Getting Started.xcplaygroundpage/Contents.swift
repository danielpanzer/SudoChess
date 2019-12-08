//: Getting started
  
import UIKit
import SwiftUI
import SudoChess
import PlaygroundSupport

let roster = Roster(whitePlayer: .ai(ModestMike()),
                    blackPlayer: .ai(ModestMike()))

let viewModel = GameViewModel(roster: roster)
let view = GameView(viewModel: viewModel)
PlaygroundPage.current.liveView = UIHostingController(rootView: view)

//: Leveraging Combine

let scoreSubscription = viewModel
    .$game
    .board

//: [Next](@next)
