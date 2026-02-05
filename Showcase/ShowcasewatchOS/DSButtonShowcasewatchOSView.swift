//
//  DSButtonShowcasewatchOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSTheme
import DSControls

// MARK: - DSButton Showcase (watchOS)

/// Compact watchOS showcase for DSButton
struct DSButtonShowcasewatchOSView: View {
    @State private var tapCount = 0
    
    var body: some View {
        VStack(spacing: 12) {
            // Variants
            Text("Variants")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            ForEach(DSButtonVariant.allCases, id: \.rawValue) { variant in
                DSButton(
                    LocalizedStringKey(variant.rawValue.capitalized),
                    variant: variant,
                    size: .small,
                    fullWidth: true
                ) { }
            }
            
            Divider()
                .padding(.vertical, 4)
            
            // Sizes
            Text("Sizes")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            ForEach(DSButtonSize.allCases, id: \.rawValue) { size in
                DSButton(
                    LocalizedStringKey(size.rawValue.capitalized),
                    variant: .primary,
                    size: size,
                    fullWidth: true
                ) { }
            }
            
            Divider()
                .padding(.vertical, 4)
            
            // States
            Text("States")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSButton("Normal", size: .small, fullWidth: true) { }
            DSButton("Disabled", size: .small, isDisabled: true, fullWidth: true) { }
            DSButton("Loading", size: .small, isLoading: true, fullWidth: true) { }
            
            Divider()
                .padding(.vertical, 4)
            
            // Icons
            Text("With Icons")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSButton("Save", icon: "checkmark", variant: .primary, size: .small, fullWidth: true) { }
            DSButton("Delete", icon: "trash", variant: .destructive, size: .small, fullWidth: true) { }
            
            Divider()
                .padding(.vertical, 4)
            
            // Interactive
            Text("Interactive")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSButton("Tap (\(tapCount))", icon: "hand.tap", variant: .primary, size: .medium, fullWidth: true) {
                tapCount += 1
            }
        }
        .dsTheme(.dark)
    }
}

#Preview("DSButton watchOS") {
    NavigationStack {
        ScrollView {
            DSButtonShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("DSButton")
    }
}
