//
//  MatchMarkers.swift
//  Stanford001
//
//  Created by ZuhuAhmu on 13/03/2026.
//

import SwiftUI

enum Match {
    case nomatch
    case exact
    case inexact
}

struct MatchMarkers : View {
    
    var matches : [Match]
    
    var body: some View {
        HStack {
            printLog(text: "begining")
            VStack {
                matchMarker(peg: 0)
                matchMarker(peg: 1)
            }
            VStack {
                matchMarker(peg: 2)
                matchMarker(peg: 3)
            }
            printLog(text: "end")
        }
    }
    
    func printLog(text : String) -> some View {
        EmptyView()
            .onAppear {
                print("matchMarker==\(text)==")
            }
    }
    
    func matchMarker(peg : Int) -> some View {
        let exactCount: Int = matches.filter({ $0 == .exact }).count
        let foundCount: Int = matches.filter({ $0 != .nomatch }).count
//        let exactCount: Int = matches.count(where: { match in match == .exact })
//        let foundCount: Int = matches.count(where: { match in match != .nomatch })
        print("matchMarker==peg==\(peg)==exactCount==\(exactCount)===foundCount==\(foundCount)")
        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2).aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    MatchMarkers(matches: [.exact, .inexact, .nomatch, .exact])
}

