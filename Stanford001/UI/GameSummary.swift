//
//  GameSummaryView.swift
//  Stanford001
//
//  Created by ZuhuAhmu on 28/03/2026.
//

import SwiftUI

struct GameSummary: View {
    
    var game: CodeBreaker
    
    var size: Size = .compact
    
    enum Size {
        case compact
        case regular
        case large
        
        var larger : Size {
            switch self {
                case .compact : .regular
                default: .large
            }
        }

        var smaller : Size {
            switch self {
                case .large : .regular
                default: .compact
            }
        }
    }
    
    var body: some View {
        
        let changingLayout = size == .compact ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout(alignment: .leading))
        
        changingLayout {
            Text(game.name)
                .font(size == .compact ? .body : .title)
            PegChooser(choices: game.pegChoices)
                .frame(maxHeight: size == .compact ? 35 : 50)
            if (size == .large) {
                Text("^[\(game.attempts.count) attempt](inflect: true)")
            }
        }
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
