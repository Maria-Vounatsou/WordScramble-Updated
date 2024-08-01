//
//  WordScrambleApp.swift
//  WordScramble
//
//  Created by Maria Vounatsou on 10/5/24.
//

import SwiftUI

@main
struct WordScrambleApp: App {
    @StateObject private var viewModel = ViewModelApp()
    @StateObject private var scoreViewModel = ScoreViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(scoreViewModel)
        }
    }
}

