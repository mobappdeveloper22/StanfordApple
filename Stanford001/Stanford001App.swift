//
//  Stanford001App.swift
//  Stanford001
//
//  Created by ZuhuAhmu on 13/03/2026.
//

import SwiftUI
import SwiftData

@main
struct Stanford001App: App {
    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
            GameChooser()
                .modelContainer(for: CodeBreaker.self)
                .environment(\.sceneFrame, geometry.frame(in: .global))
            }
            .ignoresSafeArea(edges: .all)
        }
    }
}

extension EnvironmentValues {
    @Entry var sceneFrame: CGRect = UIScreen.main.bounds
}
