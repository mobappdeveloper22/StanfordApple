//
//  GameChooser.swift
//  Stanford001
//
//  Created by ZuhuAhmu on 28/03/2026.
//

import SwiftUI

struct GameChooser: View {
    
    // MARK: Data Owned by Me
    @State private var selection: CodeBreaker? = nil
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            GameList(selection: $selection)
                .navigationTitle("Code Breaker")
        } detail: {
            if let selection {
                CodeBreakerView(game: selection)
                    .navigationTitle(selection.name)
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("Choose a game")
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
    
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
    
    
    //        NavigationStack {
    //            List {
    //                ForEach(games) { game in
    //                    NavigationLink {
    //                        CodeBreakerView(game: game)
    //                    } label: {
    //                        GameSummary(game: game)
    //                    }
    //                }
    //                .onDelete { offsets in
    //                    games.remove(atOffsets: offsets)
    //                }
    //                .onMove { offset, destination in
    //                    games.move(fromOffsets: offset, toOffset: destination)
    //                }
    //            }
    //            .listStyle(.plain)
    //            .toolbar {
    //                EditButton()
    //            }
    //        }
}

#Preview {
    GameChooser()
}
