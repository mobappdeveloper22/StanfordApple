//
//  PegChoicesChooser.swift
//  Stanford001
//
//  Created by ZuhuAhmu on 03/04/2026.
//

import SwiftUI

struct PegChoicesChooser: View {
    
    // MARK: Data shared with me
    @Binding var pegChoices : [Peg]
    
    var body: some View {
        List {
            ForEach(pegChoices.indices, id: \.self) { index in
                ColorPicker(
                    selection: $pegChoices[index],
                    supportsOpacity: false
                ) {
                    // Text("Peg Choice \(index + 1)")
                    button("Peg Choice \(index + 1)", "minus.circle", .red) {
                        pegChoices.remove(at: index)
                    }
                }
            }
            button("Add Peg", "plus.circle", .green) {
                pegChoices.append(.green)
            }
        }
    }
    
    func button(
        _ title: String,
        _ systemImage : String,
        _ color: Color? = nil,
        action: @escaping () -> Void
    ) -> some View {
        HStack {
            Button {
                withAnimation {
                    action()
                }
            } label: {
                Image(systemName: systemImage).tint(color)
            }
            Text(title)
        }
    }
}

#Preview {
    
    @Previewable @State var pegChoices: [Peg] = [.green, .orange]
    
    PegChoicesChooser(pegChoices: $pegChoices)
        .onChange(of: pegChoices) {
            print("pegChoices = \(pegChoices)")
        }
}
