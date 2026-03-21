//
//  ContentView.swift
//  Stanford001
//
//  Created by ZuhuAhmu on 13/03/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            pegs(colors: [.red, .green, .green, .yellow])
            pegs(colors: [.red, .blue, .green, .yellow])
            pegs(colors: [.red, .yellow, .green, .blue])
        }.padding()
        
    }
    
    func pegs(colors: Array<Color>) -> some View {
        HStack {
            ForEach(colors.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(colors[index])
            }
            MatchMarkers(matches: [.exact, .inexact, .nomatch, .exact])
        }
    }
}



#Preview {
    ContentView()
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
