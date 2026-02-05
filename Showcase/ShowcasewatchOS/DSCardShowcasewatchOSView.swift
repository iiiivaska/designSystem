//
//  DSCardShowcasewatchOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSTheme
import DSPrimitives

// MARK: - DSCard Showcase (watchOS)

/// Compact watchOS showcase for DSCard
struct DSCardShowcasewatchOSView: View {
    @Environment(\.dsTheme) private var theme

    var body: some View {
        VStack(spacing: 12) {
            // All elevations
            Text("Elevations")
                .font(.caption2)
                .foregroundStyle(.secondary)

            ZStack {
                (theme.isDark ? Color(hex: "#0B0E14") : Color(hex: "#F7F8FA"))
                VStack(spacing: 8) {
                    ForEach(DSCardElevation.allCases, id: \.self) { elevation in
                        DSCard(elevation) {
                            DSText(elevation.rawValue.capitalized, role: .footnote)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            // DSDivider demo
            Text("DSDivider")
                .font(.caption2)
                .foregroundStyle(.secondary)

            DSCard(.raised) {
                VStack(spacing: 0) {
                    DSText("Item 1", role: .footnote)
                        .padding(.vertical, 6)
                    DSDivider()
                    DSText("Item 2", role: .footnote)
                        .padding(.vertical, 6)
                    DSDivider()
                    DSText("Item 3", role: .footnote)
                        .padding(.vertical, 6)
                }
            }
        }
    }
}

#Preview("DSSurface watchOS") {
    NavigationStack {
        ScrollView {
            DSSurfaceShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("DSSurface")
    }
}

#Preview("DSCard watchOS") {
    NavigationStack {
        ScrollView {
            DSCardShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("DSCard")
    }
}
