//
//  DSSurfaceShowcasemacOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSPrimitives

// MARK: - DSSurface Showcase (macOS)

/// macOS showcase for DSSurface primitive
struct DSSurfaceShowcasemacOSView: View {
    @Environment(\.dsTheme) private var theme
    @State private var showStroke = false

    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            // Configuration
            VStack(alignment: .leading, spacing: 16) {
                GroupBox("Configuration") {
                    Toggle("Show Stroke", isOn: $showStroke)
                        .padding(.vertical, 4)
                }

                GroupBox("Surface Roles") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(DSSurfaceRole.allCases) { role in
                            HStack {
                                Circle()
                                    .fill(role.resolveColor(from: theme))
                                    .frame(width: 16, height: 16)
                                    .overlay(
                                        Circle().stroke(Color.secondary.opacity(0.3), lineWidth: 0.5)
                                    )
                                Text(role.displayName)
                                    .font(.callout)
                                Spacer()
                                Text(".\(role.rawValue)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .frame(width: 250)

            // Preview
            VStack(alignment: .leading, spacing: 16) {
                GroupBox("Surface Layering") {
                    DSSurface(.canvas) {
                        VStack(spacing: 0) {
                            ForEach(DSSurfaceRole.allCases) { role in
                                DSSurface(role, stroke: showStroke) {
                                    HStack {
                                        DSText(role.displayName, role: .rowTitle)
                                        Spacer()
                                        DSText(verbatim: ".\(role.rawValue)", role: .helperText)
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }

                GroupBox("Nested Surfaces") {
                    DSSurface(.canvas) {
                        HStack(spacing: 16) {
                            DSSurface(.surface, stroke: showStroke, cornerRadius: 10) {
                                VStack(spacing: 8) {
                                    DSSurface(.card, stroke: true, cornerRadius: 8) {
                                        DSText("Card", role: .rowTitle)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                    }
                                    DSSurface(.surfaceElevated, stroke: true, cornerRadius: 8) {
                                        DSText("Elevated", role: .rowTitle)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                                .padding()
                            }
                            DSSurface(.surfaceElevated, cornerRadius: 10) {
                                VStack(spacing: 8) {
                                    DSSurface(.card, stroke: true, cornerRadius: 8) {
                                        DSText("Card", role: .rowTitle)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                                .padding()
                            }
                        }
                        .padding()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
        }
    }
}
