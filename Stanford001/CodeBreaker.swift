//
//  CodeBreaker.swift
//  Stanford001
//
//  Created by ZuhuAhmu on 14/03/2026.
//

import SwiftUI

typealias Peg = Color

struct CodeBreaker {
    var masterCode : Code = Code(kind: .master)
    var guess : Code = Code(kind: .guess)
    var attempts : [Code] = []
    let pegChoices : [Peg]
    
    init(pegChoices : [Peg] = [.red, .green, .blue, .yellow] ) {
        self.pegChoices = pegChoices
        masterCode.randomize(from: pegChoices)
        print(masterCode)
    }
    
    mutating func changeGuessPeg(at index : Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPage = pegChoices[(indexOfExistingPegInPegChoices+1) % pegChoices.count]
            guess.pegs[index] = newPage
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missingPeg
        }
    }
    
    mutating func attemptGuess() {
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
    }
    
}



