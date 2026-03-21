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
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .overlay {
                if (peg == Code.missingPeg) {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.gray)
                }
            }
            .contentShape(Rectangle())
            .aspectRatio(1, contentMode: .fit)
            .foregroundStyle(peg)
    }
    
}

#Preview {
    PegView(peg : .blue)
        .padding()
}
