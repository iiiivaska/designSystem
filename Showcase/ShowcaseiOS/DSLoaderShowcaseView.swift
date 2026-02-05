//
//  DSLoaderShowcaseView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSTheme
import DSPrimitives

// MARK: - DSLoader Showcase

/// Showcase view demonstrating DSLoader and DSProgress primitives
struct DSLoaderShowcaseView: View {
    @State private var isDark = false
    @State private var reduceMotion = false
    @State private var progressValue: Double = 0.6
    
    private var theme: DSTheme {
        DSTheme(
            variant: isDark ? .dark : .light,
            reduceMotion: reduceMotion
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Controls
            Toggle("Dark Theme", isOn: $isDark)
            Toggle("Reduce Motion", isOn: $reduceMotion)
            
            Divider()
            
            // DSLoader section
            loaderSection
            
            Divider()
            
            // DSProgress linear section
            linearProgressSection
            
            Divider()
            
            // DSProgress circular section
            circularProgressSection
            
            Divider()
            
            // Interactive progress
            interactiveProgressSection
            
            Divider()
            
            // In-context examples
            inContextSection
        }
        .dsTheme(theme)
    }
    
    // MARK: - Loader Section
    
    private var loaderSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("DSLoader")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Indeterminate spinner with size and color variants.")
                .font(.callout)
                .foregroundStyle(.secondary)
            
            // Size comparison
            GroupBox("Sizes") {
                HStack(spacing: 32) {
                    ForEach(DSLoaderSize.allCases) { size in
                        VStack(spacing: 8) {
                            DSLoader(size: size)
                            Text(size.rawValue)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            Text("\(Int(size.points))pt")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                                .monospaced()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            
            // Color variants
            GroupBox("Colors") {
                HStack(spacing: 32) {
                    VStack(spacing: 8) {
                        DSLoader(size: .large, color: .accent)
                        Text("Accent")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    VStack(spacing: 8) {
                        DSLoader(size: .large, color: .primary)
                        Text("Primary")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    VStack(spacing: 8) {
                        DSLoader(size: .large, color: .secondary)
                        Text("Secondary")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    VStack(spacing: 8) {
                        DSLoader(size: .large, color: .custom(.purple))
                        Text("Custom")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
        }
    }
    
    // MARK: - Linear Progress Section
    
    private var linearProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("DSProgress — Linear")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Horizontal progress bar with size variants.")
                .font(.callout)
                .foregroundStyle(.secondary)
            
            GroupBox("Sizes") {
                VStack(spacing: 12) {
                    ForEach(DSProgressSize.allCases) { size in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(size.displayName)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            DSProgress(value: 0.6, style: .linear, size: size)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            
            GroupBox("Values") {
                VStack(spacing: 8) {
                    ForEach([0.0, 0.25, 0.5, 0.75, 1.0], id: \.self) { val in
                        HStack {
                            Text("\(Int(val * 100))%")
                                .font(.caption)
                                .frame(width: 40, alignment: .trailing)
                            DSProgress(value: val, style: .linear, size: .medium)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    // MARK: - Circular Progress Section
    
    private var circularProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("DSProgress — Circular")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Circular progress ring with size variants.")
                .font(.callout)
                .foregroundStyle(.secondary)
            
            GroupBox("Sizes") {
                HStack(spacing: 32) {
                    ForEach(DSProgressSize.allCases) { size in
                        VStack(spacing: 8) {
                            DSProgress(value: 0.7, style: .circular, size: size)
                            Text(size.displayName)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            
            GroupBox("Colors") {
                HStack(spacing: 24) {
                    VStack(spacing: 8) {
                        DSProgress(value: 0.7, style: .circular, size: .medium, color: .accent)
                        Text("Accent")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    VStack(spacing: 8) {
                        DSProgress(value: 0.7, style: .circular, size: .medium, color: .primary)
                        Text("Primary")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    VStack(spacing: 8) {
                        DSProgress(value: 0.7, style: .circular, size: .medium, color: .secondary)
                        Text("Secondary")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    VStack(spacing: 8) {
                        DSProgress(value: 0.7, style: .circular, size: .medium, color: .custom(.green))
                        Text("Custom")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
        }
    }
    
    // MARK: - Interactive Progress
    
    private var interactiveProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Interactive Progress")
                .font(.title2)
                .fontWeight(.semibold)
            
            GroupBox {
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        DSProgress(value: progressValue, style: .circular, size: .large)
                        VStack(alignment: .leading) {
                            Text("\(Int(progressValue * 100))% Complete")
                                .font(.headline)
                            DSProgress(value: progressValue, style: .linear, size: .small)
                        }
                    }
                    
                    Slider(value: $progressValue, in: 0...1, step: 0.05) {
                        Text("Progress")
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    // MARK: - In-Context
    
    private var inContextSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("In Context")
                .font(.title2)
                .fontWeight(.semibold)
            
            // Loading button
            GroupBox("Loading Button") {
                HStack(spacing: 8) {
                    DSLoader(size: .small, color: .custom(.white))
                    Text("Loading...")
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(theme.colors.accent.primary, in: RoundedRectangle(cornerRadius: 10))
                .padding(.vertical, 4)
            }
            
            // Download card
            GroupBox("Download Card") {
                DSCard(.raised) {
                    HStack(spacing: 12) {
                        DSProgress(value: 0.65, style: .circular, size: .small, color: .accent)
                        VStack(alignment: .leading, spacing: 2) {
                            DSText("Downloading update...", role: .rowTitle)
                            DSText("65% complete — 12 MB / 18 MB", role: .helperText)
                        }
                        Spacer()
                    }
                }
                .padding(.vertical, 4)
            }
            
            // Upload progress
            GroupBox("Upload Progress") {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        DSText("Uploading photo.jpg", role: .rowTitle)
                        Spacer()
                        DSText("80%", role: .helperText)
                    }
                    DSProgress(value: 0.8, style: .linear, size: .small, color: .accent)
                }
                .padding(.vertical, 4)
            }
        }
    }
}

#Preview("DSLoader - Light") {
    NavigationStack {
        ScrollView {
            DSLoaderShowcaseView()
                .padding()
        }
        .navigationTitle("DSLoader")
    }
}

#Preview("DSLoader - Dark") {
    NavigationStack {
        ScrollView {
            DSLoaderShowcaseView()
                .padding()
        }
        .navigationTitle("DSLoader")
    }
    .preferredColorScheme(.dark)
}
