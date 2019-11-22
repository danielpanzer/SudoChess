**SudoChess** is an open-ended chess library leveraging **SwiftUI** and **Combine** that makes it easy to speak the language of chess. Design your own computer opponent, or use it as a foundation for your own chess app. Includes a simple board and game interface all written in **SwiftUI**.

![preview](http://s3.amazonaws.com/PermanentHosting/sudochess_preview.gif)

## Getting Started

Clone the repo and check out `Documentation.playground` for interactive framework documentation.

SwiftUI:

```swift
//Add a game view model to your SwiftUI view as an @ObservableObject
//Pass the view model into the included game interface

struct ContentView: View {

    @ObservedObject var viewModel: GameViewModel = GameViewModel(roster: Roster(whitePlayer: .human,
                                                                       blackPlayer: .ai(ModestMike())))
    var body: some View {
        GameView(viewModel: self.viewModel)
    }
}

```

UIKit:

```swift
//Construct a game view model with the desired players

let viewModel = GameViewModel(roster: Roster(whitePlayer: .human),
                                              blackPlayer: .ai(ModestMike())))

//Provide the view model to the included game interface

let gameView = GameView(viewModel: viewModel)
let viewController = UIHostingController(rootView: gameView)

```

## Creating a computer opponent

Write a new class that conforms to `ArtificialOpponent`:

```swift
/// Extremely simple AI full of bad move decisions
class StupidSteve : ArtificialOpponent {

    var name: String {
        "Stupid Steve"
    }

    func nextMove(in game: Game) -> Move {

        let validMoves = game.currentMoves()
        let piecesWeCanCapture: [(piece: Piece, move: Move)] = validMoves
            .compactMap { move in
                guard let potentiallyCapturedPiece = game.board[move.destination] else {
                    return nil
                }

                return (potentiallyCapturedPiece, move)
        }

        if piecesWeCanCapture.count > 0 {

            let mostValuableCapture = piecesWeCanCapture
                .sorted(by: {return $0.piece.value > $1.piece.value})
                .first!

            return mostValuableCapture.move

        } else {
            return validMoves.randomElement()!
        }
    }
}
```

Pass your class into the game roster to play against it:

```swift
let roster = Roster(whitePlayer: .human, blackPlayer: .ai(StupidSteve()))
let viewModel = GameViewModel(roster: roster)
```
