//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Daniel Vaswani on 12/08/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var deg = 0.0
    @State private var currentCountry = ""
    @State private var opacity = 1.0
    @State private var hasOffset = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing : 30){
                Text("Tap the flag of")
                    .foregroundColor(.white)
                Text(countries[correctAnswer])
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.black)
                
                ForEach(countries[0...2], id: \.self) { country in
                    if country == countries[correctAnswer] {
                        FlagImage(name: country)
                            .rotation3DEffect(
                                Angle(degrees : deg),
                                axis:(0,1,0))
                            .onTapGesture {
                                flagTapped(country)
                            }
                            .offset(y: hasOffset ? 280 : 0)
                    } else {
                        FlagImage(name: country)
                            .opacity(opacity)
                            .onTapGesture {
                                flagTapped(country)
                                withAnimation(.easeOut){
                                    self.hasOffset = true
                                }
                            }
                            .offset(x: hasOffset ? 300 : 0)
                    }
                }
                
                // Challenge 2 show score under flags
                Text("Score: \(score)")
                    .bold()
                    .foregroundColor(.white)
                Spacer()
            }
            
        }
        .alert(isPresented: $showingScore) {
            //Challenge 1 add score "Your score is \(score)"
            //Challenge 3 show correct answer
            Alert(title: Text(scoreTitle), message: Text("\(scoreTitle)! " + (scoreTitle == "Wrong" ? "That’s the flag of \(currentCountry)" : "Good Job!")), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
            
        }
    }
    
    func flagTapped(_ country : String) {
        self.currentCountry = country
        if currentCountry == countries[correctAnswer] {
            scoreTitle = "Correct"
            withAnimation{
                self.deg += 360
                self.opacity = 0.25
            }
            score += 1
            
        } else {
            scoreTitle = "Wrong"
        }
        showingScore = true
    }
    
    func askQuestion() {
        scoreTitle = ""
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        self.opacity = 1.0
        self.hasOffset = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Challenge 3 from Views and Modifiers project
struct FlagImage: View {
    var name : String
    var body: some View {
        Image(name)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}
