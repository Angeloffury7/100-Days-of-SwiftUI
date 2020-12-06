//
//  ContentView.swift
//  UnicornMultiplication
//
//  Created by Woolly on 10/21/20.
//  Copyright © 2020 The Woolly Co. All rights reserved.
//

import SwiftUI
import AVFoundation

struct UnicornMultiplication: View {
    // Colors
    private let unicornYellow: Color = Color(red: 254/255, green: 242/255, blue: 162/255)
    private let unicornBlue: Color = Color(red: 141/255, green: 179/255, blue: 210/255)
    private let unicornPink: Color = Color(red: 254/255, green: 179/255, blue: 203/255)
    
    // Animations
    @State private var floatAmount: CGFloat = 0.0
    @State private var fadeAmount = [1.0, 1.0, 1.0, 1.0, 1.0]
    @State private var areAnswersTappable: Bool = true
    
    // Game Selections
    @State private var questionsUpTo: Double = 5.0
    @State private var questionCountChoice: Int = 0
    @State private var questionCountOptions = ["5", "10", "15", "All"]
    
    // Gameplay
    @State private var multiplicationGame: MultiplicationGame? = nil
    enum GameState { case menu, play, score }
    @State private var gameState: GameState = .menu
    
    var body: some View {
        ZStack {
            Color(red: 252/255, green: 221/255, blue: 226/255)
                .edgesIgnoringSafeArea(.all)
            VStack {
                if gameState == .play && multiplicationGame != nil {
                    playGame()
                } else if gameState == .score && multiplicationGame != nil {
                    showScore()
                } else {
                    showMenu()
                }
            }
        }
    }
    
    // MARK: - Views
    
    @ViewBuilder
    func showMenu() -> some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                
                // Header
                Group {
                    Image("shooting-star")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width * 0.4)
                        .offset(y: 25)
                    DropshadowText("Unicorn Multiplication", dropshadowColor: unicornBlue)
                        .foregroundColor(.white)
                        .frame(height: 75)
                        .padding(.bottom, 10)
                }

                Spacer()
                
                // Unicorn
                Image("blue-unicorn")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geo.size.width * 0.75)
                    .padding(.bottom)
                    .offset(y: floatAmount)
                    .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true))
                    .onAppear() {
                        floatAmount = -10
                    }
                    .onDisappear() {
                        floatAmount = 0
                    }
                
                Spacer()
                
                // Options
                Group {
                     HStack {
                         Text("1")
                             .font(.footnote)
                         Slider(value: $questionsUpTo, in: 1...12, step: 1)
                             .accentColor(unicornYellow)
                         Text("12")
                             .font(.footnote)
                     }
                     .padding(.top)
                     
                     Picker("How many questions?", selection: $questionCountChoice) {
                         ForEach(0..<questionCountOptions.count) {
                             Text(questionCountOptions[$0])
                         }
                     }
                     .pickerStyle(SegmentedPickerStyle())
                     .padding(.bottom)
                }
                
                Spacer()
                
                // Play Game Button
                Button(action: { startGame() }, label: {
                    Text("Play Game!")
                        .foregroundColor(unicornBlue)
                })
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5)
                .padding()
                
                Spacer()
            }
            .padding(.horizontal)
            .frame(width: geo.size.width, height: geo.size.height)
            .colorScheme(.light)
        }
    }
    
    @ViewBuilder
    func playGame() -> some View {
        // This should never be nil at this point: we have a valid multiplication game and
        // it is either 1) freshly created and has questions, or 2) still has questions left.
        if let nextQuestion = multiplicationGame?.nextQuestion {
            GeometryReader { geo in
                VStack {
                    Spacer()
                    
                    // Question
                    DropshadowText("\(nextQuestion.factorOne) x \(nextQuestion.factorTwo)", dropshadowColor: unicornBlue)
                        .foregroundColor(.white)
                        .frame(height: 150)
                    
                    // Answer Selection Clouds
                    let answers = nextQuestion.possibleAnswers
                    HStack {
                        ForEach(0..<3) { index in
                            AnswerCloud(answers[index], width: (geo.size.width * 0.8) / 3, color: unicornBlue)
                            .opacity(fadeAmount[index])
                            .onTapGesture { answerQuestion(with: answers[index]) }
                            .allowsHitTesting(areAnswersTappable)
                        }
                    }
                    HStack {
                        ForEach(3..<5) { index in
                            AnswerCloud(answers[index], width: (geo.size.width * 0.8) / 3, color: unicornBlue)
                            .opacity(fadeAmount[index])
                            .onTapGesture { answerQuestion(with: answers[index]) }
                            .allowsHitTesting(areAnswersTappable)
                        }
                    }
                    
                    Spacer()
                    
                    // Unicorn
                    ZStack {
                        Image("stars-trio")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geo.size.width * 0.20)
                            .offset(x: -((geo.size.width * 0.75) / 2), y: -20 + floatAmount)
                            .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true))
                            .onAppear() {
                                floatAmount = -5
                            }
                            .onDisappear() {
                                floatAmount = 0
                            }
                        Image("stars-trio")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geo.size.width * 0.20)
                            .offset(x: ((geo.size.width * 0.75) / 2), y: 100 - floatAmount)
                            .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true))
                        Image("unicorn-rainbow")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geo.size.width * 0.75)
                            .padding(.vertical)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .frame(width: geo.size.width, height: geo.size.height)
                .colorScheme(.light)
            }
        } else {
            // However, add in condition for unexpected situtation.
            Text("Unable to play game.")
            Button("Return to Menu") {
                multiplicationGame = nil
                gameState = .menu
            }
        }
    }
    
    
    @ViewBuilder
    func showScore() -> some View {
        GeometryReader { geo in
            VStack {
                // multiplicationGame should never be nil here.
                let score = multiplicationGame != nil ? multiplicationGame!.score : 0
                let message = score == 0 ? "Nice Try!" : (multiplicationGame?.numberOfQuestions == score ? "Perfect!" : "Great Job!")

                Spacer()
                
                // Message & Score Cloud
                DropshadowText(message, dropshadowColor: unicornBlue)
                    .foregroundColor(.white)
                    .frame(height: 100)
                    .padding(.top)
      
                ZStack {
                    Image("cloud-gems")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width * 0.6)
                    Text(String(score))
                        .font(.custom("sweet purple", size: min(geo.size.height, geo.size.width) * 0.2))
                        .foregroundColor(unicornBlue)
                        .lineLimit(1)
                        .minimumScaleFactor(0.01)
                        .offset(y: -25)
                }
                .padding(.bottom, 20)

                Spacer()
                
                // Unicorn
                Image("resting-unicorn")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geo.size.width * 0.75)
                    .padding(.bottom)
                    .offset(y: floatAmount)
                    .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true))
                    .onAppear() {
                        floatAmount = -10
                    }
                    .onDisappear() {
                        floatAmount = 0
                    }
                
                Spacer()
                
                // Play Again Button
                Button(action: { restartGame() }, label: {
                    Text("Play Again?")
                        .foregroundColor(unicornBlue)
                })
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5)
                .padding()
                
                Spacer()

            }
            .padding(.horizontal)
            .frame(width: geo.size.width, height: geo.size.height)
            .colorScheme(.light)
        }
    }
    
    // MARK: - Gameplay
    
    func startGame() {
        let questionCount: Int? = questionCountChoice < 3 ? Int(questionCountOptions[questionCountChoice]) : nil
        multiplicationGame = MultiplicationGame(numberOfQuestions: questionCount, questionRange: 1...Int(questionsUpTo))
        gameState = .play
    }
    
    func restartGame() {
        multiplicationGame = nil
        gameState = .menu
    }
    
    func answerQuestion(with answer: Int) {
        assert(multiplicationGame != nil, "answerQuestion(with:): multiplicationGame nil")
        
        areAnswersTappable = false
        
        // Figure out which is correct answer
        withAnimation {
            fadeAmount = [0.25, 0.25, 0.25, 0.25, 0.25]
            
            let possibleAnswers = multiplicationGame!.questions[0].possibleAnswers
            let correctAnswer = multiplicationGame!.questions[0].answer
            fadeAmount[possibleAnswers.firstIndex(of: correctAnswer)!] = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                fadeAmount = [1.0, 1.0, 1.0, 1.0, 1.0]
            }
            multiplicationGame!.guess(answer: answer)
            if multiplicationGame!.questions.count > 0 {
                gameState = .play
            } else {
                gameState = .score
            }
            areAnswersTappable = true
        }

    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UnicornMultiplication()
    }
}
