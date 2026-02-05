//
//  ShowcaseSortOrder.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSControls

// MARK: - DSPicker Showcase

/// Demo option type for picker showcases.
private enum ShowcaseSortOrder: String, CaseIterable, Identifiable, Sendable {
    case nameAsc = "Name (A-Z)"
    case nameDesc = "Name (Z-A)"
    case dateNewest = "Date (Newest)"
    case dateOldest = "Date (Oldest)"
    case sizeSmall = "Size (Smallest)"
    case sizeLarge = "Size (Largest)"
    
    var id: String { rawValue }
}

private enum ShowcaseColor: String, CaseIterable, Identifiable, Sendable {
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

/// Showcase view demonstrating DSPicker control on iOS
struct DSPickerShowcaseView: View {
    @Environment(\.dsTheme) private var theme
    @Environment(\.dsCapabilities) private var capabilities
    
    @State private var autoSort = ShowcaseSortOrder.nameAsc
    @State private var menuSort = ShowcaseSortOrder.dateNewest
    @State private var sheetSort = ShowcaseSortOrder.sizeSmall
    @State private var popoverSort = ShowcaseSortOrder.nameDesc
    @State private var navSort = ShowcaseSortOrder.dateOldest
    @State private var disabledSort = ShowcaseSortOrder.nameAsc
    @State private var autoColor = ShowcaseColor.blue
    @State private var iconColor = ShowcaseColor.green
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            // MARK: Auto Mode
            sectionHeader("Auto Mode (Platform Default)")
            Text("Resolves to: \(capabilities.preferredPickerPresentation.rawValue)")
                .font(.caption)
                .foregroundStyle(theme.colors.fg.tertiary)
            
            DSPicker("Sort By", selection: $autoSort, options: ShowcaseSortOrder.allCases) {
                Text($0.rawValue)
            }
            
            DSPicker("Favorite Color", selection: $autoColor, options: ShowcaseColor.allCases, icon: "paintpalette") {
                Text($0.rawValue)
            }
            
            // MARK: Menu Mode
            sectionHeader("Menu Mode")
            
            DSPicker("Sort By", selection: $menuSort, options: ShowcaseSortOrder.allCases, mode: .menu) {
                Text($0.rawValue)
            }
            
            // MARK: Sheet Mode
            sectionHeader("Sheet Mode")
            
            DSPicker("Sort By", selection: $sheetSort, options: ShowcaseSortOrder.allCases, mode: .sheet) {
                Text($0.rawValue)
            }
            
            // MARK: Popover Mode
            sectionHeader("Popover Mode")
            
            DSPicker("Sort By", selection: $popoverSort, options: ShowcaseSortOrder.allCases, mode: .popover) {
                Text($0.rawValue)
            }
            
            // MARK: Navigation Mode
            sectionHeader("Navigation Mode")
            
            DSPicker("Sort By", selection: $navSort, options: ShowcaseSortOrder.allCases, mode: .navigation) {
                Text($0.rawValue)
            }
            
            // MARK: With Icon
            sectionHeader("With Leading Icon")
            
            DSPicker("Color", selection: $iconColor, options: ShowcaseColor.allCases, icon: "paintpalette") {
                Label($0.rawValue, systemImage: $0.icon)
            }
            
            // MARK: Disabled
            sectionHeader("Disabled State")
            
            DSPicker("Sort By", selection: $disabledSort, options: ShowcaseSortOrder.allCases, isDisabled: true) {
                Text($0.rawValue)
            }
            
            // MARK: Spec Details
            sectionHeader("Resolved Spec Details")
            
            let spec = theme.resolveField(variant: .default, state: .normal)
            VStack(spacing: 8) {
                specRow("Height", "\(Int(spec.height)) pt")
                specRow("Corner Radius", "\(Int(spec.cornerRadius)) pt")
                specRow("H Padding", "\(Int(spec.horizontalPadding)) pt")
                specRow("Border Width", String(format: "%.1f pt", spec.borderWidth))
                specRow("Resolved Presentation", capabilities.preferredPickerPresentation.rawValue)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(theme.colors.bg.surface)
            )
        }
    }
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(theme.colors.fg.primary)
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
