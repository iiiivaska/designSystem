//
//  DSTextFieldShowcasemacOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSCore
import DSControls
import DSTheme

// MARK: - DSTextField Showcase (macOS)

/// Two-column showcase view demonstrating DSTextField controls on macOS
struct DSTextFieldShowcasemacOSView: View {
    @Environment(\.dsTheme) private var theme
    
    // Text field states
    @State private var basicText = ""
    @State private var requiredText = ""
    @State private var filledText = "John Doe"
    @State private var searchText = ""
    
    // Validation
    @State private var emailText = ""
    @State private var emailValidation: DSValidationState = .none
    @State private var warningText = "pass"
    @State private var successText = "gooduser"
    
    // Secure field
    @State private var password = ""
    @State private var passwordConfirm = ""
    
    // Multiline
    @State private var notes = ""
    @State private var bio = "I'm a Swift developer passionate about SwiftUI and design systems."
    
    // Character limit
    @State private var limitedText = ""
    
    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            // Left Column: Text Fields & Secure
            VStack(alignment: .leading, spacing: 24) {
                GroupBox("Text Field") {
                    VStack(spacing: 16) {
                        DSTextField("Name", text: $basicText, placeholder: "Enter your name")
                        DSTextField("Filled", text: $filledText, placeholder: "Full name")
                        DSTextField("Disabled", text: .constant("Cannot edit"), isDisabled: true)
                        DSTextField(
                            "Required",
                            text: $requiredText,
                            placeholder: "This field is required",
                            isRequired: true,
                            helperText: "Please fill in this field"
                        )
                    }
                    .padding(8)
                }
                
                GroupBox("Search Variant") {
                    VStack(spacing: 16) {
                        DSTextField(text: $searchText, placeholder: "Search components...", variant: .search)
                    }
                    .padding(8)
                }
                
                GroupBox("Secure Field") {
                    VStack(spacing: 16) {
                        DSSecureField(
                            "Password",
                            text: $password,
                            placeholder: "Enter password",
                            isRequired: true,
                            helperText: "At least 8 characters"
                        )
                        DSSecureField(
                            "Confirm",
                            text: $passwordConfirm,
                            placeholder: "Re-enter password",
                            validation: passwordConfirmValidation
                        )
                        DSSecureField(
                            "Disabled",
                            text: .constant("hidden"),
                            placeholder: "Locked",
                            isDisabled: true
                        )
                    }
                    .padding(8)
                }
                
                GroupBox("Character Limit") {
                    DSTextField(
                        "Tweet",
                        text: $limitedText,
                        placeholder: "What's happening?",
                        characterLimit: 280
                    )
                    .padding(8)
                }
            }
            .frame(maxWidth: .infinity)
            
            // Right Column: Validation & Multiline
            VStack(alignment: .leading, spacing: 24) {
                GroupBox("Validation States") {
                    VStack(spacing: 16) {
                        DSTextField(
                            "Email (interactive)",
                            text: $emailText,
                            placeholder: "user@company.com",
                            validation: emailValidation,
                            isRequired: true
                        )
                        .onChange(of: emailText) { _, newValue in
                            if newValue.isEmpty {
                                emailValidation = .none
                            } else if newValue.contains("@") && newValue.contains(".") {
                                emailValidation = .success(message: "Valid email")
                            } else {
                                emailValidation = .error(message: "Invalid email format")
                            }
                        }
                        
                        DSTextField(
                            "Warning",
                            text: $warningText,
                            placeholder: "Password",
                            validation: .warning(message: "Weak password — consider adding numbers")
                        )
                        
                        DSTextField(
                            "Success",
                            text: $successText,
                            placeholder: "Username",
                            validation: .success(message: "Username is available")
                        )
                    }
                    .padding(8)
                }
                
                GroupBox("Multiline Field") {
                    VStack(spacing: 16) {
                        DSMultilineField(
                            "Notes",
                            text: $notes,
                            placeholder: "Enter your notes here..."
                        )
                        
                        DSMultilineField(
                            "Bio",
                            text: $bio,
                            placeholder: "Tell us about yourself",
                            isRequired: true,
                            helperText: "Write a brief bio",
                            characterLimit: 200
                        )
                    }
                    .padding(8)
                }
                
                GroupBox("Field Spec (Resolved)") {
                    let specNormal = theme.resolveField(variant: .default, state: .normal)
                    let specFocused = theme.resolveField(variant: .default, state: .focused)
                    let specSearch = theme.resolveField(variant: .search, state: .normal)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        specRow("Height", "\(Int(specNormal.height)) pt")
                        specRow("Radius (Default)", "\(Int(specNormal.cornerRadius)) pt")
                        specRow("Radius (Search)", "\(Int(specSearch.cornerRadius)) pt")
                        specRow("Padding (H)", "\(Int(specNormal.horizontalPadding)) pt")
                        specRow("Border (Normal)", "\(specNormal.borderWidth) pt")
                        specRow("Border (Focused)", "\(specFocused.borderWidth) pt")
                        specRow("Focus Ring", "\(specFocused.focusRingWidth) pt")
                        specRow("Font Size", "\(Int(specNormal.textTypography.size)) pt")
                    }
                    .padding(8)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private var passwordConfirmValidation: DSValidationState {
        if passwordConfirm.isEmpty { return .none }
        if password == passwordConfirm { return .success(message: "Passwords match") }
        return .error(message: "Passwords do not match")
    }
    
    private func specRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundStyle(theme.colors.fg.secondary)
            Spacer()
            Text(value)
                .font(.caption.monospaced())
                .foregroundStyle(theme.colors.fg.primary)
        }
    }
}
