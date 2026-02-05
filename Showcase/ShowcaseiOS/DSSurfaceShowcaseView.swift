//
//  DSSurfaceShowcaseView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSPrimitives

// MARK: - DSSurface Showcase

/// Showcase view demonstrating DSSurface primitive
struct DSSurfaceShowcaseView: View {
    @Environment(\.dsTheme) private var theme
    @State private var showStroke = false

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {

            // Controls
            Toggle("Show Stroke", isOn: $showStroke)

            Divider()

            // Surface Roles
            Text("Surface Roles")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Each role maps to a theme background color. The layering creates visual depth.")
                .font(.callout)
                .foregroundStyle(.secondary)

            DSSurface(.canvas) {
                VStack(spacing: 0) {
                    ForEach(DSSurfaceRole.allCases) { role in
                        DSSurface(role, stroke: showStroke) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    DSText(role.displayName, role: .rowTitle)
                                    DSText(verbatim: ".\(role.rawValue)", role: .helperText)
                                }
                                Spacer()
                            }
                            .padding()
                        }
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.secondary.opacity(0.2))
            )

            Divider()

            // Nested Surfaces
            Text("Nested Surfaces")
                .font(.title2)
                .fontWeight(.semibold)

            DSSurface(.canvas) {
                VStack(spacing: 12) {
                    DSSurface(.surface, stroke: showStroke, cornerRadius: 14) {
                        VStack(spacing: 8) {
                            DSSurface(.card, stroke: true, cornerRadius: 10) {
                                HStack {
                                    DSText("Card on Surface", role: .rowTitle)
                                    Spacer()
                                }
                                .padding()
                            }
                            DSSurface(.surfaceElevated, stroke: true, cornerRadius: 10) {
                                HStack {
                                    DSText("Elevated on Surface", role: .rowTitle)
                                    Spacer()
                                }
                                .padding()
                            }
                        }
                        .padding()
                    }
                }
                .padding()
            }
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
}
