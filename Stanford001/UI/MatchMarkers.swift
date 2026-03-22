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
    
    // MARK: Data in
    let matches : [Match]
    
    var body: some View {
        HStack {
            VStack {
                matchMarker(peg: 0)
                matchMarker(peg: 1)
            }
            VStack {
                matchMarker(peg: 2)
                matchMarker(peg: 3)
            }
        }
        
    }
    
    func matchMarker(peg : Int) -> some View {
//        let exactCount: Int = matches.filter({ $0 == .exact }).count
//        let foundCount: Int = matches.filter({ $0 != .nomatch }).count

//        let exactCount: Int = matches.count(where: { match in match == .exact })
//        let foundCount: Int = matches.count(where: { match in match != .nomatch })

        let exactCount: Int = matches.count { $0 == .exact }
        let foundCount: Int = matches.count { $0 != .nomatch }

        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2).aspectRatio(1, contentMode: .fit)
    }
    
}

#Preview {
    MatchMarkers(matches: [.exact, .inexact, .nomatch, .exact])
}

