// ShowcasemacOSApp.swift
// ShowcasemacOS
//
// macOS Design System Showcase App

import SwiftUI

@main
struct ShowcasemacOSApp: App {
    var body: some Scene {
        WindowGroup {
            ShowcasemacOSRootView()
        }
        .windowStyle(.automatic)
        .defaultSize(width: 1200, height: 800)
    }
}
