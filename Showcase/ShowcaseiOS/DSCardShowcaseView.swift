//
//  DSCardShowcaseView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSPrimitives
import DSTheme

/// Showcase view demonstrating DSCard primitive
struct DSCardShowcaseView: View {
    @Environment(\.dsTheme) private var theme
    @State private var selectedElevation: DSCardElevation = .raised

    private var isDark: Bool { theme.isDark }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {

            // Controls
            Picker("Elevation", selection: $selectedElevation) {
                ForEach(DSCardElevation.allCases, id: \.self) { elevation in
                    Text(elevation.rawValue.capitalized).tag(elevation)
                }
            }
            .pickerStyle(.segmented)

            Divider()

            // All Elevations
            Text("All Elevation Levels")
                .font(.title2)
                .fontWeight(.semibold)

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
                                let spec = theme.resolveCard(elevation: elevation)
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("r: \(String(format: "%.1f", spec.shadow.radius))")
                                        .font(.caption2)
                                    Text("glass: \(spec.usesGlassEffect ? "yes" : "no")")
                                        .font(.caption2)
                                }
                                .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .padding()
            }
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            Divider()

            // Selected Elevation Detail
            Text("Selected: \(selectedElevation.rawValue.capitalized)")
                .font(.title2)
                .fontWeight(.semibold)

            ZStack {
                (isDark ? Color(hex: "#0B0E14") : Color(hex: "#F7F8FA"))

                DSCard(selectedElevation) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                            DSText("Sample Card", role: .headline)
                            Spacer()
                        }
                        DSText("This card uses the .\(selectedElevation.rawValue) elevation level. Use the theme toggle to see glass effects on elevated/overlay cards.", role: .body)
                        DSDivider()
                        HStack {
                            DSText("Learn more", role: .callout)
                                .dsTextColor(theme.colors.accent.primary)
                            Spacer()
                            DSIcon(DSIconToken.Navigation.chevronRight, size: .small, color: .secondary)
                        }
                    }
                }
                .padding()
            }
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            Divider()

            // Glass Effect Comparison
            Text("Light vs Dark Comparison")
                .font(.title2)
                .fontWeight(.semibold)

            HStack(spacing: 12) {
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
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

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
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }

            Divider()

            // DSDivider in context
            Text("DSDivider")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Themed horizontal and vertical dividers.")
                .font(.callout)
                .foregroundStyle(.secondary)

            ZStack {
                (isDark ? Color(hex: "#0B0E14") : Color(hex: "#F7F8FA"))

                VStack(spacing: 16) {
                    DSCard(.raised) {
                        VStack(spacing: 0) {
                            rowItem(title: "Horizontal divider", icon: "minus")
                            DSDivider()
                            rowItem(title: "Between items", icon: "line.horizontal.3")
                            DSDivider(insets: 16)
                            rowItem(title: "With insets", icon: "arrow.left.and.right")
                        }
                    }

                    DSCard(.raised) {
                        HStack(spacing: 16) {
                            Text("Left")
                            DSDivider(.vertical)
                            Text("Center")
                            DSDivider(.vertical)
                            Text("Right")
                        }
                        .frame(height: 44)
                    }
                }
                .padding()
            }
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }

    @ViewBuilder
    private func rowItem(title: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
            Text(title)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 12)
    }
}
