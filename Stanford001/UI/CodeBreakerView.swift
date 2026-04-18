//
//  ContentView.swift
//  Stanford001
//
//  Created by ZuhuAhmu on 13/03/2026.
//

import SwiftUI

struct CodeBreakerView: View {
    
    // MARK: Data In
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.sceneFrame) var sceneFrame

    // MARK: Data shared with me
    let game : CodeBreaker

//    // MARK: Data shared with me
//    @Binding var game : CodeBreaker

    
    // MARK: Data owned by me
//    @State private var game = CodeBreaker(pegChoices: [.brown, .yellow, .orange, .black, .green])

    @State private var selection : Int = 0
    @State private var restarting : Bool = false
    @State private var hideMostRecentMarkers : Bool = false
    
    // MARK: - Body
    var body: some View {
        
        VStack {
            // Button("Restart", systemImage: "arrow.circlepath", action: restart)
            VStack {
                CodeView(code: game.masterCode)
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
            GeometryReader { geometry in
                if (!game.isOver) {
                    let offset = sceneFrame.maxY - geometry.frame(in: .global).minY
                    PegChooser(choices: game.pegChoices, onChoose: changePegAtSelection)
                        .transition(.offset(x: 0, y: offset))
                        .frame(maxHeight: 90)
                    //                    .transition(.move(edge: .bottom))
                }
            }
            .aspectRatio(CGFloat(game.pegChoices.count), contentMode: .fit)
            .frame(maxHeight: 90)
//            PegChooser(choices: game.pegChoices) { peg in
//                changePegAtSelection(to: peg)
//            }
        }
        .gesture(pegChoosingDial)
        .trackElapsedTime(in: game)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Restart", systemImage: "arrow.circlepath", action: restart)
            }
            
            ToolbarItem {
                Button("Save", systemImage: "square.and.arrow.down") {
                    if let json = try? JSONEncoder().encode(game) {
                        let url = FileManager.default.temporaryDirectory.appendingPathComponent(game.name)
                            .appendingPathExtension("json")
                        // print("url==\(url)")
                        try? json.write(to: url)
                    }
                }
            }
            
            ToolbarItem {
                ElapsedTime(startTime: game.startTime, endTime: game.endTime, elapsedTime : game.elapsedTime)
                    .monospaced()
                    .lineLimit(1)
                
            }
        }
        .padding()
        
    }
    
    var pegChoosingDial : some Gesture {
        RotateGesture()
            .onChanged { angle in
                if (!(angle.rotation.degrees.isNaN)) {
                    let petChoiceIndex = Int(Int(abs(angle.rotation.degrees / 90.0)) % game.pegChoices.count)
                    game.guess.pegs[selection] = game.pegChoices[petChoiceIndex]
                }
            }
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

extension CodeBreaker {
    
    convenience init(name: String = "Code Breaker", pegChoices: [Color]) {
        self.init(name: name, pegChoices: pegChoices.map(\.hex))
    }
    
    var pegColorChoices : [Color] {
        get { pegChoices.map { Color(hex: $0) ?? .clear } }
        set { pegChoices = newValue.map(\.hex) }
    }
    
}

#Preview(traits: .swiftData) {
    @Previewable @State var game = CodeBreaker(name: "Preview", pegChoices: [.blue, .red, .orange])
    NavigationStack {
        CodeBreakerView(game: game)
    }
}
