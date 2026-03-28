//
//  PegChooser.swift
//  Stanford001
//
//  Created by ZuhuAhmu on 21/03/2026.
//

import SwiftUI

struct PegChooser: View {
    
    //MARK: Data In
    let choices : [Peg]
    
    //MARK: Data Out Function
    var onChoose : ((Peg) -> Void)?
    
    //MARK: - Body
    var body: some View {
        HStack {
            ForEach(choices, id: \.self) { peg in
                Button {
                    withAnimation{
                        onChoose?(peg)
                    }
                } label: {
                    PegView(peg: peg)
                }
            }
        }
    }
}

//#Preview {
//    
//    PegChooser(choices: [Color.red, .blue, .green, .yellow]) { peg in
//        print("chose \(peg)")
//    }
//    .padding()
//}
