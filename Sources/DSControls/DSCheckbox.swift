// DSCheckbox.swift
// DesignSystem
//
// Checkbox control with intermediate state support.
// Designed primarily for macOS but works on all platforms via capabilities.

import SwiftUI
import DSCore
import DSTheme

// MARK: - DSCheckboxState

/// The state of a ``DSCheckbox``.
///
/// Checkboxes support three states: unchecked, checked, and intermediate.
/// The intermediate state is useful for "select all" patterns where some
/// but not all child items are selected.
///
/// ## Usage
///
/// ```swift
/// @State var state: DSCheckboxState = .unchecked
///
/// DSCheckbox("Accept Terms", state: $state)
/// ```
///
/// ## Topics
///
/// ### States
///
/// - ``unchecked``
/// - ``checked``
/// - ``intermediate``
public enum DSCheckboxState: String, Sendable, Equatable, CaseIterable, Identifiable {
    
    /// The checkbox is not checked.
    case unchecked
    
    /// The checkbox is checked.
    case checked
    
    /// The checkbox is in an intermediate/mixed state.
    ///
    /// Used when some child items are checked and some are not.
    case intermediate
    
    public var id: String { rawValue }
    
    /// Whether this state represents a "truthy" value.
    ///
    /// Returns `true` for both ``checked`` and ``intermediate``.
    public var isActive: Bool {
        self != .unchecked
    }
    
    /// Display name for the state.
    public var displayName: String {
        switch self {
        case .unchecked: return "Unchecked"
        case .checked: return "Checked"
        case .intermediate: return "Intermediate"
        }
    }
}

// MARK: - DSCheckbox

/// A themed checkbox control with intermediate state support.
///
/// `DSCheckbox` renders a bordered square with a checkmark (checked),
/// dash (intermediate), or empty (unchecked) indicator. It supports
/// hover effects on platforms with pointer interaction via capabilities.
///
/// ## Overview
///
/// ```swift
/// // Simple checkbox
/// @State var agreeToTerms: DSCheckboxState = .unchecked
/// DSCheckbox("I agree to Terms", state: $agreeToTerms)
///
/// // Convenience Bool binding
/// @State var isEnabled = false
/// DSCheckbox("Enable Feature", isOn: $isEnabled)
///
/// // Intermediate state (select all)
/// @State var selectAll: DSCheckboxState = .intermediate
/// DSCheckbox("Select All", state: $selectAll)
/// ```
///
/// ## Platform Behavior
///
/// The checkbox appearance is consistent across platforms, but hover
/// effects are only applied when ``DSCapabilities/supportsHover`` is `true`.
///
/// | Platform | Hover | Usage |
/// |----------|-------|-------|
/// | macOS | Yes | Lists, forms, multi-select |
/// | iOS | Pointer only | Lists with pointer support |
/// | watchOS | No | Simple checkbox in lists |
///
/// ## Accessibility
///
/// - Checkbox role announced via toggle trait
/// - State change announced (checked/unchecked)
/// - Label text used for VoiceOver
/// - Disabled state announced
///
/// ## Topics
///
/// ### Creating Checkboxes
///
/// - ``init(_:state:isDisabled:)``
/// - ``init(_:isOn:isDisabled:)``
/// - ``init(state:isDisabled:)``
///
/// ### State
///
/// - ``DSCheckboxState``
public struct DSCheckbox: View {
    
    // MARK: - Constants
    
    /// Size of the checkbox indicator box.
    private static let indicatorSize: CGFloat = 20
    
    /// Corner radius of the checkbox indicator.
    private static let indicatorCornerRadius: CGFloat = 5
    
    /// Size of the icon inside the indicator.
    private static let iconSize: CGFloat = 12
    
    // MARK: - Properties
    
    /// The binding to the checkbox state.
    @Binding private var state: DSCheckboxState
    
    /// The checkbox label text.
    private let label: LocalizedStringKey?
    
    /// Whether the checkbox is disabled.
    private let isDisabled: Bool
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme
    @Environment(\.dsCapabilities) private var capabilities
    
    // MARK: - State
    
    @State private var isHovered = false
    
    // MARK: - Initializers
    
    /// Creates a checkbox with a label and state binding.
    ///
    /// Use this initializer when you need to support the intermediate state.
    ///
    /// - Parameters:
    ///   - label: The checkbox label text.
    ///   - state: A binding to the checkbox state.
    ///   - isDisabled: Whether the checkbox is disabled. Defaults to `false`.
    public init(
        _ label: LocalizedStringKey,
        state: Binding<DSCheckboxState>,
        isDisabled: Bool = false
    ) {
        self.label = label
        self._state = state
        self.isDisabled = isDisabled
    }
    
    /// Creates a checkbox with a label and Bool binding.
    ///
    /// This is a convenience initializer that maps a Bool to
    /// ``DSCheckboxState/checked`` and ``DSCheckboxState/unchecked``.
    ///
    /// - Parameters:
    ///   - label: The checkbox label text.
    ///   - isOn: A binding to a Bool value.
    ///   - isDisabled: Whether the checkbox is disabled. Defaults to `false`.
    public init(
        _ label: LocalizedStringKey,
        isOn: Binding<Bool>,
        isDisabled: Bool = false
    ) {
        self.label = label
        self._state = Binding(
            get: { isOn.wrappedValue ? .checked : .unchecked },
            set: { isOn.wrappedValue = $0 == .checked }
        )
        self.isDisabled = isDisabled
    }
    
    /// Creates a checkbox without a label.
    ///
    /// Use this initializer when embedding the checkbox in a custom
    /// row that provides its own label.
    ///
    /// - Parameters:
    ///   - state: A binding to the checkbox state.
    ///   - isDisabled: Whether the checkbox is disabled. Defaults to `false`.
    public init(
        state: Binding<DSCheckboxState>,
        isDisabled: Bool = false
    ) {
        self.label = nil
        self._state = state
        self.isDisabled = isDisabled
    }
    
    // MARK: - Body
    
    public var body: some View {
        Button {
            toggleState()
        } label: {
            HStack(spacing: 8) {
                checkboxIndicator
                
                if let label {
                    Text(label)
                        .font(theme.typography.component.rowTitle.font)
                        .foregroundStyle(
                            isDisabled
                                ? theme.colors.fg.disabled
                                : theme.colors.fg.primary
                        )
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
        .onHover { hovering in
            guard capabilities.supportsHover else { return }
            withAnimation(theme.motion.component.cardHover) {
                isHovered = hovering
            }
        }
        .accessibilityAddTraits(.isToggle)
        .accessibilityValue(accessibilityStateText)
        .accessibilityHint(isDisabled ? "" : "Double tap to toggle")
    }
    
    // MARK: - Indicator
    
    /// The checkbox indicator (box with icon).
    private var checkboxIndicator: some View {
        ZStack {
            // Background
            RoundedRectangle(
                cornerRadius: Self.indicatorCornerRadius,
                style: .continuous
            )
            .fill(indicatorFillColor)
            .frame(width: Self.indicatorSize, height: Self.indicatorSize)
            
            // Border
            RoundedRectangle(
                cornerRadius: Self.indicatorCornerRadius,
                style: .continuous
            )
            .stroke(indicatorBorderColor, lineWidth: indicatorBorderWidth)
            .frame(width: Self.indicatorSize, height: Self.indicatorSize)
            
            // Icon
            if state == .checked {
                Image(systemName: "checkmark")
                    .font(.system(size: Self.iconSize, weight: .bold))
                    .foregroundStyle(.white)
                    .transition(.scale.combined(with: .opacity))
            } else if state == .intermediate {
                Image(systemName: "minus")
                    .font(.system(size: Self.iconSize, weight: .bold))
                    .foregroundStyle(.white)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(theme.motion.component.toggle, value: state)
    }
    
    // MARK: - Colors
    
    /// Fill color for the indicator based on state.
    private var indicatorFillColor: Color {
        switch state {
        case .checked, .intermediate:
            return isHovered
                ? theme.colors.accent.primary.opacity(0.85)
                : theme.colors.accent.primary
        case .unchecked:
            return isHovered
                ? theme.colors.bg.surfaceElevated
                : .clear
        }
    }
    
    /// Border color for the indicator based on state.
    private var indicatorBorderColor: Color {
        switch state {
        case .checked, .intermediate:
            return .clear
        case .unchecked:
            return isHovered
                ? theme.colors.accent.primary.opacity(0.6)
                : theme.colors.border.strong
        }
    }
    
    /// Border width for the indicator.
    private var indicatorBorderWidth: CGFloat {
        state == .unchecked ? 1.5 : 0
    }
    
    // MARK: - State Management
    
    /// Cycles through checkbox states on tap.
    private func toggleState() {
        switch state {
        case .unchecked, .intermediate:
            state = .checked
        case .checked:
            state = .unchecked
        }
    }
    
    // MARK: - Accessibility
    
    /// Accessibility description of the current state.
    private var accessibilityStateText: String {
        switch state {
        case .unchecked: return "unchecked"
        case .checked: return "checked"
        case .intermediate: return "mixed"
        }
    }
}

// MARK: - String Initializer

extension DSCheckbox {
    
    /// Creates a checkbox with a plain string label and state binding.
    ///
    /// - Parameters:
    ///   - label: The checkbox label string.
    ///   - state: A binding to the checkbox state.
    ///   - isDisabled: Whether the checkbox is disabled. Defaults to `false`.
    public init<S: StringProtocol>(
        _ label: S,
        state: Binding<DSCheckboxState>,
        isDisabled: Bool = false
    ) {
        self.label = LocalizedStringKey(String(label))
        self._state = state
        self.isDisabled = isDisabled
    }
    
    /// Creates a checkbox with a plain string label and Bool binding.
    ///
    /// - Parameters:
    ///   - label: The checkbox label string.
    ///   - isOn: A binding to a Bool value.
    ///   - isDisabled: Whether the checkbox is disabled. Defaults to `false`.
    public init<S: StringProtocol>(
        _ label: S,
        isOn: Binding<Bool>,
        isDisabled: Bool = false
    ) {
        self.label = LocalizedStringKey(String(label))
        self._state = Binding(
            get: { isOn.wrappedValue ? .checked : .unchecked },
            set: { isOn.wrappedValue = $0 == .checked }
        )
        self.isDisabled = isDisabled
    }
}

// MARK: - Previews

#Preview("Checkbox States - Light") {
    @Previewable @State var unchecked: DSCheckboxState = .unchecked
    @Previewable @State var checked: DSCheckboxState = .checked
    @Previewable @State var intermediate: DSCheckboxState = .intermediate
    
    VStack(alignment: .leading, spacing: 16) {
        DSCheckbox("Unchecked", state: $unchecked)
        DSCheckbox("Checked", state: $checked)
        DSCheckbox("Intermediate", state: $intermediate)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Checkbox States - Dark") {
    @Previewable @State var unchecked: DSCheckboxState = .unchecked
    @Previewable @State var checked: DSCheckboxState = .checked
    @Previewable @State var intermediate: DSCheckboxState = .intermediate
    
    VStack(alignment: .leading, spacing: 16) {
        DSCheckbox("Unchecked", state: $unchecked)
        DSCheckbox("Checked", state: $checked)
        DSCheckbox("Intermediate", state: $intermediate)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Bool Binding - Light") {
    @Previewable @State var isOn = false
    
    VStack(alignment: .leading, spacing: 16) {
        DSCheckbox("Accept Terms of Service", isOn: $isOn)
        Text("isOn: \(isOn ? "true" : "false")")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Disabled - Light") {
    @Previewable @State var unchecked: DSCheckboxState = .unchecked
    @Previewable @State var checked: DSCheckboxState = .checked
    @Previewable @State var intermediate: DSCheckboxState = .intermediate
    
    VStack(alignment: .leading, spacing: 16) {
        DSCheckbox("Disabled Unchecked", state: $unchecked, isDisabled: true)
        DSCheckbox("Disabled Checked", state: $checked, isDisabled: true)
        DSCheckbox("Disabled Intermediate", state: $intermediate, isDisabled: true)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Disabled - Dark") {
    @Previewable @State var unchecked: DSCheckboxState = .unchecked
    @Previewable @State var checked: DSCheckboxState = .checked
    @Previewable @State var intermediate: DSCheckboxState = .intermediate
    
    VStack(alignment: .leading, spacing: 16) {
        DSCheckbox("Disabled Unchecked", state: $unchecked, isDisabled: true)
        DSCheckbox("Disabled Checked", state: $checked, isDisabled: true)
        DSCheckbox("Disabled Intermediate", state: $intermediate, isDisabled: true)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Label-less Checkbox") {
    @Previewable @State var state: DSCheckboxState = .checked
    
    HStack(spacing: 12) {
        DSCheckbox(state: $state)
        Text("Custom Layout")
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Checkbox List") {
    @Previewable @State var selectAll: DSCheckboxState = .intermediate
    @Previewable @State var item1: DSCheckboxState = .checked
    @Previewable @State var item2: DSCheckboxState = .unchecked
    @Previewable @State var item3: DSCheckboxState = .checked
    
    VStack(alignment: .leading, spacing: 4) {
        DSCheckbox("Select All", state: $selectAll)
            .fontWeight(.semibold)
        
        Divider().padding(.vertical, 4)
        
        VStack(alignment: .leading, spacing: 8) {
            DSCheckbox("Documents", state: $item1)
            DSCheckbox("Photos", state: $item2)
            DSCheckbox("Videos", state: $item3)
        }
        .padding(.leading, 24)
    }
    .padding()
    .dsTheme(.light)
}
