//
//  Game.swift
//  MemoryGame
//
//  Created by Woolly on 10/7/20.
//  Copyright © 2020 The Woolly Co. All rights reserved.
//

import Foundation


struct Game {
    var currentChoice: Move = Move.allCases.randomElement()!
    var chooseWin: Bool = Bool.random()
    
    func winBattle(using move: Move) -> Bool {
        let wonMatch = move.winsBattle(with: currentChoice)
        return (chooseWin && wonMatch) || (!chooseWin && !wonMatch)
    }
}

protocol RockPaperScissorsGameItem {
    var winsAgainst: [Self] { get }
    func winsBattle(with: Self) -> Bool
}

enum Move: String, CaseIterable, RockPaperScissorsGameItem {
    case rock = "rock", paper = "paper", scissors = "scissors", lizard = "lizard", spock = "Spock"
}

extension Move {
    var winsAgainst: [Move] {
        switch self {
        case .rock: return [.scissors, .lizard]
        case .paper: return [.rock, .spock]
        case .scissors: return [.paper, .lizard]
        case .lizard: return [.paper, .spock]
        case .spock: return [.rock, .scissors]
        }
    }
    
    func winsBattle(with opponent: Move) -> Bool {
        return self.winsAgainst.contains(opponent)
    }
}
