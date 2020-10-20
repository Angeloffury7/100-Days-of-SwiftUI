//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Woolly on 10/2/20.
//  Copyright © 2020 The Woolly Co. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    
    // Prevent touches when the animation is playing.
    @State private var gameIsActive = true
    
    // Used for score change animation.
    @State private var madeCorrectChoice = true
    
    // Animation variables.
    @State private var spinAmount = [0.0, 0.0, 0.0]
    @State private var fadeAmount = [1.0, 1.0, 1.0]
    @State private var scaleAmount: [CGFloat] = [1.0, 1.0, 1.0]
    @State private var scoreOpacity = 0.0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                ForEach(0..<3) { number in
                    Image(self.countries[number])
                        .renderingMode(.original)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black.opacity(0.8), lineWidth: 1))
                        .shadow(color: Color.black.opacity(0.8), radius: 2)
                        // Challenge 3
                        .scaleEffect(scaleAmount[number])
                        // Challenge 2
                        .opacity(fadeAmount[number])
                        // Challenge 1
                        .rotation3DEffect(
                            .degrees(spinAmount[number]),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        // When this is a button, I get a bug where opacity is reduced -- changed to tap gesture to avoid this.
                        .onTapGesture { flagTapped(number) }
                        // Used to prevent touches when the animation is running at the end of a round.
                        .allowsHitTesting(gameIsActive)
                }
                VStack {
                    Text("Score: \(score)")
                    // The score being added or subtracted after a guess.
                    Text("\(madeCorrectChoice ? "+1" : "-1")")
                        .fontWeight(.bold)
                        .foregroundColor(madeCorrectChoice ? Color.green : Color.red)
                        .opacity(scoreOpacity)
                        .offset(x: 0, y: madeCorrectChoice ? -38 : 0)
                }
                Spacer()
            }
            .foregroundColor(.white)
        }
    }
    
    func flagTapped(_ number: Int) {
        // Disable touches for the rest of the round.
        gameIsActive = false
        
        // Used for score change animation.
        madeCorrectChoice = number == correctAnswer
        
        // Animate the change in score.
        scoreOpacity = 1.0
        withAnimation(.linear(duration: 1.5)) {
            scoreOpacity = 0.0
        }
        
        // Challenge 2: Fade out incorrect answers.
        withAnimation {
            fadeAmount = [0.25, 0.25, 0.25]
            fadeAmount[correctAnswer] = 1.0
        }
        
        if number == correctAnswer {
            // Challenge 1: Spin the flag if correct is selected.
            withAnimation(.linear(duration: 1.5)) {
                spinAmount[number] += 360
            }
            score += 1
        } else {
            // Challenge 3: let the player know which flag was the answer.
            let animation = Animation.easeInOut(duration: 0.5).repeatCount(3, autoreverses: true)
            withAnimation(animation) {
                scaleAmount[correctAnswer] = 1.15
            }
            score -= 1
        }
        
        // Some time for the animations to end before askQuestion is called.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            askQuestion()
        }
        
    }
    
    func askQuestion() {
        // Reset fade and scale values for new round.
        withAnimation() {
            fadeAmount = [1.0, 1.0, 1.0]
            scaleAmount = [1.0, 1.0, 1.0]
        }
        // Reenable touches for the round.
        gameIsActive = true
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
