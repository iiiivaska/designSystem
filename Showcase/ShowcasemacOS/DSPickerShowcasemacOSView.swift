//
//  ShowcaseSortOrderMac.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSControls

// MARK: - DSPicker Showcase macOS

/// Demo option type for picker showcases.
private enum ShowcaseSortOrderMac: String, CaseIterable, Identifiable, Sendable {
    case nameAsc = "Name (A-Z)"
    case nameDesc = "Name (Z-A)"
    case dateNewest = "Date (Newest)"
    case dateOldest = "Date (Oldest)"
    case sizeSmall = "Size (Smallest)"
    case sizeLarge = "Size (Largest)"
    
    var id: String { rawValue }
}

private enum ShowcaseColorMac: String, CaseIterable, Identifiable, Sendable {
    case red = "Red"
    case orange = "Orange"
    case yellow = "Yellow"
    case green = "Green"
    case blue = "Blue"
    case purple = "Purple"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .red: return "heart.fill"
        case .orange: return "flame.fill"
        case .yellow: return "sun.max.fill"
        case .green: return "leaf.fill"
        case .blue: return "drop.fill"
        case .purple: return "star.fill"
        }
    }
}

/// Showcase view demonstrating DSPicker control on macOS
struct DSPickerShowcasemacOSView: View {
    @Environment(\.dsTheme) private var theme
    @Environment(\.dsCapabilities) private var capabilities
    
    @State private var autoSort = ShowcaseSortOrderMac.nameAsc
    @State private var menuSort = ShowcaseSortOrderMac.dateNewest
    @State private var sheetSort = ShowcaseSortOrderMac.sizeSmall
    @State private var popoverSort = ShowcaseSortOrderMac.nameDesc
    @State private var navSort = ShowcaseSortOrderMac.dateOldest
    @State private var disabledSort = ShowcaseSortOrderMac.nameAsc
    @State private var iconColor = ShowcaseColorMac.green
    
    var body: some View {
        HStack(alignment: .top, spacing: 32) {
            // Left column: Presentations
            VStack(alignment: .leading, spacing: 24) {
                GroupBox("Auto Mode (Platform Default)") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Resolves to: \(capabilities.preferredPickerPresentation.rawValue)")
                            .font(.caption)
                            .foregroundStyle(theme.colors.fg.tertiary)
                        
                        DSPicker("Sort By", selection: $autoSort, options: ShowcaseSortOrderMac.allCases) {
                            Text($0.rawValue)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                }
                
                GroupBox("Menu Mode") {
                    DSPicker("Sort By", selection: $menuSort, options: ShowcaseSortOrderMac.allCases, mode: .menu) {
                        Text($0.rawValue)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                }
                
                GroupBox("Popover Mode") {
                    DSPicker("Sort By", selection: $popoverSort, options: ShowcaseSortOrderMac.allCases, mode: .popover) {
                        Text($0.rawValue)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                }
                
                GroupBox("Sheet Mode") {
                    DSPicker("Sort By", selection: $sheetSort, options: ShowcaseSortOrderMac.allCases, mode: .sheet) {
                        Text($0.rawValue)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                }
                
                GroupBox("Navigation Mode") {
                    DSPicker("Sort By", selection: $navSort, options: ShowcaseSortOrderMac.allCases, mode: .navigation) {
                        Text($0.rawValue)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                }
            }
            .frame(maxWidth: .infinity)
            
            // Right column: Options & States
            VStack(alignment: .leading, spacing: 24) {
                GroupBox("With Leading Icon") {
                    DSPicker("Color", selection: $iconColor, options: ShowcaseColorMac.allCases, icon: "paintpalette") {
                        Label($0.rawValue, systemImage: $0.icon)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                }
                
                GroupBox("Disabled State") {
                    DSPicker("Sort By", selection: $disabledSort, options: ShowcaseSortOrderMac.allCases, isDisabled: true) {
                        Text($0.rawValue)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                }
                
                GroupBox("Spec Details") {
                    let spec = theme.resolveField(variant: .default, state: .normal)
                    VStack(spacing: 6) {
                        specRow("Height", "\(Int(spec.height)) pt")
                        specRow("Corner Radius", "\(Int(spec.cornerRadius)) pt")
                        specRow("H Padding", "\(Int(spec.horizontalPadding)) pt")
                        specRow("Border Width", String(format: "%.1f pt", spec.borderWidth))
                        specRow("Resolved Presentation", capabilities.preferredPickerPresentation.rawValue)
                    }
                    .padding(8)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private func specRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundStyle(theme.colors.fg.secondary)
            Spacer()
            Text(value)
                .font(.caption.monospaced())
                .foregroundStyle(theme.colors.fg.primary)
        }
    }
}
