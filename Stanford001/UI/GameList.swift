//
//  GameList.swift
//  Stanford001
//
//  Created by ZuhuAhmu on 03/04/2026.
//

import SwiftUI
import SwiftData

struct GameList: View {
    
    // MARK: Data in
    @Environment(\.modelContext) var modelContext
    
    // MARK: Data shared with me
    @Binding var selection: CodeBreaker?
    @Query private var games: [CodeBreaker]

    // MARK: Data Owned by Me
    @State private var gameToEdit : CodeBreaker?
    
    init(sortBy: SortOption = .name, nameContains search: String = "", selection: Binding<CodeBreaker?>) {
        _selection = selection
        let lowercaseSearch = search.lowercased()
        let capitalizedSearch = search.capitalized
        let predicate = #Predicate<CodeBreaker> { game in
            search.isEmpty || game.name.contains(lowercaseSearch) || game.name.contains(capitalizedSearch)
        }
        switch sortBy {
        case .name: _games = Query(filter: predicate, sort: \CodeBreaker.name)
        case .recent: _games = Query(filter: predicate, sort: \CodeBreaker.lastAttemptDate, order: .reverse)
        }
    }
    
    enum SortOption: CaseIterable {
        case name
        case recent
        
        var title: String {
            switch self {
            case .name: "Sort by Name"
            case .recent: "Recent"
            }
        }
    }
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameSummary(game: game)
                }
                .contextMenu {
                    editButton(for: game) // editing game
                    deleteButton(for: game)
                }
                .swipeActions(edge: .leading) {
                    editButton(for: game)
                        .tint(.accentColor)
                }
//                    NavigationLink(value: game.masterCode.pegs) {
//                        Text("Cheat")
//                    }
            }
            .onDelete { offsets in
                for offset in offsets {
                    modelContext.delete(games[offset])
                }
            }
        }
        .onChange(of: games) {
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
// below code passed in detail because of ipad change (using NavigationSplitView)
//            .navigationDestination(for: CodeBreaker.self) { game in
//                CodeBreakerView(game: game)
//                    .navigationTitle(game.name)
//                    .navigationBarTitleDisplayMode(.inline)
//            }
//            .navigationDestination(for: [Peg].self) { pegs in
//                PegChooser(choices: pegs)
//            }
        .listStyle(.plain)
        .toolbar {
            addButton
            EditButton() // editing list of game
        }
        .onAppear {
            addSampleGames()
        }
    }
    
    func editButton(for game : CodeBreaker) -> some View {
        Button("Edit", systemImage: "pencil") {
            gameToEdit = game
        }
    }

    var addButton : some View {
        Button("Add Button", systemImage: "plus") {
            gameToEdit = CodeBreaker(name: "New Game", pegChoices: [.purple, .gray])
        }
        .sheet(isPresented: showGameEditor) {
            gameEditor
        }
    }
    
    @ViewBuilder
    var gameEditor : some View {
        if let gameToEdit {
            let copyOfGameToEdit = CodeBreaker(name: gameToEdit.name, pegChoices: gameToEdit.pegChoices)
            GameEditor(game: copyOfGameToEdit) {
                if games.contains(gameToEdit) {
                    modelContext.delete(gameToEdit)
                }
                modelContext.insert(copyOfGameToEdit)
            }
        }
    }
    
    var showGameEditor : Binding<Bool> {
        Binding<Bool>( get: {
            gameToEdit != nil
        }, set: { newValue in
            if !newValue {
                gameToEdit = nil
            }
            
        })
    }
    
    func deleteButton(for game : CodeBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                modelContext.delete(game)
            }
        }
    }
    
    func addSampleGames() {
        let fetchDescriptor = FetchDescriptor<CodeBreaker>()
        if let results = try? modelContext.fetchCount(fetchDescriptor), results == 0 {
            modelContext.insert(CodeBreaker(name: "Mastermind", pegChoices: [.red, .blue, .green, .yellow]))
            modelContext.insert(CodeBreaker(name: "Earth Tones", pegChoices: [.orange, .brown, .black, .yellow, .green]))
            modelContext.insert(CodeBreaker(name: "Undesea", pegChoices: [.blue, .indigo, .cyan]))
        }
    }
}

#Preview(traits: .swiftData) {
    
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}
