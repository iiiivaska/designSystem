// DSValidationShowcaseView.swift
// ShowcaseiOS
//
// Showcase for Form Validation System: DSValidationView, DSFormValidationContext,
// DSValidationSummary, DSFormValidatedRow, and DSRequiredMarker.

import SwiftUI
import DSCore
import DSTheme
import DSForms
import DSControls
import DSPrimitives

struct DSValidationShowcaseView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            // MARK: - DSValidationView Compact
            
            GroupBox("DSValidationView — Compact") {
                VStack(alignment: .leading, spacing: 12) {
                    DSValidationView(state: .error(message: "This field is required"))
                    DSValidationView(state: .warning(message: "Password strength is weak"))
                    DSValidationView(state: .success(message: "Username is available"))
                    DSValidationView(state: .validating)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // MARK: - DSValidationView Banner
            
            GroupBox("DSValidationView — Banner") {
                VStack(spacing: 12) {
                    DSValidationView(
                        state: .error(message: "Please correct the errors below before submitting."),
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
            }
            
            // MARK: - DSRequiredMarker
            
            GroupBox("DSRequiredMarker") {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(DSRequiredMarkerSize.allCases, id: \.rawValue) { size in
                        HStack(spacing: 4) {
                            Text("Field Label")
                            DSRequiredMarker(size: size)
                            Spacer()
                            Text(size.rawValue)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Divider()
                    
                    Text("Using .dsRequired() modifier:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    DSText("Email Address", role: .rowTitle)
                        .dsRequired(true)
                    
                    DSText("Notes (optional)", role: .rowTitle)
                        .dsRequired(false)
                }
            }
            
            // MARK: - Interactive Validation
            
            GroupBox("Interactive Form Validation") {
                InteractiveValidationDemo()
            }
            
            // MARK: - Validation Summary
            
            GroupBox("Validation Summary") {
                ValidationSummaryDemo()
            }
            
            // MARK: - Validated Rows
            
            GroupBox("DSFormValidatedRow") {
                ValidatedRowsDemo()
            }
            
            // MARK: - Display Modes
            
            GroupBox("Validation Display Modes") {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(DSFormValidationDisplayMode.allCases, id: \.rawValue) { mode in
                        HStack {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 6))
                                .foregroundStyle(.secondary)
                            Text(mode.rawValue)
                                .font(.body)
                            Spacer()
                            Text(modeDescription(mode))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }
    
    private func modeDescription(_ mode: DSFormValidationDisplayMode) -> String {
        switch mode {
        case .inline: return "Next to control"
        case .below: return "Below the row"
        case .summary: return "Top summary banner"
        case .hidden: return "Border colors only"
        }
    }
}

// MARK: - Interactive Validation Demo

private struct InteractiveValidationDemo: View {
    @StateObject private var validation = DSFormValidationContext()
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 16) {
            // Status bar
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
            
            // Fields
            VStack(alignment: .leading, spacing: 12) {
                fieldRow(title: "Name", placeholder: "Enter your name", text: $name, fieldId: "name", isRequired: true) {
                    validation.validate($0, for: "name", rules: [.required])
                }
                
                fieldRow(title: "Email", placeholder: "user@example.com", text: $email, fieldId: "email", isRequired: true) {
                    validation.validate($0, for: "email", rules: [.required, .email])
                }
                
                fieldRow(title: "Password", placeholder: "Min 8 characters", text: $password, fieldId: "password", isRequired: false) {
                    if !$0.isEmpty && $0.count < 8 {
                        validation.set(.warning(message: "Password should be at least 8 characters"), for: "password")
                    } else {
                        validation.set(.none, for: "password")
                    }
                }
            }
            
            // Actions
            HStack {
                Button("Validate All") {
                    validation.validate(name, for: "name", rules: [.required])
                    validation.validate(email, for: "email", rules: [.required, .email])
                    if !password.isEmpty && password.count < 8 {
                        validation.set(.warning(message: "Password should be at least 8 characters"), for: "password")
                    }
                    validation.validateAll()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                
                Button("Clear All") {
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
    
    private func fieldRow(
        title: String,
        placeholder: String,
        text: Binding<String>,
        fieldId: String,
        isRequired: Bool,
        validate: @escaping (String) -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 2) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                if isRequired {
                    DSRequiredMarker(size: .small)
                }
            }
            
            TextField(placeholder, text: text)
                .textFieldStyle(.roundedBorder)
                .onChange(of: text.wrappedValue) { _, newValue in
                    validate(newValue)
                }
            
            DSValidationView(state: validation.effectiveState(for: fieldId))
        }
    }
}

// MARK: - Validation Summary Demo

private struct ValidationSummaryDemo: View {
    @StateObject private var validation = DSFormValidationContext()
    
    var body: some View {
        VStack(spacing: 12) {
            DSValidationSummary(context: validation)
            
            HStack(spacing: 8) {
                Button("Show Errors") {
                    validation.set(.error(message: "Name is required"), for: "name")
                    validation.set(.error(message: "Invalid email format"), for: "email")
                    validation.set(.warning(message: "Weak password"), for: "password")
                    validation.showValidation = true
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                
                Button("Errors Only") {
                    validation.clearAll()
                    validation.set(.error(message: "Username is taken"), for: "username")
                    validation.set(.error(message: "Email is required"), for: "email")
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
    }
}

// MARK: - Validated Rows Demo

private struct ValidatedRowsDemo: View {
    @StateObject private var validation = DSFormValidationContext()
    @State private var name = ""
    @State private var email = ""
    
    var body: some View {
        VStack(spacing: 12) {
            DSFormValidatedRow("Full Name", fieldId: "name", isRequired: true, layout: .stacked) {
                TextField("Enter your full name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: name) { _, newValue in
                        validation.validate(newValue, for: "name", rules: [.required])
                    }
            }
            
            DSFormValidatedRow("Email", fieldId: "email", isRequired: true, layout: .stacked) {
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
        .dsFormValidation(validation)
    }
}

// MARK: - Previews

#Preview("Validation Showcase") {
    ScrollView {
        DSValidationShowcaseView()
            .padding()
    }
    .dsTheme(.light)
}

#Preview("Validation Showcase - Dark") {
    ScrollView {
        DSValidationShowcaseView()
            .padding()
    }
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}
