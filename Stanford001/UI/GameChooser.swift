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

    @State private var sortOption: GameList.SortOption = .name
    @State private var sizeOption: GameList.SizeOption = .large
    @State private var search: String = ""
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            Picker("Sort By", selection: $sortOption.animation(.default)) {
                ForEach(GameList.SortOption.allCases, id: \.self) { option in
                    Text(option.title)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            Picker("Size Sorting", selection: $sizeOption.animation(.default)) {
                ForEach(GameList.SizeOption.allCases, id: \.self) { option in
                    Text(option.title)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            GameList(sortBy: sortOption, sizeBy: $sizeOption, nameContains: search, selection: $selection)
                .navigationTitle("Code Breaker")
                .searchable(text: $search)
                .animation(.easeOut, value: search)
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
}

#Preview(traits: .swiftData) {
    GameChooser()
}
