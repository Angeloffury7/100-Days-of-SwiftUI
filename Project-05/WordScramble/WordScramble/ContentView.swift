//
//  ContentView.swift
//  WordScramble
//
//  Created by Woolly on 10/14/20.
//  Copyright © 2020 The Woolly Co. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var score = 0
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    // Storing the words so we don't have to read them in again for every new game.
    @State private var allWords: [String] = [String]()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                List(usedWords, id:\.self) {
                    Image(systemName: "\($0.count).circle")
                    Text($0)
                }
                
                // Challenge 3: show the player's score.
                Text("Score: \(score)")
            }
            .navigationTitle(rootWord)
            .onAppear(perform: startGame)
            // Challenge 2: new game button.
            .navigationBarItems(leading: Button("New Game", action: startGame) )
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func startGame() {
        if !allWords.isEmpty {
            // Challenge 2: prep new game.
            // Choose new rootWord, restore game to a "new" state.
            rootWord = allWords.randomElement()!
            usedWords.removeAll()
            newWord = ""
            score = 0
        } else {
            if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
                if let startWords = try? String(contentsOf: startWordsURL) {
                    // I'd rather store these strings for use in new games.
                    allWords = startWords.components(separatedBy: "\n")
                    rootWord = allWords.randomElement() ?? "silkworm"
                    return
                }
            }
            fatalError("Could not load start.txt from bundle.")
        }
    }
    
    private func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        
        guard isUnique(word: answer) else {
            wordError(title: "Word Already Used", message: "This word has already been used.")
            return
            
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word Not Possible", message: "This word is not possible from the root word.")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word Not Real", message: "This word doesn't appear to be a real English word.")
            return
        }
        
        guard isLong(word: answer) else {
            wordError(title: "Word Too Short", message: "This word is less than 3 characters in length.")
            return
        }
        
        usedWords.insert(answer, at: 0)
        // Challenge 3: calculate the score.
        // I decided to add a point for each character in the word.
        score += newWord.count
        newWord = ""
    }
    
    private func isUnique(word: String) -> Bool {
        // Challenge 1: also make sure that the word is not the rootWord.
        !usedWords.contains(word) && word != rootWord
    }
    
    private func isPossible(word: String) -> Bool {
        var tempWord = rootWord.lowercased()
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    private func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    // Challenge 1: made this a separate checker function because I want to be able to give users a more valuable error message.
    private func isLong(word: String) -> Bool {
        word.count >= 3
    }
    
    private func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
