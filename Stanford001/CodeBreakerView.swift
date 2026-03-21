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
            view(for: game.masterCode)
            Divider()
            ScrollView {
                if (!game.isOver) {
                    view(for: game.guess)
                }
                Divider()
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
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
    
    func view(for code : Code) -> some View {
        HStack {
            CodeView(code : code, selection: $selection)
            
            Color.clear.aspectRatio(1, contentMode: .fit)
                .overlay {
                if let matches = code.matches {
                    MatchMarkers(matches: matches)
                } else {
                    if (code.kind == .guess) {
                        guessButton
                    }
                }
            }
        }
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
