//
//  GameChooser.swift
//  Stanford001
//
//  Created by ZuhuAhmu on 28/03/2026.
//

import SwiftUI

struct GameChooser: View {
    
    // MARK: Data Owned by Me
    @State private var games : [CodeBreaker] = []
    
    var body: some View {
//        List {
//            Section("Games") {
//                ForEach(games, id: \.pegChoices) { game in
//                    GameSummary(game: game)
//                }
//            }
//            
//            Section(header: Image(systemName: "face.smiling").font(.title)) {
//                Text("Hello")
//                Text("there")
//            }
//        }
////        .listStyle(.plain)
//        .onAppear {
//            games.append(CodeBreaker(name: "Mastermind", pegChoices: [.red, .blue, .green, .yellow]))
//            games.append(CodeBreaker(name: "Earth Tones", pegChoices: [.orange, .brown, .black, .yellow, .green]))
//            games.append(CodeBreaker(name: "Undesea", pegChoices: [.blue, .indigo, .cyan]))
//        }
        
        
        NavigationStack {
            List($games, id: \.pegChoices, editActions: [.delete, .move]) { $game in
                NavigationLink {
                    CodeBreakerView(game: $game)
                } label: {
                    GameSummary(game: game)
                }
            }
            .listStyle(.plain)
            .toolbar {
                EditButton()
            }
        }
        .onAppear {
            games.append(CodeBreaker(name: "Mastermind", pegChoices: [.red, .blue, .green, .yellow]))
            games.append(CodeBreaker(name: "Earth Tones", pegChoices: [.orange, .brown, .black, .yellow, .green]))
            games.append(CodeBreaker(name: "Undesea", pegChoices: [.blue, .indigo, .cyan]))
        }
    }
}

#Preview {
    GameChooser()
}
