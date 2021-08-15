//
//  ContentView.swift
//  WordScramble
//
//  Created by Daniel Vaswani on 14/08/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    //Challenge 3 compute score somehow
    var score : Int {
        // no of words * sum letter count of them
        usedWords.count
            * usedWords.reduce(0) { $0 + $1.count}
    }
    
        var body: some View {
            NavigationView {
                VStack {
                    TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                        .autocapitalization(.none)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    
                    
                    List(usedWords, id: \.self) {
                        Image(systemName: "\($0.count).circle")
                        Text($0)
                    }
                    
                    // Challenge 3 compute score
                    Text("You have a score of \(score)!")
                }
                .navigationBarTitle(rootWord)
                // Challenge 2 Button to start new game
                .navigationBarItems(leading:
                    Button(action : startGame) { Text("New Game")}
                )
                .onAppear(perform: startGame)
                .alert(isPresented: $showingError) {
                    Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
    
    func addNewWord() {
        let answer = newWord
            .lowercased()
            .trimmingCharacters(in:.whitespacesAndNewlines)
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }

        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word.")
            return
        }
        
        guard answer.count > 0 else {
            return
        }
        
        //Challenge 1 Part 2 check if word is not the same as rootWord
        guard answer != rootWord else {
            return
        }
        
        usedWords.insert(answer, at:0)
        newWord = ""
    }
    
    func startGame(){
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy : "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord

        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }

        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        //Challenge 1 Part 1 Only commit if word length is longer than 4 chars and has no spelling mistakes
        
        return word.count > 3 && misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
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
