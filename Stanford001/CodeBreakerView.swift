//
//  ContentView.swift
//  Stanford001
//
//  Created by ZuhuAhmu on 13/03/2026.
//

import SwiftUI

struct CodeBreakerView: View {
    
    // MARK: Data owned by me
    @State var game = CodeBreaker(pegChoices: [.brown, .yellow, .orange, .black])
    
    // MARK: - Body
    var body: some View {
        VStack {
            view(for: game.masterCode)
            Divider()
            ScrollView {
                view(for: game.guess)
                Divider()
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                    Divider()
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
                PegView(peg: code.pegs[index])
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
