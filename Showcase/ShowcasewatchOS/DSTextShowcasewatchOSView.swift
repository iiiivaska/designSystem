//
//  DSTextShowcasewatchOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSPrimitives

// MARK: - DSText Showcase (watchOS)

/// Compact showcase view for DSText on watchOS
struct DSTextShowcasewatchOSView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Show a subset of system roles (compact)
            Text("System")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSText("Large Title", role: .largeTitle)
            DSText("Title 2", role: .title2)
            DSText("Headline", role: .headline)
            DSText("Body", role: .body)
            DSText("Callout", role: .callout)
            DSText("Footnote", role: .footnote)
            DSText("Caption 1", role: .caption1)
            
            Divider()
                .padding(.vertical, 4)
            
            Text("Component")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSText("Button Label", role: .buttonLabel)
            DSText("Row Title", role: .rowTitle)
            DSText("Row Value", role: .rowValue)
            DSText("Section Header", role: .sectionHeader)
            DSText("v1.2.3", role: .monoText)
            
            Divider()
                .padding(.vertical, 4)
            
            Text("Overrides")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSText("Accent color", role: .body)
                .dsTextColor(.teal)
            DSText("Bold body", role: .body)
                .dsTextWeight(.bold)
        }
        .dsTheme(.dark)
    }
}

#Preview("DSText watchOS") {
    NavigationStack {
        ScrollView {
            DSTextShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("DSText")
    }
}
