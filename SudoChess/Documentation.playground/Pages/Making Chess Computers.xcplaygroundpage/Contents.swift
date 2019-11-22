//: [Previous](@previous)

import UIKit
import SwiftUI
import SudoChess
import PlaygroundSupport

//: Making a chess computer

///A gambler at heart
class RandomRob : ArtificialOpponent {
    
    var name: String {
        return "Random Rob"
    }
    
    func nextMove(in game: Game) -> Move {
        let availableMoves = game.currentMoves()
        return availableMoves.randomElement()!
    }
}

//Add your chess computer to the roster
let roster = Roster(whitePlayer: .ai(RandomRob()),
                    blackPlayer: .ai(ModestMike()))

let viewModel = GameViewModel(roster: roster)
let view = GameView(viewModel: viewModel)
PlaygroundPage.current.liveView = UIHostingController(rootView: view)

//More fun subscriptions as Modest Mike destroys Random Rob
let subscription =
    viewModel
        .$game
        .sink { currentGame in
            
            guard let capturedPiece = currentGame.history.last?.capturedPiece else {return}
            
            let whiteTotalPieceValue =
                currentGame
                    .board
                    .compactMap { $0 }
                    .filter { piece in piece.owner == .white && !(piece is King) }
                    .reduce(0) { currentValue, piece in currentValue + piece.value }
            
            let blackTotalPieceValue =
                currentGame
                    .board
                    .compactMap { $0 }
                    .filter { piece in piece.owner == .black && !(piece is King) }
                    .reduce(0) { currentValue, piece in currentValue + piece.value }
            
            let message = """
            Captured Piece: \(capturedPiece) (\(capturedPiece.owner))
            New Total Piece Values
            White: \(whiteTotalPieceValue), Black: \(blackTotalPieceValue)
            
            """
            
            print(message)
}
    
//: [Next](@next)
