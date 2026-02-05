//
//  DSIconShowcasewatchOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSPrimitives

// MARK: - DSIcon Showcase (watchOS)

/// Compact showcase view for DSIcon on watchOS
struct DSIconShowcasewatchOSView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Sizes")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                ForEach(DSIconSize.allCases) { size in
                    VStack(spacing: 4) {
                        DSIcon("star.fill", size: size, color: .accent)
                        Text("\(Int(size.points))")
                            .font(.system(size: 9))
                            .foregroundStyle(.tertiary)
                    }
                }
            }
            
            Divider()
                .padding(.vertical, 4)
            
            Text("Colors")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                DSIcon("circle.fill", size: .medium, color: .primary)
                DSIcon("circle.fill", size: .medium, color: .secondary)
                DSIcon("circle.fill", size: .medium, color: .accent)
                DSIcon("circle.fill", size: .medium, color: .success)
                DSIcon("circle.fill", size: .medium, color: .danger)
            }
            
            Divider()
                .padding(.vertical, 4)
            
            Text("Tokens")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                DSIcon(DSIconToken.Navigation.chevronRight, size: .small)
                DSIcon(DSIconToken.Action.plus, size: .small, color: .accent)
                DSIcon(DSIconToken.State.checkmarkCircle, size: .small, color: .success)
                DSIcon(DSIconToken.State.warning, size: .small, color: .warning)
                DSIcon(DSIconToken.Action.delete, size: .small, color: .danger)
            }
            
            Divider()
                .padding(.vertical, 4)
            
            Text("Inline")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 6) {
                DSIcon(DSIconToken.State.checkmarkCircle, size: .small, color: .success)
                DSText("Verified", role: .footnote)
            }
            
            HStack(spacing: 6) {
                DSIcon(DSIconToken.State.warning, size: .small, color: .warning)
                DSText("Warning", role: .footnote)
            }
        }
        .dsTheme(.dark)
    }
}

#Preview("DSIcon watchOS") {
    NavigationStack {
        ScrollView {
            DSIconShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("DSIcon")
    }
}
