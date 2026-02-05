//
//  DSCardShowcasemacOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSTheme
import DSPrimitives

// MARK: - DSCard Showcase (macOS)

/// macOS showcase for DSCard primitive
struct DSCardShowcasemacOSView: View {
    @Environment(\.dsTheme) private var theme

    private var isDark: Bool { theme.isDark }

    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            // Spec sidebar
            VStack(alignment: .leading, spacing: 16) {
                GroupBox("Spec Details") {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(DSCardElevation.allCases, id: \.self) { elevation in
                            let spec = theme.resolveCard(elevation: elevation)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(elevation.rawValue.capitalized)
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                HStack(spacing: 12) {
                                    specBadge(label: "radius", value: "\(Int(spec.cornerRadius))")
                                    specBadge(label: "shadow", value: String(format: "%.1f", spec.shadow.radius))
                                    specBadge(label: "glass", value: spec.usesGlassEffect ? "yes" : "no")
                                    specBadge(label: "border", value: String(format: "%.1f", spec.borderWidth))
                                }
                            }
                            if elevation != .overlay { Divider() }
                        }
                    }
                    .padding(.vertical, 4)
                }

                GroupBox("DSDivider") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Themed separator using theme colors.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        VStack(spacing: 8) {
                            Text("Above")
                            DSDivider()
                            Text("Below")
                        }
                        .padding(.vertical, 4)
                        HStack(spacing: 8) {
                            Text("L")
                            DSDivider(.vertical)
                            Text("M")
                            DSDivider(.vertical)
                            Text("R")
                        }
                        .frame(height: 24)
                    }
                    .padding(.vertical, 4)
                }
            }
            .frame(width: 280)

            // Elevation preview
            VStack(alignment: .leading, spacing: 16) {
                GroupBox("Elevation Levels") {
                    ZStack {
                        (isDark ? Color(hex: "#0B0E14") : Color(hex: "#F7F8FA"))

                        VStack(spacing: 20) {
                            ForEach(DSCardElevation.allCases, id: \.self) { elevation in
                                DSCard(elevation) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            DSText(elevation.rawValue.capitalized, role: .headline)
                                            DSText(verbatim: "DSCard(.\(elevation.rawValue))", role: .helperText)
                                        }
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }

                GroupBox("Light vs Dark") {
                    HStack(spacing: 16) {
                        ZStack {
                            Color(hex: "#F7F8FA")
                            VStack(spacing: 12) {
                                Text("Light").font(.caption).fontWeight(.semibold)
                                ForEach(DSCardElevation.allCases, id: \.self) { elevation in
                                    DSCard(elevation) {
                                        Text(elevation.rawValue.capitalized)
                                            .font(.caption)
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                            }
                            .padding(12)
                        }
                        .dsTheme(.light)
                        .environment(\.colorScheme, .light)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                        ZStack {
                            Color(hex: "#0B0E14")
                            VStack(spacing: 12) {
                                Text("Dark").font(.caption).fontWeight(.semibold)
                                ForEach(DSCardElevation.allCases, id: \.self) { elevation in
                                    DSCard(elevation) {
                                        Text(elevation.rawValue.capitalized)
                                            .font(.caption)
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                            }
                            .padding(12)
                        }
                        .dsTheme(.dark)
                        .environment(\.colorScheme, .dark)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                }

                GroupBox("Card with Content") {
                    ZStack {
                        (isDark ? Color(hex: "#0B0E14") : Color(hex: "#F7F8FA"))

                        DSCard(.raised) {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(.yellow)
                                    DSText("Featured", role: .headline)
                                    Spacer()
                                }
                                DSText("Sample card with rich content demonstrating DSCard + DSDivider.", role: .body)
                                DSDivider()
                                HStack {
                                    DSText("Action", role: .callout)
                                        .dsTextColor(theme.colors.accent.primary)
                                    Spacer()
                                    DSIcon(DSIconToken.Navigation.chevronRight, size: .small, color: .secondary)
                                }
                            }
                        }
                        .padding()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
        }
    }

    @ViewBuilder
    private func specBadge(label: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(value).font(.caption2).fontWeight(.semibold)
            Text(label).font(.caption2).foregroundStyle(.secondary)
        }
    }
}

#Preview("DSSurface macOS") {
    ScrollView {
        DSSurfaceShowcasemacOSView()
            .padding()
    }
    .frame(width: 900, height: 600)
}

#Preview("DSCard macOS") {
    ScrollView {
        DSCardShowcasemacOSView()
            .padding()
    }
    .frame(width: 900, height: 700)
}
