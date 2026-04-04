//
//  GameSummaryView.swift
//  Stanford001
//
//  Created by ZuhuAhmu on 28/03/2026.
//

import SwiftUI

struct GameSummary: View {
    
    var game: CodeBreaker
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(game.name)
                .font(.title)
            PegChooser(choices: game.pegChoices)
                .frame(maxHeight: 50)
            Text("^[\(game.attempts.count) attempt](inflect: true)")
        }
        //            .listRowSeparator(.hidden)
        //            .listRowBackground(RoundedRectangle(cornerRadius: 10).foregroundStyle(.yellow).padding(5))
    }
}

#Preview(traits: .swiftData) {
    List {
        GameSummary(game: CodeBreaker(name: "Preview", pegChoices: [.red, .cyan, .yellow]))
    }
    
    List {
        GameSummary(game: CodeBreaker(name: "Preview", pegChoices: [.red, .cyan, .yellow]))
    }
    .listStyle(.plain)
}
