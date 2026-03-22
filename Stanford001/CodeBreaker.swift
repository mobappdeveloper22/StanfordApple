//
//  CodeBreaker.swift
//  Stanford001
//
//  Created by ZuhuAhmu on 14/03/2026.
//

import SwiftUI

typealias Peg = Color

struct CodeBreaker {
    
    var masterCode : Code = Code(kind: .master(isHidden: true))
    var guess : Code = Code(kind: .guess)
    var attempts : [Code] = []
    let pegChoices : [Peg]
    
    init(pegChoices : [Peg] = [.red, .green, .blue, .yellow] ) {
        self.pegChoices = pegChoices
        masterCode.randomize(from: pegChoices)
        print(masterCode)
    }
    
    var isOver : Bool {
        attempts.last?.pegs == masterCode.pegs
    }
    
    mutating func attemptGuess() {
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
        guess.reset()
        if (isOver) {
            masterCode.kind = .master(isHidden: false)
        }
    }
    
    mutating func setGuessPage(_ peg : Peg, at index : Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
//    mutating func changeGuessPeg(at index : Int) {
//        let existingPeg = guess.pegs[index]
//        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
//            let newPage = pegChoices[(indexOfExistingPegInPegChoices+1) % pegChoices.count]
//            guess.pegs[index] = newPage
//        } else {
//            guess.pegs[index] = pegChoices.first ?? Code.missingPeg
//        }
//    }
    
}



