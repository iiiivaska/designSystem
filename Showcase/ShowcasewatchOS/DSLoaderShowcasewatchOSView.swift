//
//  DSLoaderShowcasewatchOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSPrimitives

// MARK: - DSLoader Showcase (watchOS)

/// Compact watchOS showcase for DSLoader and DSProgress
struct DSLoaderShowcasewatchOSView: View {
    @State private var progressValue: Double = 0.65
    
    var body: some View {
        VStack(spacing: 12) {
            // DSLoader sizes
            Text("DSLoader")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                ForEach(DSLoaderSize.allCases) { size in
                    VStack(spacing: 4) {
                        DSLoader(size: size)
                        Text("\(Int(size.points))")
                            .font(.system(size: 9))
                            .foregroundStyle(.tertiary)
                    }
                }
            }
            
            Divider()
                .padding(.vertical, 4)
            
            // DSLoader colors
            Text("Colors")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 16) {
                DSLoader(size: .medium, color: .accent)
                DSLoader(size: .medium, color: .primary)
                DSLoader(size: .medium, color: .secondary)
            }
            
            Divider()
                .padding(.vertical, 4)
            
            // Linear progress
            Text("Linear Progress")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            ForEach(DSProgressSize.allCases) { size in
                DSProgress(value: 0.6, style: .linear, size: size)
            }
            
            Divider()
                .padding(.vertical, 4)
            
            // Circular progress
            Text("Circular Progress")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                ForEach(DSProgressSize.allCases) { size in
                    DSProgress(value: 0.7, style: .circular, size: size)
                }
            }
            
            Divider()
                .padding(.vertical, 4)
            
            // In context
            Text("In Context")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 8) {
                DSProgress(value: progressValue, style: .circular, size: .small, color: .accent)
                VStack(alignment: .leading, spacing: 2) {
                    DSText("Downloading...", role: .footnote)
                    DSText("\(Int(progressValue * 100))%", role: .helperText)
                }
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    DSText("Upload", role: .footnote)
                    Spacer()
                    DSText("80%", role: .helperText)
                }
                DSProgress(value: 0.8, style: .linear, size: .small)
            }
        }
    }
}

#Preview("DSLoader watchOS") {
    NavigationStack {
        ScrollView {
            DSLoaderShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("DSLoader")
    }
}
