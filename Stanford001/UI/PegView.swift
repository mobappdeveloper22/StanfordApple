//
//  PegView.swift
//  Stanford001
//
//  Created by ZuhuAhmu on 21/03/2026.
//

import SwiftUI

struct PegView: View {
    
    // MARK: Data In
    let peg: Peg
    
    // MARK: - Body
//    let pegShape = RoundedRectangle(cornerRadius: 10)
    let pegShape = Circle()
    
    var body: some View {
        pegShape
//            .overlay {
//                if (peg == Code.missingPeg) {
//                    pegShape
//                        .strokeBorder(Color.gray)
//                }
//            }
            .contentShape(pegShape)
            .aspectRatio(1, contentMode: .fit)
            .foregroundStyle(peg)
    }
    
}

#Preview {
    PegView(peg : .blue)
        .padding()
}
