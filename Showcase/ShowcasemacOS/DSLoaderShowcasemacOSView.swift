//
//  DSLoaderShowcasemacOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSPrimitives
import DSTheme

// MARK: - DSLoader Showcase (macOS)

/// macOS Showcase view demonstrating DSLoader and DSProgress primitives
struct DSLoaderShowcasemacOSView: View {
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
        HStack(alignment: .top, spacing: 24) {
            // Left column: DSLoader + Controls
            VStack(alignment: .leading, spacing: 16) {
                // Configuration
                GroupBox("Configuration") {
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Dark Theme", isOn: $isDark)
                        Toggle("Reduce Motion", isOn: $reduceMotion)
                    }
                    .padding(.vertical, 4)
                }
                
                // DSLoader Sizes
                GroupBox("DSLoader — Sizes") {
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
                .dsTheme(theme)
                
                // DSLoader Colors
                GroupBox("DSLoader — Colors") {
                    HStack(spacing: 32) {
                        VStack(spacing: 8) {
                            DSLoader(size: .large, color: .accent)
                            Text("Accent").font(.caption2).foregroundStyle(.secondary)
                        }
                        VStack(spacing: 8) {
                            DSLoader(size: .large, color: .primary)
                            Text("Primary").font(.caption2).foregroundStyle(.secondary)
                        }
                        VStack(spacing: 8) {
                            DSLoader(size: .large, color: .secondary)
                            Text("Secondary").font(.caption2).foregroundStyle(.secondary)
                        }
                        VStack(spacing: 8) {
                            DSLoader(size: .large, color: .custom(.purple))
                            Text("Custom").font(.caption2).foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
                .dsTheme(theme)
                
                // Interactive Progress
                GroupBox("Interactive Progress") {
                    VStack(spacing: 12) {
                        HStack(spacing: 16) {
                            DSProgress(value: progressValue, style: .circular, size: .large)
                            VStack(alignment: .leading, spacing: 4) {
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
                .dsTheme(theme)
            }
            .frame(maxWidth: .infinity)
            
            // Right column: DSProgress
            VStack(alignment: .leading, spacing: 16) {
                // Linear sizes
                GroupBox("DSProgress — Linear") {
                    VStack(spacing: 12) {
                        ForEach(DSProgressSize.allCases) { size in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(size.displayName)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                DSProgress(value: 0.6, style: .linear, size: size)
                            }
                        }
                        
                        Divider()
                        
                        // Values
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
                .dsTheme(theme)
                
                // Circular sizes
                GroupBox("DSProgress — Circular") {
                    HStack(spacing: 24) {
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
                .dsTheme(theme)
                
                // Colors
                GroupBox("DSProgress — Colors") {
                    VStack(spacing: 8) {
                        DSProgress(value: 0.6, style: .linear, color: .accent)
                        DSProgress(value: 0.6, style: .linear, color: .primary)
                        DSProgress(value: 0.6, style: .linear, color: .secondary)
                        DSProgress(value: 0.6, style: .linear, color: .custom(.green))
                        
                        Divider()
                        
                        HStack(spacing: 16) {
                            DSProgress(value: 0.7, style: .circular, size: .small, color: .accent)
                            DSProgress(value: 0.7, style: .circular, size: .small, color: .primary)
                            DSProgress(value: 0.7, style: .circular, size: .small, color: .custom(.green))
                            DSProgress(value: 0.7, style: .circular, size: .small, color: .custom(.orange))
                        }
                    }
                    .padding(.vertical, 4)
                }
                .dsTheme(theme)
                
                // In Context
                GroupBox("In Context") {
                    VStack(alignment: .leading, spacing: 12) {
                        // Loading button
                        HStack(spacing: 8) {
                            DSLoader(size: .small, color: .custom(.white))
                            Text("Loading...")
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(theme.colors.accent.primary, in: RoundedRectangle(cornerRadius: 8))
                        
                        Divider()
                        
                        // Download row
                        HStack(spacing: 12) {
                            DSProgress(value: 0.65, style: .circular, size: .small, color: .accent)
                            VStack(alignment: .leading, spacing: 2) {
                                DSText("Downloading update...", role: .rowTitle)
                                DSText("65% — 12 MB / 18 MB", role: .helperText)
                            }
                            Spacer()
                        }
                        
                        // Upload row
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                DSText("Uploading photo.jpg", role: .rowTitle)
                                Spacer()
                                DSText("80%", role: .helperText)
                            }
                            DSProgress(value: 0.8, style: .linear, size: .small, color: .accent)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .dsTheme(theme)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview("DSLoader macOS") {
    ScrollView {
        DSLoaderShowcasemacOSView()
            .padding()
    }
    .frame(width: 900, height: 700)
}
