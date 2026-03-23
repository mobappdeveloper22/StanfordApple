//
//  CodeView.swift
//  Stanford001
//
//  Created by ZuhuAhmu on 21/03/2026.
//

import SwiftUI

struct CodeView<AncillaryView>: View where AncillaryView: View {
    
    // MARK: Data in
    var code : Code
    
    // MARK: Data share by me
    @Binding var selection : Int
    
    // MARK: Data (sort of) In Function
    @ViewBuilder let ancillaryView : () -> AncillaryView
    
    // MARK: Data Owned by Me
    @Namespace private var selectionNamespace
    
    
    init(
        code: Code,
        selection: Binding<Int> = Binding<Int>.constant(-1),
        @ViewBuilder ancillaryView: @escaping () -> AncillaryView = { EmptyView() }
    ) {
        self.code = code
        self._selection = selection
        self.ancillaryView = ancillaryView
    }
    
    // MARK: - Body
    var body: some View {
        
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                PegView(peg: code.pegs[index])
                    .padding(Selection.border)
                    .background {
                        Group {
                            if selection == index, code.kind == .guess {
                                Selection.shape
                                    .foregroundStyle(Selection.color)
                                    .matchedGeometryEffect(id: "selection", in: selectionNamespace)
                            }
                        }
                        .animation(.selection, value: selection)
                    }
                    .overlay {
                        Selection.shape
                            .foregroundStyle(code.isHidden ? Color.gray : .clear)
                            .transaction { transaction in
                                if (code.isHidden) {
                                    transaction.animation = nil
                                }
                            }
                    }
                    .onTapGesture {
                        if (code.kind == .guess) {
                            selection = index
                        }
                    }
            }
            
            Color.clear.aspectRatio(1, contentMode: .fit)
                .overlay {
                    ancillaryView()
                }
//                .overlay {
//                if let matches = code.matches {
//                    MatchMarkers(matches: matches)
//                } else {
//                    if (code.kind == .guess) {
//                        guessButton
//                    }
//                }
//            }
        }
        
        
    }
    
    
}

fileprivate struct Selection {
    static let border : CGFloat = 5
    static let cornerRadius : CGFloat = 10
    static let color : Color = Color.gray(0.85)
    static let shape = RoundedRectangle(cornerRadius: cornerRadius)
}

//#Preview {
//    CodeView()
//}
