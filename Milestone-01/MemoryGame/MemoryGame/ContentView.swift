//
//  ContentView.swift
//  MemoryGame
//
//  Created by Woolly on 10/6/20.
//  Copyright © 2020 The Woolly Co. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var game: Game = Game()
    @State private var madeCorrectChoice: Bool = true
    @State private var roundsLeft: Int = 10
    @State private var score: Int = 0
    
    var body: some View {
        VStack {
            Spacer()
            makeHeader()
            Spacer()
            HStack(spacing: 20) {
                makeMoveButton(.rock)
                makeMoveButton(.paper)
                makeMoveButton(.scissors)
            }
            .padding(5)
            HStack(spacing: 20) {
                makeMoveButton(.lizard)
                makeMoveButton(.spock)
            }
            .padding(5)
            Spacer()
            makeFooter()
            Spacer()
        }
    }
    
    @ViewBuilder private func makeHeader() -> some View {
        if (roundsLeft == 0) {
            Image("thumbsup")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
            Text("Game Over!").fontWeight(.bold)
            Button(action: { restartGame() }){ Text("Play Again?") }
        } else {
            MoveImage(game.currentChoice)
            HStack(spacing: 0) {
                Text("Try to ")
                Text(game.chooseWin ? "win" : "lose").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text(" against ")
                Text(game.currentChoice.rawValue).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text(":")
            }
        }
    }
    
    @ViewBuilder private func makeFooter() -> some View {
        if (roundsLeft == 10) {
            Text("What's your guess?")
        } else if (roundsLeft > 0) {
            Text(madeCorrectChoice ? "Correct!" : "Wrong!").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        } else if (roundsLeft == 0) {
            Text(score < 5 ? "Better luck next time..." : "Congrats!")
            HStack(spacing: 0) {
                Text("Score: ")
                Text("\(score)").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            }
        }
    }
    
    private func makeMoveButton(_ move: Move) -> some View {
        Button(action: { playGame(move: move) }) {
            MoveImage(move)
        }.disabled(roundsLeft > 0 ? false : true)
    }
    
    private func playGame(move: Move) {
        if (roundsLeft > 0) {
            let win = game.winBattle(using: move)
            madeCorrectChoice = win
            score += win ? 1 : -1
            
            roundsLeft -= 1
            if (roundsLeft > 1) {
                self.game = Game()
            }
        }
    }
    
    private func restartGame() {
        score = 0
        roundsLeft = 10
        game = Game()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MoveImage: View {
    var move: Move
    var body: some View {
        Image(move.rawValue.lowercased())
            .resizable()
            .scaledToFit()
            .frame(height: 100)
    }
    init(_ move: Move) {
        self.move = move
    }
}
