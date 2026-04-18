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
    
    @Binding var sizeBy: SizeOption
    
    // MARK: Data Owned by Me
    @State private var gameToEdit : CodeBreaker?
    
    init(sortBy: SortOption = .name, sizeBy: Binding<SizeOption>, nameContains search: String = "", selection: Binding<CodeBreaker?>) {
        print("init===sortBy: \(sortBy), sizeBy: \(sizeBy), nameContains: \(search)")
        _selection = selection
        _sizeBy = sizeBy
        let lowercaseSearch = search.lowercased()
        let capitalizedSearch = search.capitalized
        let completedOnly = sortBy == .completed
        let predicate = #Predicate<CodeBreaker> { game in
            (!completedOnly || game.isOver) &&
            (search.isEmpty || game.name.contains(lowercaseSearch) || game.name.contains(capitalizedSearch))
        }
        switch sortBy {
        case .name: _games = Query(filter: predicate, sort: \CodeBreaker.name)
        case .recent, .completed: _games = Query(filter: predicate, sort: \CodeBreaker.lastAttemptDate, order: .reverse)
        }
    }
    
    enum SortOption: CaseIterable {
        case name
        case recent
        case completed
        
        var title: String {
            switch self {
            case .name: "Sort by Name"
            case .recent: "Recent"
            case .completed: "Completed"
            }
        }
    }
    
    enum SizeOption: CaseIterable {
        case compact
        case regular
        case large
        
        var title: String {
            switch self {
            case .compact: "Compact"
            case .regular: "Regular"
            case .large: "Large"
            }
        }
    }
    
    var summarySize : GameSummary.Size {
        print("summarySize==\(staticSummarySize) * \(dynamicSummarySizeMagnification)==\(staticSummarySize * dynamicSummarySizeMagnification)")
        return staticSummarySize * dynamicSummarySizeMagnification
    }
    
    @State private var staticSummarySize : GameSummary.Size = .large
    @State private var dynamicSummarySizeMagnification : CGFloat = 1.0
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameSummary(game: game, size: summarySize)
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
        .onChange(of: sizeBy) { oldValue, newValue in
            switch newValue {
            case .compact:
                staticSummarySize = .compact
            case .regular:
                staticSummarySize = .regular
            case .large:
                staticSummarySize = .large
            }
            
            dynamicSummarySizeMagnification = 1.0
        }
        .gesture(summySizeMagnifier)
        .onChange(of: games) {
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
        .listStyle(.plain)
        .toolbar {
            addButton
            EditButton() // editing list of game
        }
        .task {
            await addSampleGames()
        }
    }
    
    var summySizeMagnifier : some Gesture {
        MagnifyGesture()
            .onChanged { value in
                print("onChanged==\(value.magnification)")
                dynamicSummarySizeMagnification = value.magnification
            }
            .onEnded { value in
                print("onEnded==\(value.magnification)")
                staticSummarySize = staticSummarySize * value.magnification
                dynamicSummarySizeMagnification = 1.0
                
                sizeBy = {
                    switch staticSummarySize {
                    case .compact: return .compact
                    case .regular: return .regular
                    case .large: return .large
                    default: return .regular
                    }
                }()
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
    
    func addSampleGames() async {
        let fetchDescriptor = FetchDescriptor<CodeBreaker>()
        if let results = try? modelContext.fetchCount(fetchDescriptor), results == 0 {
            for url in sampleGameURLs {
                do {
                    let (json, _) = try await URLSession.shared.data(from: url)
                    let game = try JSONDecoder().decode(CodeBreaker.self, from: json)
                    modelContext.insert(game)
                    print("loaded game from url: \(url)")
                } catch {
                    print("could not loan sample json from file at url: \(url) : \(error.localizedDescription)")
                }
            }
            
            //            modelContext.insert(CodeBreaker(name: "Mastermind", pegChoices: [.red, .blue, .green, .yellow]))
            //            modelContext.insert(CodeBreaker(name: "Earth Tones", pegChoices: [.orange, .brown, .black, .yellow, .green]))
            //            modelContext.insert(CodeBreaker(name: "Undesea", pegChoices: [.blue, .indigo, .cyan]))
        }
    }
    
    var sampleGameURLs : [URL] {
        Bundle.main.paths(forResourcesOfType: "json", inDirectory: nil)
            .map { URL(fileURLWithPath: $0) }
    }
}

extension GameSummary.Size {
    
    static func *(lhs: Self, rhs: CGFloat) -> Self {
        switch rhs {
        case 2.0...: lhs.larger.larger
        case 1.5...: lhs.larger
        case ...0.35: lhs.smaller.smaller
        case ...0.5: lhs.smaller
        default: lhs
        }
    }
    
}

#Preview(traits: .swiftData) {
    
    @Previewable @State var selection: CodeBreaker?
    @Previewable @State var sizeOption: GameList.SizeOption = .large

    NavigationStack {
        GameList(sizeBy: $sizeOption, selection: $selection)
    }
}
