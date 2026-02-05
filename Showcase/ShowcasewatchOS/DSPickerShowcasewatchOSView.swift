//
//  ShowcaseSortOrderWatch.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSControls

// MARK: - DSPicker Showcase watchOS

/// Demo option type for picker showcases on watchOS.
private enum ShowcaseSortOrderWatch: String, CaseIterable, Identifiable, Sendable {
    case nameAsc = "Name (A-Z)"
    case nameDesc = "Name (Z-A)"
    case dateNewest = "Newest"
    case dateOldest = "Oldest"
    
    var id: String { rawValue }
}

private enum ShowcaseColorWatch: String, CaseIterable, Identifiable, Sendable {
    case red = "Red"
    case green = "Green"
    case blue = "Blue"
    case purple = "Purple"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .red: return "heart.fill"
        case .green: return "leaf.fill"
        case .blue: return "drop.fill"
        case .purple: return "star.fill"
        }
    }
}

/// Showcase view demonstrating DSPicker control on watchOS
struct DSPickerShowcasewatchOSView: View {
    @Environment(\.dsTheme) private var theme
    @Environment(\.dsCapabilities) private var capabilities
    
    @State private var autoSort = ShowcaseSortOrderWatch.nameAsc
    @State private var navSort = ShowcaseSortOrderWatch.dateNewest
    @State private var disabledSort = ShowcaseSortOrderWatch.nameAsc
    @State private var iconColor = ShowcaseColorWatch.blue
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Auto mode
            Text("Auto Mode")
                .font(.caption2)
                .foregroundStyle(theme.colors.fg.tertiary)
            
            DSPicker("Sort", selection: $autoSort, options: ShowcaseSortOrderWatch.allCases) {
                Text($0.rawValue)
            }
            
            Divider()
            
            // Navigation mode
            Text("Navigation")
                .font(.caption2)
                .foregroundStyle(theme.colors.fg.tertiary)
            
            DSPicker("Sort", selection: $navSort, options: ShowcaseSortOrderWatch.allCases, mode: .navigation) {
                Text($0.rawValue)
            }
            
            Divider()
            
            // With icon
            Text("With Icon")
                .font(.caption2)
                .foregroundStyle(theme.colors.fg.tertiary)
            
            DSPicker("Color", selection: $iconColor, options: ShowcaseColorWatch.allCases, icon: "paintpalette") {
                Label($0.rawValue, systemImage: $0.icon)
            }
            
            Divider()
            
            // Disabled
            Text("Disabled")
                .font(.caption2)
                .foregroundStyle(theme.colors.fg.tertiary)
            
            DSPicker("Sort", selection: $disabledSort, options: ShowcaseSortOrderWatch.allCases, isDisabled: true) {
                Text($0.rawValue)
            }
            
            Divider()
            
            // Spec info
            Text("Platform")
                .font(.caption2)
                .foregroundStyle(theme.colors.fg.tertiary)
            
            HStack {
                Text("Presentation")
                    .font(.caption2)
                    .foregroundStyle(theme.colors.fg.secondary)
                Spacer()
                Text(capabilities.preferredPickerPresentation.rawValue)
                    .font(.caption2.monospaced())
                    .foregroundStyle(theme.colors.fg.primary)
            }
        }
    }
}

#Preview("DSTextField watchOS") {
    NavigationStack {
        ScrollView {
            DSTextFieldShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("DSTextField")
    }
    .dsTheme(.dark)
}

#Preview("DSPicker watchOS") {
    NavigationStack {
        ScrollView {
            DSPickerShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("DSPicker")
    }
    .dsTheme(.dark)
}
