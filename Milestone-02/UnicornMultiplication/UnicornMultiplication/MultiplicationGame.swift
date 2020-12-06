//
//  MultiplicationGame.swift
//  UnicornMultiplication
//
//  Created by Woolly on 10/21/20.
//  Copyright © 2020 The Woolly Co. All rights reserved.
//

import Foundation

struct MultiplicationGame {
    private(set) var questions: Array<MultiplicationGameQuestion>
    private(set) var score: Int = 0
    private(set) var numberOfQuestions: Int
    var nextQuestion: MultiplicationGameQuestion? {
        if questions.count > 0 {
            return questions[0]
        } else {
            return nil
        }
    }

    init(numberOfQuestions: Int?, questionRange: ClosedRange<Int>) {
        // Create the questions
        questions = Array<MultiplicationGameQuestion>()
        for factorOne in questionRange {
            for factorTwo in questionRange {
                questions.append(MultiplicationGameQuestion(factorOne: factorOne, factorTwo: factorTwo))
            }
        }
        // Shuffle and take amount requested.
        questions.shuffle()
        if let count = numberOfQuestions, count > 0 {
            questions = Array(questions.prefix(count))
        }
        self.numberOfQuestions = questions.count
        
        for index in 0..<questions.count {
            questions[index].generateAnswers()
        }
    }
    
    mutating func guess(answer: Int) {
        if answer == questions[0].answer {
            score += 1
        }
        questions.remove(at: 0)
    }
}


struct MultiplicationGameQuestion: Hashable {
    private(set) var factorOne: Int
    private(set) var factorTwo: Int
    var answer: Int {
        factorOne * factorTwo
    }
    private(set) var possibleAnswers: [Int] = [Int]()
    
    init(factorOne: Int, factorTwo: Int) {
        self.factorOne = factorOne
        self.factorTwo = factorTwo
    }
    
    private func getDecoyAnswer(_ answers: [Int]) -> Int {
        var decoyAnswer = Int.random(in: 1...12) * (Int.random(in: 1...2) == 1 ? factorOne : factorTwo)
        if decoyAnswer == answer || answers.contains(decoyAnswer) {
            // Duplicate decoy answer, try to get another unique one.
            decoyAnswer = getDecoyAnswer(answers)
        }
        // Supplying a unique decoy answer.
        return decoyAnswer
    }
    
    mutating fileprivate func generateAnswers() {
        var answers = [answer]
        for _ in 0...3 {
            answers.append(getDecoyAnswer(answers))
        }
        answers.shuffle()
        self.possibleAnswers = answers
    }
}
