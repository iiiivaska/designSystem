// DSStepper.swift
// DesignSystem
//
// Numeric stepper control with increment/decrement buttons.
// Uses theme tokens for consistent styling across the design system.

import SwiftUI
import DSCore
import DSTheme
import DSPrimitives

// MARK: - DSStepperSize

/// Size preset for stepper controls.
///
/// Determines the overall height and button sizing of the stepper.
///
/// ## Sizes
///
/// | Size | Height |
/// |------|--------|
/// | ``small`` | 32pt |
/// | ``medium`` | 40pt |
/// | ``large`` | 48pt |
public enum DSStepperSize: String, Sendable, Equatable, Hashable, CaseIterable, Identifiable {
    
    /// Small stepper (32pt height).
    ///
    /// For compact layouts and inline use.
    case small
    
    /// Medium stepper (40pt height).
    ///
    /// Standard size for most stepper placements.
    case medium
    
    /// Large stepper (48pt height).
    ///
    /// For prominent stepper placements.
    case large
    
    public var id: String { rawValue }
    
    /// The height in points for this size.
    var height: CGFloat {
        switch self {
        case .small: return 32
        case .medium: return 40
        case .large: return 48
        }
    }
    
    /// The button size (square) for this stepper size.
    var buttonSize: CGFloat {
        switch self {
        case .small: return 28
        case .medium: return 36
        case .large: return 44
        }
    }
    
    /// The icon size for increment/decrement buttons.
    var iconSize: DSIconSize {
        switch self {
        case .small: return .small
        case .medium: return .medium
        case .large: return .large
        }
    }
    
    /// The corner radius for stepper buttons.
    var cornerRadius: CGFloat {
        switch self {
        case .small: return 6
        case .medium: return 8
        case .large: return 10
        }
    }
    
    /// Font for the value display.
    var valueFont: Font {
        switch self {
        case .small: return .system(size: 14, weight: .medium, design: .monospaced)
        case .medium: return .system(size: 16, weight: .medium, design: .monospaced)
        case .large: return .system(size: 18, weight: .medium, design: .monospaced)
        }
    }
    
    /// Minimum width for the value display.
    var valueMinWidth: CGFloat {
        switch self {
        case .small: return 40
        case .medium: return 48
        case .large: return 56
        }
    }
}

// MARK: - DSStepperButtonStyle

/// Internal button style for stepper buttons with press state highlighting.
private struct DSStepperButtonStyle: ButtonStyle {
    let size: DSStepperSize
    let accentColor: Color
    let cornerRadius: CGFloat
    let animation: Animation?
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: size.buttonSize, height: size.buttonSize)
            .contentShape(Rectangle())
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(configuration.isPressed ? accentColor.opacity(0.15) : .clear)
            )
            .animation(animation, value: configuration.isPressed)
    }
}

// MARK: - DSStepper

/// A themed numeric stepper control with increment/decrement buttons.
///
/// `DSStepper` provides a way to adjust numeric values through
/// increment and decrement buttons. It supports min/max bounds,
/// custom step amounts, and optional labels.
///
/// ## Overview
///
/// ```swift
/// @State var quantity = 1
///
/// // Basic stepper
/// DSStepper("Quantity", value: $quantity, range: 0...10)
///
/// // With custom step
/// DSStepper("Amount", value: $amount, range: 0...100, step: 5)
///
/// // Without label
/// DSStepper(value: $quantity, range: 0...10)
///
/// // Large size
/// DSStepper("Count", value: $count, range: 1...99, size: .large)
/// ```
///
/// ## Bounds Behavior
///
/// - The decrement button is disabled when value equals the minimum
/// - The increment button is disabled when value equals the maximum
/// - Values are clamped to the specified range
///
/// ## Accessibility
///
/// - Provides increment/decrement adjustable actions for VoiceOver
/// - Announces current value and available range
/// - Disabled buttons are announced appropriately
///
/// ## Topics
///
/// ### Creating Steppers
///
/// - ``init(_:value:range:step:size:isDisabled:)``
/// - ``init(value:range:step:size:isDisabled:)``
///
/// ### Sizing
///
/// - ``DSStepperSize``
public struct DSStepper<V: Strideable & BinaryFloatingPoint>: View {
    
    // MARK: - Properties
    
    /// The binding to the stepper's value.
    @Binding private var value: V
    
    /// The stepper label text.
    private let label: LocalizedStringKey?
    
    /// The allowed range for the value.
    private let range: ClosedRange<V>
    
    /// The step amount for each increment/decrement.
    private let step: V
    
    /// The stepper size.
    private let size: DSStepperSize
    
    /// Whether the stepper is disabled.
    private let isDisabled: Bool
    
    /// Optional format style for displaying the value.
    private let formatStyle: FloatingPointFormatStyle<V>?
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme
    
    // MARK: - Computed Properties
    
    /// Whether the decrement button should be disabled.
    private var isDecrementDisabled: Bool {
        isDisabled || value <= range.lowerBound
    }
    
    /// Whether the increment button should be disabled.
    private var isIncrementDisabled: Bool {
        isDisabled || value >= range.upperBound
    }
    
    /// Formatted value string.
    private var formattedValue: String {
        if let formatStyle {
            return value.formatted(formatStyle)
        }
        // Default formatting - show as integer if whole number
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", Double(value))
        }
        return String(format: "%.1f", Double(value))
    }
    
    // MARK: - Initializers
    
    /// Creates a design system stepper with a label.
    ///
    /// - Parameters:
    ///   - label: The stepper label text.
    ///   - value: A binding to the stepper's value.
    ///   - range: The allowed range for the value.
    ///   - step: The step amount for each increment/decrement. Defaults to `1`.
    ///   - size: The stepper size. Defaults to ``DSStepperSize/medium``.
    ///   - isDisabled: Whether the stepper is disabled. Defaults to `false`.
    ///   - formatStyle: Optional format style for the value display.
    public init(
        _ label: LocalizedStringKey,
        value: Binding<V>,
        range: ClosedRange<V>,
        step: V = 1,
        size: DSStepperSize = .medium,
        isDisabled: Bool = false,
        formatStyle: FloatingPointFormatStyle<V>? = nil
    ) {
        self.label = label
        self._value = value
        self.range = range
        self.step = step
        self.size = size
        self.isDisabled = isDisabled
        self.formatStyle = formatStyle
    }
    
    /// Creates a design system stepper without a label.
    ///
    /// Use this initializer when embedding the stepper in a custom row
    /// or layout that provides its own label.
    ///
    /// - Parameters:
    ///   - value: A binding to the stepper's value.
    ///   - range: The allowed range for the value.
    ///   - step: The step amount for each increment/decrement. Defaults to `1`.
    ///   - size: The stepper size. Defaults to ``DSStepperSize/medium``.
    ///   - isDisabled: Whether the stepper is disabled. Defaults to `false`.
    ///   - formatStyle: Optional format style for the value display.
    public init(
        value: Binding<V>,
        range: ClosedRange<V>,
        step: V = 1,
        size: DSStepperSize = .medium,
        isDisabled: Bool = false,
        formatStyle: FloatingPointFormatStyle<V>? = nil
    ) {
        self.label = nil
        self._value = value
        self.range = range
        self.step = step
        self.size = size
        self.isDisabled = isDisabled
        self.formatStyle = formatStyle
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: theme.spacing.gap.inline) {
            if let label {
                Text(label)
                    .font(theme.typography.component.rowTitle.font)
                    .foregroundStyle(isDisabled ? theme.colors.fg.disabled : theme.colors.fg.primary)
                
                Spacer()
            }
            
            stepperControl
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(Text(formattedValue))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                increment()
            case .decrement:
                decrement()
            @unknown default:
                break
            }
        }
    }
    
    // MARK: - Stepper Control
    
    /// The stepper control with decrement, value, and increment.
    private var stepperControl: some View {
        HStack(spacing: 0) {
            // Decrement button
            Button(action: decrement) {
                DSIcon(
                    DSIconToken.Action.minus,
                    size: size.iconSize,
                    color: isDecrementDisabled ? .disabled : .accent
                )
            }
            .buttonStyle(DSStepperButtonStyle(
                size: size,
                accentColor: theme.colors.accent.primary,
                cornerRadius: size.cornerRadius,
                animation: theme.motion.component.buttonPress
            ))
            .disabled(isDecrementDisabled)
            
            // Value display
            valueDisplay
            
            // Increment button
            Button(action: increment) {
                DSIcon(
                    DSIconToken.Action.plus,
                    size: size.iconSize,
                    color: isIncrementDisabled ? .disabled : .accent
                )
            }
            .buttonStyle(DSStepperButtonStyle(
                size: size,
                accentColor: theme.colors.accent.primary,
                cornerRadius: size.cornerRadius,
                animation: theme.motion.component.buttonPress
            ))
            .disabled(isIncrementDisabled)
        }
        .background(
            RoundedRectangle(cornerRadius: size.cornerRadius + 2, style: .continuous)
                .fill(theme.colors.bg.surfaceElevated)
        )
        .overlay(
            RoundedRectangle(cornerRadius: size.cornerRadius + 2, style: .continuous)
                .stroke(theme.colors.border.subtle, lineWidth: 1)
        )
        .fixedSize()
    }
    
    /// The value display between buttons.
    private var valueDisplay: some View {
        Text(formattedValue)
            .font(size.valueFont)
            .foregroundStyle(isDisabled ? theme.colors.fg.disabled : theme.colors.fg.primary)
            .frame(minWidth: size.valueMinWidth)
            .multilineTextAlignment(.center)
    }
    
    // MARK: - Actions
    
    /// Decrements the value by the step amount.
    private func decrement() {
        let newValue = value - step
        value = max(newValue, range.lowerBound)
    }
    
    /// Increments the value by the step amount.
    private func increment() {
        let newValue = value + step
        value = min(newValue, range.upperBound)
    }
    
    // MARK: - Accessibility
    
    /// Combined accessibility label for VoiceOver.
    private var accessibilityLabel: Text {
        if let label {
            return Text(label)
        }
        return Text("Stepper")
    }
}

// MARK: - String Initializer

extension DSStepper {
    
    /// Creates a design system stepper with a plain string label.
    ///
    /// - Parameters:
    ///   - label: The stepper label string.
    ///   - value: A binding to the stepper's value.
    ///   - range: The allowed range for the value.
    ///   - step: The step amount for each increment/decrement. Defaults to `1`.
    ///   - size: The stepper size. Defaults to ``DSStepperSize/medium``.
    ///   - isDisabled: Whether the stepper is disabled. Defaults to `false`.
    ///   - formatStyle: Optional format style for the value display.
    public init<S: StringProtocol>(
        _ label: S,
        value: Binding<V>,
        range: ClosedRange<V>,
        step: V = 1,
        size: DSStepperSize = .medium,
        isDisabled: Bool = false,
        formatStyle: FloatingPointFormatStyle<V>? = nil
    ) {
        self.label = LocalizedStringKey(String(label))
        self._value = value
        self.range = range
        self.step = step
        self.size = size
        self.isDisabled = isDisabled
        self.formatStyle = formatStyle
    }
}

// MARK: - Integer Stepper

/// A themed numeric stepper control for integer values.
///
/// `DSIntStepper` is a convenience wrapper around ``DSStepper``
/// specifically for integer values.
///
/// ## Overview
///
/// ```swift
/// @State var quantity: Int = 1
///
/// DSIntStepper("Quantity", value: $quantity, range: 0...10)
/// ```
public struct DSIntStepper: View {
    
    // MARK: - Properties
    
    @Binding private var value: Int
    private let label: LocalizedStringKey?
    private let range: ClosedRange<Int>
    private let step: Int
    private let size: DSStepperSize
    private let isDisabled: Bool
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme
    
    // MARK: - Computed Properties
    
    private var isDecrementDisabled: Bool {
        isDisabled || value <= range.lowerBound
    }
    
    private var isIncrementDisabled: Bool {
        isDisabled || value >= range.upperBound
    }
    
    // MARK: - Initializers
    
    /// Creates an integer stepper with a label.
    ///
    /// - Parameters:
    ///   - label: The stepper label text.
    ///   - value: A binding to the stepper's integer value.
    ///   - range: The allowed range for the value.
    ///   - step: The step amount. Defaults to `1`.
    ///   - size: The stepper size. Defaults to ``DSStepperSize/medium``.
    ///   - isDisabled: Whether the stepper is disabled. Defaults to `false`.
    public init(
        _ label: LocalizedStringKey,
        value: Binding<Int>,
        range: ClosedRange<Int>,
        step: Int = 1,
        size: DSStepperSize = .medium,
        isDisabled: Bool = false
    ) {
        self.label = label
        self._value = value
        self.range = range
        self.step = step
        self.size = size
        self.isDisabled = isDisabled
    }
    
    /// Creates an integer stepper without a label.
    ///
    /// - Parameters:
    ///   - value: A binding to the stepper's integer value.
    ///   - range: The allowed range for the value.
    ///   - step: The step amount. Defaults to `1`.
    ///   - size: The stepper size. Defaults to ``DSStepperSize/medium``.
    ///   - isDisabled: Whether the stepper is disabled. Defaults to `false`.
    public init(
        value: Binding<Int>,
        range: ClosedRange<Int>,
        step: Int = 1,
        size: DSStepperSize = .medium,
        isDisabled: Bool = false
    ) {
        self.label = nil
        self._value = value
        self.range = range
        self.step = step
        self.size = size
        self.isDisabled = isDisabled
    }
    
    /// Creates an integer stepper with a plain string label.
    public init<S: StringProtocol>(
        _ label: S,
        value: Binding<Int>,
        range: ClosedRange<Int>,
        step: Int = 1,
        size: DSStepperSize = .medium,
        isDisabled: Bool = false
    ) {
        self.label = LocalizedStringKey(String(label))
        self._value = value
        self.range = range
        self.step = step
        self.size = size
        self.isDisabled = isDisabled
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: theme.spacing.gap.inline) {
            if let label {
                Text(label)
                    .font(theme.typography.component.rowTitle.font)
                    .foregroundStyle(isDisabled ? theme.colors.fg.disabled : theme.colors.fg.primary)
                
                Spacer()
            }
            
            stepperControl
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(Text("\(value)"))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                increment()
            case .decrement:
                decrement()
            @unknown default:
                break
            }
        }
    }
    
    // MARK: - Stepper Control
    
    private var stepperControl: some View {
        HStack(spacing: 0) {
            // Decrement button
            Button(action: decrement) {
                DSIcon(
                    DSIconToken.Action.minus,
                    size: size.iconSize,
                    color: isDecrementDisabled ? .disabled : .accent
                )
            }
            .buttonStyle(DSStepperButtonStyle(
                size: size,
                accentColor: theme.colors.accent.primary,
                cornerRadius: size.cornerRadius,
                animation: theme.motion.component.buttonPress
            ))
            .disabled(isDecrementDisabled)
            
            // Value display
            Text("\(value)")
                .font(size.valueFont)
                .foregroundStyle(isDisabled ? theme.colors.fg.disabled : theme.colors.fg.primary)
                .frame(minWidth: size.valueMinWidth)
                .multilineTextAlignment(.center)
            
            // Increment button
            Button(action: increment) {
                DSIcon(
                    DSIconToken.Action.plus,
                    size: size.iconSize,
                    color: isIncrementDisabled ? .disabled : .accent
                )
            }
            .buttonStyle(DSStepperButtonStyle(
                size: size,
                accentColor: theme.colors.accent.primary,
                cornerRadius: size.cornerRadius,
                animation: theme.motion.component.buttonPress
            ))
            .disabled(isIncrementDisabled)
        }
        .background(
            RoundedRectangle(cornerRadius: size.cornerRadius + 2, style: .continuous)
                .fill(theme.colors.bg.surfaceElevated)
        )
        .overlay(
            RoundedRectangle(cornerRadius: size.cornerRadius + 2, style: .continuous)
                .stroke(theme.colors.border.subtle, lineWidth: 1)
        )
        .fixedSize()
    }
    
    private func decrement() {
        let newValue = value - step
        value = max(newValue, range.lowerBound)
    }
    
    private func increment() {
        let newValue = value + step
        value = min(newValue, range.upperBound)
    }
    
    private var accessibilityLabel: Text {
        if let label {
            return Text(label)
        }
        return Text("Stepper")
    }
}

// MARK: - Previews

#Preview("Basic - Light") {
    @Previewable @State var quantity = 5
    VStack(spacing: 24) {
        DSIntStepper("Quantity", value: $quantity, range: 0...10)
        
        Text("Value: \(quantity)")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Basic - Dark") {
    @Previewable @State var quantity = 5
    VStack(spacing: 24) {
        DSIntStepper("Quantity", value: $quantity, range: 0...10)
        
        Text("Value: \(quantity)")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Sizes - Light") {
    @Previewable @State var small = 3
    @Previewable @State var medium = 5
    @Previewable @State var large = 7
    
    VStack(alignment: .leading, spacing: 24) {
        DSIntStepper("Small", value: $small, range: 0...10, size: .small)
        DSIntStepper("Medium", value: $medium, range: 0...10, size: .medium)
        DSIntStepper("Large", value: $large, range: 0...10, size: .large)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Sizes - Dark") {
    @Previewable @State var small = 3
    @Previewable @State var medium = 5
    @Previewable @State var large = 7
    
    VStack(alignment: .leading, spacing: 24) {
        DSIntStepper("Small", value: $small, range: 0...10, size: .small)
        DSIntStepper("Medium", value: $medium, range: 0...10, size: .medium)
        DSIntStepper("Large", value: $large, range: 0...10, size: .large)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Bounds - Light") {
    @Previewable @State var atMin = 0
    @Previewable @State var atMax = 10
    @Previewable @State var inRange = 5
    
    VStack(alignment: .leading, spacing: 24) {
        DSIntStepper("At Minimum", value: $atMin, range: 0...10)
        DSIntStepper("At Maximum", value: $atMax, range: 0...10)
        DSIntStepper("In Range", value: $inRange, range: 0...10)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Bounds - Dark") {
    @Previewable @State var atMin = 0
    @Previewable @State var atMax = 10
    @Previewable @State var inRange = 5
    
    VStack(alignment: .leading, spacing: 24) {
        DSIntStepper("At Minimum", value: $atMin, range: 0...10)
        DSIntStepper("At Maximum", value: $atMax, range: 0...10)
        DSIntStepper("In Range", value: $inRange, range: 0...10)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Custom Step - Light") {
    @Previewable @State var value = 50
    
    VStack(alignment: .leading, spacing: 24) {
        DSIntStepper("Step by 5", value: $value, range: 0...100, step: 5)
        DSIntStepper("Step by 10", value: $value, range: 0...100, step: 10)
        
        Text("Value: \(value)")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Custom Step - Dark") {
    @Previewable @State var value = 50
    
    VStack(alignment: .leading, spacing: 24) {
        DSIntStepper("Step by 5", value: $value, range: 0...100, step: 5)
        DSIntStepper("Step by 10", value: $value, range: 0...100, step: 10)
        
        Text("Value: \(value)")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Disabled - Light") {
    @Previewable @State var value = 5
    
    VStack(alignment: .leading, spacing: 24) {
        DSIntStepper("Disabled", value: $value, range: 0...10, isDisabled: true)
        DSIntStepper("Enabled", value: $value, range: 0...10)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Disabled - Dark") {
    @Previewable @State var value = 5
    
    VStack(alignment: .leading, spacing: 24) {
        DSIntStepper("Disabled", value: $value, range: 0...10, isDisabled: true)
        DSIntStepper("Enabled", value: $value, range: 0...10)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Without Label - Light") {
    @Previewable @State var value = 3
    
    HStack {
        Text("Custom Layout")
        Spacer()
        DSIntStepper(value: $value, range: 0...10)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Without Label - Dark") {
    @Previewable @State var value = 3
    
    HStack {
        Text("Custom Layout")
        Spacer()
        DSIntStepper(value: $value, range: 0...10)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Floating Point - Light") {
    @Previewable @State var value: Double = 2.5
    
    VStack(alignment: .leading, spacing: 24) {
        DSStepper("Temperature", value: $value, range: 0.0...5.0, step: 0.5)
        
        Text("Value: \(value, specifier: "%.1f")")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Floating Point - Dark") {
    @Previewable @State var value: Double = 2.5
    
    VStack(alignment: .leading, spacing: 24) {
        DSStepper("Temperature", value: $value, range: 0.0...5.0, step: 0.5)
        
        Text("Value: \(value, specifier: "%.1f")")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("All States") {
    @Previewable @State var normal = 5
    @Previewable @State var atMin = 0
    @Previewable @State var atMax = 10
    @Previewable @State var disabled = 5
    
    VStack(alignment: .leading, spacing: 24) {
        Text("Normal").font(.caption).foregroundStyle(.secondary)
        DSIntStepper("Normal", value: $normal, range: 0...10)
        
        Text("At Minimum (decrement disabled)").font(.caption).foregroundStyle(.secondary)
        DSIntStepper("At Min", value: $atMin, range: 0...10)
        
        Text("At Maximum (increment disabled)").font(.caption).foregroundStyle(.secondary)
        DSIntStepper("At Max", value: $atMax, range: 0...10)
        
        Text("Fully Disabled").font(.caption).foregroundStyle(.secondary)
        DSIntStepper("Disabled", value: $disabled, range: 0...10, isDisabled: true)
    }
    .padding()
    .dsTheme(.light)
}
