//
//  GameList.swift
//  Stanford001
//
//  Created by ZuhuAhmu on 03/04/2026.
//

import SwiftUI

struct GameList: View {
    
    // MARK: Data shared with me
    @Binding var selection: CodeBreaker?
 
    // MARK: Data Owned by Me
    @State private var games : [CodeBreaker] = []
    
    @State private var gameToEdit : CodeBreaker?
    
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
//                    NavigationLink(value: game.masterCode.pegs) {
//                        Text("Cheat")
//                    }
            }
            .onDelete { offsets in
                games.remove(atOffsets: offsets)
            }
            .onMove { offset, destination in
                games.move(fromOffsets: offset, toOffset: destination)
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
                if let index = games.firstIndex(of: gameToEdit) {
                    games[index] = copyOfGameToEdit
                } else {
                    games.insert(gameToEdit, at: 0)
                }
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
                games.removeAll { $0 == game }
            }
        }
    }
    
    func addSampleGames() {
        if (games.isEmpty) {
            games.append(CodeBreaker(name: "Mastermind", pegChoices: [.red, .blue, .green, .yellow]))
            games.append(CodeBreaker(name: "Earth Tones", pegChoices: [.orange, .brown, .black, .yellow, .green]))
            games.append(CodeBreaker(name: "Undesea", pegChoices: [.blue, .indigo, .cyan]))
//        selection = games.first
            selection = games[Int.random(in: 0..<games.count)]
        }
    }
}

#Preview {
    
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}
