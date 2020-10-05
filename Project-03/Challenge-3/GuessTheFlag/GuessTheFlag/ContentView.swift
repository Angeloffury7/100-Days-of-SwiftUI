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
    
    @State private var showingScoreAlert = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
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
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        // Challenge 3
                        FlagImage(country: countries[number])
                    }
                }
                Text("Score: \(score)")
                Spacer()
            }
            .foregroundColor(.white)
        }
        .alert(isPresented: $showingScoreAlert) {
            Alert(title: Text(scoreTitle), message: Text("Your score is: \(score)"), dismissButton: .default(Text("Continue")) { self.askQuestion() })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = "Wrong, that's the flag of \(countries[number])."
            score -= 1
        }
        
        showingScoreAlert = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - Challenge 2: Flag Image View

struct FlagImage : View {
    var country: String
    
    var body: some View {
        // Adjusted styling on the flags: RoundedRectangle shape, stroke & shadow opacity.
        Image(country)
            .renderingMode(.original)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black.opacity(0.8), lineWidth: 1))
            .shadow(color: Color.black.opacity(0.8), radius: 2)
    }
}
