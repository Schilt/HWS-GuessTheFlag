//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Andrew A. Schilt on 6/24/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingGameOver = false
    @State private var scoreTitle = ""
    @State private var gameOverTitle = ""
    @State private var score = 0
    @State private var numberOfQuestions = 0
    @State private var countries = initialCountries.shuffled()
    static let initialCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    @State private var correctAnswer = Int.random(in: 0...2)
    
    struct FlagView : View {
        var country : String
        
        var body :some View {
            Image(country)
                .renderingMode(.original)
                .clipShape(Capsule())
                .shadow(radius: 5)
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()
                VStack{
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                        .font(.subheadline.weight(.heavy))
                    
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle.weight(.semibold))
                }
                ForEach(0..<3) { number in
                    Button {
                        flagTapped(number)
                    } label: {
                        FlagView(country: countries[number])
                    }
                }
                VStack {
                    Spacer()
                    Text("Score: \(score)/\(numberOfQuestions)")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                }
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message:  {
            Text("Your score is \(score)/\(numberOfQuestions)")
        }
        
        .alert(gameOverTitle, isPresented: $showingGameOver) {
            Button() {
                numberOfQuestions = 0
                score = 0
                countries = ContentView.initialCountries.shuffled()
                correctAnswer = Int.random(in: 0...2)
            } label: {
                Text("Would you like to play again?")
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])."
        }
        numberOfQuestions += 1
        showingScore = true
    }
    
    func askQuestion() {
        countries.remove(at: correctAnswer)
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        if numberOfQuestions >= 8 {
            gameOverTitle = "Game Over!\nRating: "
            switch score {
            case 0,1 : gameOverTitle += "poor"
            case 2,3 : gameOverTitle += "ok"
            case 4,5 : gameOverTitle += "good"
            case 6,7 : gameOverTitle += "excellent!"
            case 8:    gameOverTitle += "Perfect!"
            default:   gameOverTitle += "CHEATER!"
            }
            showingGameOver = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
