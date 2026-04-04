//
//  Code.swift
//  Stanford001
//
//  Created by ZuhuAhmu on 21/03/2026.
//

import SwiftUI
import SwiftData

extension Peg {
    static let missing = Color.clear
}

@Model class Code {
    
    var _kind : String = Kind.unknown.description
    
    var kind : Kind {
        get { return Kind(_kind) }
        set { _kind = newValue.description}
    }
    var pegs : [Peg]
    
    static let missingPeg : Peg = ""
    
    init(kind: Kind, pegs: [Peg] = Array(repeating: Code.missingPeg, count: 4)) {
        self.pegs = pegs
        self.kind = kind
    }
    
    func randomize(from pegChoices : [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missingPeg
        }
        print(self)
    }
    
    var isHidden : Bool {
        switch kind {
            case .master(let isHidden): return isHidden
            default: return false
        }
    }
    
    func reset() {
        pegs = Array(repeating: Code.missingPeg, count: 4)
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
        
        let backwardsExactMatches : [Match] = pegs.indices.reversed().map { index in
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
