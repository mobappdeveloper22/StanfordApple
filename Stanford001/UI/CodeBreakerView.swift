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
    
    // MARK: - Body
    var body: some View {
        VStack {
            CodeView(code: game.masterCode)
//            CodeView(code: game.masterCode, selection: $selection) { EmptyView() }
//            CodeView(code: game.masterCode, selection: $selection) { Text("0.03").font(.title) }
//            CodeView(code: game.masterCode, selection: $selection, ancillaryView:  { EmptyView() })
            Divider()
            ScrollView {
                if (!game.isOver) {
                    CodeView(code: game.guess, selection: $selection) {
                        guessButton
                    }
                }
                Divider()
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(code: game.attempts[index]) {
                        if let matches = game.attempts[index].matches {
                            MatchMarkers(matches: matches)
                        }
                    }
                    Divider()
                }
            }
            PegChooser(choices: game.pegChoices) { peg in
                game.setGuessPage(peg, at: selection)
                selection = (selection + 1) % game.masterCode.pegs.count
            }
        }.padding()
        
    }
    
    var guessButton : some View {
        Button("Guess") {
            withAnimation{
                game.attemptGuess()
                selection = 0
            }
        }.font(.system(size: GuessButton.maximumFontSize))
            .minimumScaleFactor(GuessButton.scaleFactor)
    }
    
    struct GuessButton {
        static let minimumFontSize : CGFloat = 5
        static let maximumFontSize : CGFloat = 80
        static let scaleFactor = minimumFontSize / maximumFontSize
    }
    

    
}

extension Color {
    static func gray(_ brightness : CGFloat) -> Color {
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}



#Preview {
    CodeBreakerView()
}
