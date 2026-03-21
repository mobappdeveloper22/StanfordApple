//
//  ContentView.swift
//  Stanford001
//
//  Created by ZuhuAhmu on 13/03/2026.
//

import SwiftUI

struct CodeBreakerView: View {
    
    @State var game = CodeBreaker(pegChoices: [.brown, .yellow, .orange, .black])
    
    var body: some View {
        VStack {
            view(for: game.masterCode)
            ScrollView {
                view(for: game.guess)
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
            }
        }.padding()
        
    }
    
    var guessButton : some View {
        Button("Guess") {
            withAnimation{
                game.attemptGuess()
            }
        }.font(.system(size: 80))
            .minimumScaleFactor(0.1)
    }
    
    func view(for code : Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .overlay {
                        if (code.pegs[index] == Code.missingPeg) {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.gray)
                        }
                    }
                    .contentShape(Rectangle())
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(code.pegs[index])
                    .onTapGesture {
                        if (code.kind == .guess) {
                            game.changeGuessPeg(at : index)
                        }
                    }
            }
            MatchMarkers(matches: code.matches)
                .overlay {
                    if (code.kind == .guess) {
                        guessButton
                    }
                }
        }
    }
}



#Preview {
    CodeBreakerView()
}




//
//ZStack {
//    
//    VStack {
//        Image(systemName: "globe").border(.blue, width : 1).foregroundStyle(.green)
//        Text("greetings").border(.blue, width : 1).font(.largeTitle).foregroundStyle(.orange)
//        Text("hala 1").border(.blue, width : 1)
//        Text("hala 2").border(.blue, width : 1)
//        Circle()
//    }.padding()
//        .border(.blue, width: 2)
//    HStack {
//        Image(systemName: "globe")
//        Text("greetings")
//    }.border(.blue, width: 2).hidden()
//    
//    VStack {
//        Image(systemName: "globe")
//        Text("greetings")
//    }.border(.blue, width: 2).hidden()
//    ZStack {
//        Image(systemName: "globe")
//        Text("greetings")
//    }.border(.blue, width: 2).hidden()
//}.hidden()
