// DSValidationShowcasewatchOSView.swift
// ShowcasewatchOS
//
// watchOS Showcase for Form Validation System: DSValidationView,
// DSFormValidationContext, DSRequiredMarker.

import SwiftUI
import DSCore
import DSTheme
import DSForms
import DSPrimitives

struct DSValidationShowcasewatchOSView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // MARK: - Compact States
            
            Text("Compact States")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                DSValidationView(state: .error(message: "Required field"))
                DSValidationView(state: .warning(message: "Weak password"))
                DSValidationView(state: .success(message: "Available"))
                DSValidationView(state: .validating)
            }
            
            Divider()
            
            // MARK: - Banner States
            
            Text("Banner States")
                .font(.headline)
            
            VStack(spacing: 6) {
                DSValidationView(
                    state: .error(message: "Fix errors below."),
                    style: .banner
                )
                DSValidationView(
                    state: .warning(message: "Session expiring soon."),
                    style: .banner
                )
                DSValidationView(
                    state: .success(message: "All good!"),
                    style: .banner
                )
            }
            
            Divider()
            
            // MARK: - Required Marker
            
            Text("Required Marker")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 2) {
                    Text("Name")
                    DSRequiredMarker(size: .small)
                }
                HStack(spacing: 2) {
                    Text("Email")
                    DSRequiredMarker()
                }
                DSText("Phone", role: .rowTitle)
                    .dsRequired(true)
            }
            
            Divider()
            
            // MARK: - Interactive Demo
            
            Text("Interactive")
                .font(.headline)
            
            WatchValidationDemo()
        }
    }
}

// MARK: - Watch Validation Demo

private struct WatchValidationDemo: View {
    @StateObject private var validation = DSFormValidationContext()
    @State private var name = ""
    
    var body: some View {
        VStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 2) {
                    Text("Name")
                        .font(.caption)
                    DSRequiredMarker(size: .small)
                }
                
                TextField("Name", text: $name)
                    .onChange(of: name) { _, newValue in
                        validation.validate(newValue, for: "name", rules: [.required])
                    }
                
                DSValidationView(state: validation.effectiveState(for: "name"))
            }
            
            Button("Validate") {
                validation.validate(name, for: "name", rules: [.required])
                validation.validateAll()
            }
            .buttonStyle(.borderedProminent)
            
            Button("Clear") {
                name = ""
                validation.clearAll()
                validation.showValidation = false
            }
        }
    }
}

// MARK: - Previews

#Preview("Validation - watchOS") {
    ScrollView {
        DSValidationShowcasewatchOSView()
            .padding()
    }
    .dsTheme(.dark)
}
