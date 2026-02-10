// DSValidationShowcasemacOSView.swift
// ShowcasemacOS
//
// macOS Showcase for Form Validation System: DSValidationView, DSFormValidationContext,
// DSValidationSummary, DSFormValidatedRow, and DSRequiredMarker.

import SwiftUI
import DSCore
import DSTheme
import DSForms
import DSControls
import DSPrimitives

struct DSValidationShowcasemacOSView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            // MARK: - Light Theme
            
            GroupBox("Light Theme") {
                validationContent
                    .dsTheme(.light)
            }
            
            // MARK: - Dark Theme
            
            GroupBox("Dark Theme") {
                validationContent
                    .dsTheme(.dark)
                    .preferredColorScheme(.dark)
            }
        }
    }
    
    private var validationContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // MARK: - Compact States
            
            Text("DSValidationView — Compact")
                .font(.headline)
            
            HStack(spacing: 24) {
                DSValidationView(state: .error(message: "This field is required"))
                DSValidationView(state: .warning(message: "Weak password"))
                DSValidationView(state: .success(message: "Available"))
                DSValidationView(state: .validating)
            }
            
            Divider()
            
            // MARK: - Banner States
            
            Text("DSValidationView — Banner")
                .font(.headline)
            
            VStack(spacing: 8) {
                DSValidationView(
                    state: .error(message: "Please fix the errors below before submitting."),
                    style: .banner
                )
                DSValidationView(
                    state: .warning(message: "Your session will expire in 5 minutes."),
                    style: .banner
                )
                DSValidationView(
                    state: .success(message: "All changes saved successfully."),
                    style: .banner
                )
            }
            
            Divider()
            
            // MARK: - Required Marker
            
            Text("DSRequiredMarker")
                .font(.headline)
            
            HStack(spacing: 32) {
                ForEach(DSRequiredMarkerSize.allCases, id: \.rawValue) { size in
                    VStack(spacing: 4) {
                        HStack(spacing: 2) {
                            Text("Label")
                            DSRequiredMarker(size: size)
                        }
                        Text(size.rawValue)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                VStack(spacing: 4) {
                    DSText("With modifier", role: .rowTitle)
                        .dsRequired(true)
                    Text(".dsRequired(true)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Divider()
            
            // MARK: - Interactive Demo
            
            Text("Interactive Form Validation")
                .font(.headline)
            
            InteractiveValidationDemomacOS()
            
            Divider()
            
            // MARK: - Validation Summary
            
            Text("Validation Summary")
                .font(.headline)
            
            ValidationSummaryDemomacOS()
            
            Divider()
            
            // MARK: - Validated Rows (Two-Column)
            
            Text("DSFormValidatedRow — Two-Column")
                .font(.headline)
            
            ValidatedRowsDemomacOS()
        }
    }
}

// MARK: - Interactive Demo

private struct InteractiveValidationDemomacOS: View {
    @StateObject private var validation = DSFormValidationContext()
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 12) {
            // Status
            HStack {
                Label(
                    validation.isFormValid ? "Valid" : "Invalid",
                    systemImage: validation.isFormValid ? "checkmark.circle.fill" : "xmark.circle.fill"
                )
                .foregroundStyle(validation.isFormValid ? .green : .red)
                .font(.caption)
                
                Spacer()
                
                Text("Errors: \(validation.errorCount) | Warnings: \(validation.warningCount)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // Two-column form
            Grid(alignment: .leadingFirstTextBaseline, horizontalSpacing: 12, verticalSpacing: 12) {
                GridRow {
                    HStack(spacing: 2) {
                        Text("Name")
                            .font(.body)
                        DSRequiredMarker()
                    }
                    .frame(width: 120, alignment: .trailing)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Enter name", text: $name)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: name) { _, newValue in
                                validation.validate(newValue, for: "name", rules: [.required])
                            }
                        DSValidationView(state: validation.effectiveState(for: "name"))
                    }
                }
                
                GridRow {
                    HStack(spacing: 2) {
                        Text("Email")
                            .font(.body)
                        DSRequiredMarker()
                    }
                    .frame(width: 120, alignment: .trailing)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("user@example.com", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: email) { _, newValue in
                                validation.validate(newValue, for: "email", rules: [.required, .email])
                            }
                        DSValidationView(state: validation.effectiveState(for: "email"))
                    }
                }
                
                GridRow {
                    Text("Password")
                        .font(.body)
                        .frame(width: 120, alignment: .trailing)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        SecureField("Min 8 characters", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: password) { _, newValue in
                                if !newValue.isEmpty && newValue.count < 8 {
                                    validation.set(.warning(message: "Should be at least 8 characters"), for: "password")
                                } else {
                                    validation.set(.none, for: "password")
                                }
                            }
                        DSValidationView(state: validation.effectiveState(for: "password"))
                    }
                }
            }
            .frame(maxWidth: 500)
            
            HStack {
                Button("Validate All") {
                    validation.validate(name, for: "name", rules: [.required])
                    validation.validate(email, for: "email", rules: [.required, .email])
                    if !password.isEmpty && password.count < 8 {
                        validation.set(.warning(message: "Should be at least 8 characters"), for: "password")
                    }
                    validation.validateAll()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                
                Button("Clear") {
                    name = ""
                    email = ""
                    password = ""
                    validation.clearAll()
                    validation.showValidation = false
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
        }
    }
}

// MARK: - Summary Demo

private struct ValidationSummaryDemomacOS: View {
    @StateObject private var validation = DSFormValidationContext()
    
    var body: some View {
        VStack(spacing: 12) {
            DSValidationSummary(context: validation)
            
            HStack(spacing: 8) {
                Button("Show Errors + Warnings") {
                    validation.set(.error(message: "Name is required"), for: "name")
                    validation.set(.error(message: "Invalid email format"), for: "email")
                    validation.set(.warning(message: "Weak password"), for: "password")
                    validation.showValidation = true
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                
                Button("Errors Only") {
                    validation.clearAll()
                    validation.set(.error(message: "Username already taken"), for: "username")
                    validation.showValidation = true
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                
                Button("Clear") {
                    validation.clearAll()
                    validation.showValidation = false
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
        }
        .frame(maxWidth: 500)
    }
}

// MARK: - Validated Rows Demo

private struct ValidatedRowsDemomacOS: View {
    @StateObject private var validation = DSFormValidationContext()
    @State private var name = ""
    @State private var email = ""
    
    var body: some View {
        VStack(spacing: 8) {
            DSFormValidatedRow("Full Name", fieldId: "name", isRequired: true, layout: .twoColumn) {
                TextField("Enter name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: name) { _, newValue in
                        validation.validate(newValue, for: "name", rules: [.required])
                    }
            }
            
            DSFormValidatedRow("Email", fieldId: "email", isRequired: true, layout: .twoColumn) {
                TextField("user@example.com", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: email) { _, newValue in
                        validation.validate(newValue, for: "email", rules: [.required, .email])
                    }
            }
            
            Button("Submit") {
                validation.validate(name, for: "name", rules: [.required])
                validation.validate(email, for: "email", rules: [.required, .email])
                validation.validateAll()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
        }
        .frame(maxWidth: 500)
        .dsFormValidation(validation)
    }
}

// MARK: - Previews

#Preview("Validation Showcase - macOS") {
    ScrollView {
        DSValidationShowcasemacOSView()
            .padding()
    }
    .frame(minWidth: 700, minHeight: 800)
}
