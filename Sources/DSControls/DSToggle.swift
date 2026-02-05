// DSToggle.swift
// DesignSystem
//
// Toggle/switch control with theme accent tint.
// Uses DSToggleSpec for resolve-then-render architecture.

import SwiftUI
import DSCore
import DSTheme

// MARK: - DSToggle

/// A themed toggle/switch control using the design system theme.
///
/// `DSToggle` wraps SwiftUI's native `Toggle` with design system theming,
/// applying the accent color from the current theme and handling disabled
/// state opacity through ``DSToggleSpec``.
///
/// ## Overview
///
/// ```swift
/// @State var notifications = true
///
/// DSToggle("Enable Notifications", isOn: $notifications)
///
/// DSToggle("Airplane Mode", isOn: $airplaneMode, isDisabled: true)
/// ```
///
/// ## States
///
/// - **On**: Track filled with theme accent color
/// - **Off**: Track shows neutral/surface color
/// - **Disabled**: Reduced opacity (0.5), non-interactive
///
/// ## Accessibility
///
/// - Uses SwiftUI's native Toggle accessibility
/// - Disabled state announced via `.disabled()` modifier
/// - Label text used for VoiceOver automatically
/// - Toggle trait is applied natively
///
/// ## Topics
///
/// ### Creating Toggles
///
/// - ``init(_:isOn:isDisabled:)``
/// - ``init(isOn:isDisabled:)``
///
/// ### Styling
///
/// - ``DSToggleSpec``
public struct DSToggle: View {
    
    // MARK: - Properties
    
    /// The binding to the toggle's on/off state.
    @Binding private var isOn: Bool
    
    /// The toggle label text.
    private let label: LocalizedStringKey?
    
    /// Whether the toggle is disabled.
    private let isDisabled: Bool
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme
    
    // MARK: - Initializers
    
    /// Creates a design system toggle with a label.
    ///
    /// - Parameters:
    ///   - label: The toggle label text.
    ///   - isOn: A binding to the toggle's on/off state.
    ///   - isDisabled: Whether the toggle is disabled. Defaults to `false`.
    public init(
        _ label: LocalizedStringKey,
        isOn: Binding<Bool>,
        isDisabled: Bool = false
    ) {
        self.label = label
        self._isOn = isOn
        self.isDisabled = isDisabled
    }
    
    /// Creates a design system toggle without a label.
    ///
    /// Use this initializer when embedding the toggle in a custom row
    /// or layout that provides its own label.
    ///
    /// - Parameters:
    ///   - isOn: A binding to the toggle's on/off state.
    ///   - isDisabled: Whether the toggle is disabled. Defaults to `false`.
    public init(
        isOn: Binding<Bool>,
        isDisabled: Bool = false
    ) {
        self.label = nil
        self._isOn = isOn
        self.isDisabled = isDisabled
    }
    
    // MARK: - Computed State
    
    /// The resolved control state for spec resolution.
    private var controlState: DSControlState {
        var state: DSControlState = .normal
        if isDisabled { state.insert(.disabled) }
        return state
    }
    
    // MARK: - Body
    
    public var body: some View {
        let spec = theme.resolveToggle(isOn: isOn, state: controlState)
        
        Group {
            if let label {
                Toggle(label, isOn: $isOn)
            } else {
                Toggle(isOn: $isOn) { EmptyView() }
                    .labelsHidden()
            }
        }
        .toggleStyle(.switch)
        .tint(theme.colors.accent.primary)
        .disabled(isDisabled)
        .opacity(spec.opacity)
        .animation(spec.animation, value: isOn)
    }
}

// MARK: - String Initializer

extension DSToggle {
    
    /// Creates a design system toggle with a plain string label.
    ///
    /// - Parameters:
    ///   - label: The toggle label string.
    ///   - isOn: A binding to the toggle's on/off state.
    ///   - isDisabled: Whether the toggle is disabled. Defaults to `false`.
    public init<S: StringProtocol>(
        _ label: S,
        isOn: Binding<Bool>,
        isDisabled: Bool = false
    ) {
        self.label = LocalizedStringKey(String(label))
        self._isOn = isOn
        self.isDisabled = isDisabled
    }
}

// MARK: - Previews

#Preview("Toggle On - Light") {
    @Previewable @State var isOn = true
    VStack(spacing: 24) {
        DSToggle("Notifications", isOn: $isOn)
        DSToggle("Wi-Fi", isOn: $isOn)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Toggle On - Dark") {
    @Previewable @State var isOn = true
    VStack(spacing: 24) {
        DSToggle("Notifications", isOn: $isOn)
        DSToggle("Wi-Fi", isOn: $isOn)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Toggle Off - Light") {
    @Previewable @State var isOn = false
    VStack(spacing: 24) {
        DSToggle("Airplane Mode", isOn: $isOn)
        DSToggle("Do Not Disturb", isOn: $isOn)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Toggle Off - Dark") {
    @Previewable @State var isOn = false
    VStack(spacing: 24) {
        DSToggle("Airplane Mode", isOn: $isOn)
        DSToggle("Do Not Disturb", isOn: $isOn)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Disabled - Light") {
    @Previewable @State var isOn = true
    @Previewable @State var isOff = false
    VStack(spacing: 24) {
        DSToggle("Disabled On", isOn: $isOn, isDisabled: true)
        DSToggle("Disabled Off", isOn: $isOff, isDisabled: true)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Disabled - Dark") {
    @Previewable @State var isOn = true
    @Previewable @State var isOff = false
    VStack(spacing: 24) {
        DSToggle("Disabled On", isOn: $isOn, isDisabled: true)
        DSToggle("Disabled Off", isOn: $isOff, isDisabled: true)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Label-less Toggle") {
    @Previewable @State var isOn = true
    HStack {
        Text("Custom Label")
        Spacer()
        DSToggle(isOn: $isOn)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("All States") {
    @Previewable @State var on1 = true
    @Previewable @State var off1 = false
    @Previewable @State var on2 = true
    @Previewable @State var off2 = false
    
    VStack(alignment: .leading, spacing: 20) {
        Text("Normal").font(.caption).foregroundStyle(.secondary)
        DSToggle("On", isOn: $on1)
        DSToggle("Off", isOn: $off1)
        
        Divider()
        
        Text("Disabled").font(.caption).foregroundStyle(.secondary)
        DSToggle("Disabled On", isOn: $on2, isDisabled: true)
        DSToggle("Disabled Off", isOn: $off2, isDisabled: true)
    }
    .padding()
    .dsTheme(.light)
}
