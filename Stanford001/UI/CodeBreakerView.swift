//
//  ContentView.swift
//  Stanford001
//
//  Created by ZuhuAhmu on 13/03/2026.
//

import SwiftUI

struct CodeBreakerView: View {
    
    // MARK: Data owned by me
    @State private var game = CodeBreaker(pegChoices: [.brown, .yellow, .orange, .black, .green])
    
    @State private var selection : Int = 0
    @State private var restarting : Bool = false
    @State private var hideMostRecentMarkers : Bool = false
    
    // MARK: - Body
    var body: some View {
        VStack {
            Button("Restart", systemImage: "arrow.circlepath", action: restart)

            VStack {
                CodeView(code: game.masterCode) {
//                    ElapsedTime(startTime: game.startTime, endTime: game.endTime)
//                        .flexibalSystemFont()
//                        .monospaced()
//                        .lineLimit(1)
                }
                Divider()
            }
            ScrollView {
                if !game.isOver {
                    VStack {
                        CodeView(code: game.guess, selection: $selection) {
                            Button("Guess", action: guess).flexibalSystemFont()
                        }
                        Divider()
                    }
                    .animation(nil, value: game.attempts.count)
                    .opacity(restarting ? 0 : 1)
                }
                ForEach(game.attempts, id: \.pegs) { attempt in
                    VStack {
                        CodeView(code: attempt) {
                            let showMarkers = !hideMostRecentMarkers || attempt.pegs != game.attempts.first?.pegs
                            if showMarkers, let matches = attempt.matches {
                                MatchMarkers(matches: matches)
                            }
                        }
                        Divider()
                    }.transition(.attempt(game.isOver))
                }
            }
            if (!game.isOver) {
                PegChooser(choices: game.pegChoices, onChoose: changePegAtSelection)
                    .transition(.pegChooser)
//                    .transition(.move(edge: .bottom))
            }
//            PegChooser(choices: game.pegChoices) { peg in
//                changePegAtSelection(to: peg)
//            }
        }.padding()
        
    }
    
    func changePegAtSelection(to peg : Peg) {
        game.setGuessPage(peg, at: selection)
        selection = (selection + 1) % game.masterCode.pegs.count
    }
    
    func restart() {
        withAnimation(.restart) {
            restarting = game.isOver
            game.restart()
            selection = 0
        } completion: {
            withAnimation(.restart) {
                restarting = false
            }
        }
    }
    
    func guess() {
        withAnimation(.guess) {
            game.attemptGuess()
            selection = 0
            hideMostRecentMarkers = true
        } completion: {
            withAnimation(.guess) {
                hideMostRecentMarkers = false
            }
        }
    }
    
}





#Preview {
    CodeBreakerView()
}
