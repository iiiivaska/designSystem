//
//  DSSurfaceShowcasewatchOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSPrimitives

// MARK: - DSSurface Showcase (watchOS)

/// Compact watchOS showcase for DSSurface
struct DSSurfaceShowcasewatchOSView: View {
    var body: some View {
        VStack(spacing: 12) {
            // Surface Roles
            Text("Surface Roles")
                .font(.caption2)
                .foregroundStyle(.secondary)

            DSSurface(.canvas) {
                VStack(spacing: 0) {
                    ForEach(DSSurfaceRole.allCases) { role in
                        DSSurface(role) {
                            HStack {
                                DSText(role.displayName, role: .footnote)
                                Spacer()
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                        }
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            // Stroke demo
            Text("With Stroke")
                .font(.caption2)
                .foregroundStyle(.secondary)

            DSSurface(.card, stroke: true, cornerRadius: 10) {
                DSText("Card with border", role: .footnote)
                    .padding(8)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}
