//
//  Code.swift
//  Stanford001
//
//  Created by ZuhuAhmu on 21/03/2026.
//

import SwiftUI

extension Peg {
    static let missing = Color.clear
}

struct Code {
    var kind : Kind
    var pegs : [Peg] = Array(repeating: .missing, count: 4)
    
    static let missingPeg : Peg = .missing
    
    enum Kind : Equatable {
        case master(isHidden : Bool)
        case guess
        case attempt([Match])
        case uknown
    }
    
    mutating func randomize(from pegChoices : [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missingPeg
        }
    }
    
    var isHidden : Bool {
        switch kind {
            case .master(let isHidden): return isHidden
            default: return false
        }
    }
    
    mutating func reset() {
        pegs = Array(repeating: .missing, count: 4)
    }
    
    var matches:[Match]? {
        switch kind {
        case .attempt(let matches):
            return matches
        default:
            return nil
        }
    }
    
    func match(against otherCode : Code) -> [Match] {
        var pegsToMatch = otherCode.pegs
        
        var backwardsExactMatches : [Match] = pegs.indices.reversed().map { index in
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                pegsToMatch.remove(at: index)
                return .exact
            } else {
                return .nomatch
            }
        }
        
        let exactMatches : [Match] = backwardsExactMatches.reversed()
        return pegs.indices.map { index in
            if exactMatches[index] != .exact , let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                pegsToMatch.remove(at: matchIndex)
                return .inexact
            } else {
                return exactMatches[index]
            }
        }
        
//        // alternate is above
//        var results : [Match] = Array(repeating: .nomatch, count: pegs.count)
//        for index in pegs.indices.reversed() {
//            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
//                results[index] = .exact
//                pegsToMatch.remove(at: index)
//            }
//        }
//
//        for index in pegs.indices {
//            if exactMatches[index] != .exact {
//                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
//                    exactMatches[index] = .inexact
//                    pegsToMatch.remove(at: matchIndex)
//                }
//            }
//        }
//        return exactMatches
    }
}
