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
                CodeView(code: game.masterCode)
//                CodeView(code: game.masterCode, selection: $selection) { EmptyView() }
//                CodeView(code: game.masterCode, selection: $selection) { Text("0.03").font(.title) }
//                CodeView(code: game.masterCode, selection: $selection, ancillaryView:  { EmptyView() })
                Divider()
            }
            ScrollView {
                if (!game.isOver || restarting) {
                    VStack {
                        CodeView(code: game.guess, selection: $selection) {
                            Button("Guess", action: guess).flexibalSystemFont()
                        }
                        Divider()
                    }
                    .animation(nil, value: game.attempts.count)
                    .opacity(restarting ? 0 : 1)
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    VStack {
                        CodeView(code: game.attempts[index]) {
                            let showMarkers = !hideMostRecentMarkers || index != (game.attempts.count - 1)
                            if showMarkers, let matches = game.attempts[index].matches {
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
            restarting = true
        } completion: {
            withAnimation(.restart) {
                game.restart()
                selection = 0
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
