// DSSlider.swift
// DesignSystem
//
// Range slider control with platform-adaptive behavior.
// Falls back to stepper/picker on platforms without inline slider support.

import SwiftUI
import DSCore
import DSTheme
import DSPrimitives

// MARK: - DSSliderMode

/// Slider display mode.
///
/// Determines how the slider presents to the user.
///
/// ## Modes
///
/// | Mode | Description |
/// |------|-------------|
/// | ``auto`` | Platform-appropriate (slider on iOS/macOS, fallback on watchOS) |
/// | ``continuous`` | Standard continuous slider |
/// | ``discrete`` | Slider with step markers/ticks |
/// | ``stepper`` | Forced stepper fallback |
public enum DSSliderMode: String, Sendable, Equatable, Hashable, CaseIterable, Identifiable {
    
    /// Auto mode - uses platform capabilities to determine presentation.
    ///
    /// - iOS/macOS: Continuous slider
    /// - watchOS: Stepper fallback
    case auto
    
    /// Continuous slider with smooth value changes.
    case continuous
    
    /// Discrete slider with visible step tick marks.
    case discrete
    
    /// Stepper-based fallback for platforms without slider support.
    case stepper
    
    public var id: String { rawValue }
}

// MARK: - DSSlider

/// A themed range slider control with platform-adaptive behavior.
///
/// `DSSlider` provides a way to select a value from a range using
/// a draggable thumb on a track. On platforms that don't support
/// inline sliders (like watchOS), it automatically falls back to
/// a stepper-based control.
///
/// ## Overview
///
/// ```swift
/// @State var volume: Double = 0.5
///
/// // Basic slider
/// DSSlider("Volume", value: $volume)
///
/// // With range and step
/// DSSlider("Brightness", value: $brightness, range: 0...100, step: 5)
///
/// // Discrete mode with ticks
/// DSSlider("Quality", value: $quality, range: 1...5, step: 1, mode: .discrete)
///
/// // Forced stepper fallback
/// DSSlider("Rating", value: $rating, range: 1...5, mode: .stepper)
/// ```
///
/// ## Platform Behavior
///
/// | Platform | Default Behavior |
/// |----------|------------------|
/// | iOS | Continuous slider |
/// | macOS | Continuous slider |
/// | watchOS | Stepper fallback |
///
/// ## Accessibility
///
/// - Provides adjustable trait for VoiceOver
/// - Announces current value and range
/// - Step increment/decrement via VoiceOver gestures
///
/// ## Topics
///
/// ### Creating Sliders
///
/// - ``init(_:value:range:step:mode:showsValue:isDisabled:)``
/// - ``init(value:range:step:mode:showsValue:isDisabled:)``
///
/// ### Display Modes
///
/// - ``DSSliderMode``
public struct DSSlider<V: BinaryFloatingPoint>: View where V.Stride: BinaryFloatingPoint {
    
    // MARK: - Properties
    
    /// The binding to the slider's value.
    @Binding private var value: V
    
    /// The slider label text.
    private let label: LocalizedStringKey?
    
    /// The allowed range for the value.
    private let range: ClosedRange<V>
    
    /// The step amount (nil for continuous).
    private let step: V?
    
    /// The display mode.
    private let mode: DSSliderMode
    
    /// Whether to show the current value.
    private let showsValue: Bool
    
    /// Whether the slider is disabled.
    private let isDisabled: Bool
    
    /// Optional format style for displaying the value.
    private let formatStyle: FloatingPointFormatStyle<V>?
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme
    @Environment(\.dsCapabilities) private var capabilities
    
    // MARK: - State
    
    @State private var isDragging = false
    @GestureState private var dragOffset: CGFloat = 0
    
    // MARK: - Computed Properties
    
    /// Resolved display mode based on capabilities.
    private var resolvedMode: DSSliderMode {
        switch mode {
        case .auto:
            return capabilities.supportsInlinePickers ? .continuous : .stepper
        case .continuous, .discrete, .stepper:
            return mode
        }
    }
    
    /// Formatted value string.
    private var formattedValue: String {
        if let formatStyle {
            return value.formatted(formatStyle)
        }
        // Default formatting - show as integer if whole number
        let doubleValue = Double(value)
        if doubleValue.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", doubleValue)
        }
        return String(format: "%.1f", doubleValue)
    }
    
    /// Normalized value from 0 to 1.
    private var normalizedValue: CGFloat {
        let rangeSpan = CGFloat(range.upperBound - range.lowerBound)
        guard rangeSpan > 0 else { return 0 }
        return CGFloat(value - range.lowerBound) / rangeSpan
    }
    
    /// Step count for discrete mode.
    private var stepCount: Int {
        guard let step = step, step > 0 else { return 0 }
        return Int(CGFloat(range.upperBound - range.lowerBound) / CGFloat(step))
    }
    
    // MARK: - Initializers
    
    /// Creates a design system slider with a label.
    ///
    /// - Parameters:
    ///   - label: The slider label text.
    ///   - value: A binding to the slider's value.
    ///   - range: The allowed range for the value. Defaults to `0...1`.
    ///   - step: The step amount for discrete values. Defaults to `nil` (continuous).
    ///   - mode: The display mode. Defaults to ``DSSliderMode/auto``.
    ///   - showsValue: Whether to show the current value. Defaults to `true`.
    ///   - isDisabled: Whether the slider is disabled. Defaults to `false`.
    ///   - formatStyle: Optional format style for the value display.
    public init(
        _ label: LocalizedStringKey,
        value: Binding<V>,
        range: ClosedRange<V> = 0...1,
        step: V? = nil,
        mode: DSSliderMode = .auto,
        showsValue: Bool = true,
        isDisabled: Bool = false,
        formatStyle: FloatingPointFormatStyle<V>? = nil
    ) {
        self.label = label
        self._value = value
        self.range = range
        self.step = step
        self.mode = mode
        self.showsValue = showsValue
        self.isDisabled = isDisabled
        self.formatStyle = formatStyle
    }
    
    /// Creates a design system slider without a label.
    ///
    /// Use this initializer when embedding the slider in a custom row
    /// or layout that provides its own label.
    ///
    /// - Parameters:
    ///   - value: A binding to the slider's value.
    ///   - range: The allowed range for the value. Defaults to `0...1`.
    ///   - step: The step amount for discrete values. Defaults to `nil` (continuous).
    ///   - mode: The display mode. Defaults to ``DSSliderMode/auto``.
    ///   - showsValue: Whether to show the current value. Defaults to `true`.
    ///   - isDisabled: Whether the slider is disabled. Defaults to `false`.
    ///   - formatStyle: Optional format style for the value display.
    public init(
        value: Binding<V>,
        range: ClosedRange<V> = 0...1,
        step: V? = nil,
        mode: DSSliderMode = .auto,
        showsValue: Bool = true,
        isDisabled: Bool = false,
        formatStyle: FloatingPointFormatStyle<V>? = nil
    ) {
        self.label = nil
        self._value = value
        self.range = range
        self.step = step
        self.mode = mode
        self.showsValue = showsValue
        self.isDisabled = isDisabled
        self.formatStyle = formatStyle
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            switch resolvedMode {
            case .continuous, .discrete:
                sliderView
            case .stepper, .auto:
                stepperView
            }
        }
        .opacity(isDisabled ? 0.5 : 1)
    }
    
    // MARK: - Slider View
    
    /// Standard slider implementation.
    private var sliderView: some View {
        VStack(alignment: .leading, spacing: theme.spacing.gap.stack) {
            // Label row
            if label != nil || showsValue {
                labelRow
            }
            
            // Slider track
            sliderTrack
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(Text(formattedValue))
        .accessibilityAdjustableAction { direction in
            adjustValue(direction: direction)
        }
    }
    
    /// Label and value row.
    private var labelRow: some View {
        HStack {
            if let label {
                Text(label)
                    .font(theme.typography.component.rowTitle.font)
                    .foregroundStyle(isDisabled ? theme.colors.fg.disabled : theme.colors.fg.primary)
            }
            
            Spacer()
            
            if showsValue {
                Text(formattedValue)
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundStyle(theme.colors.fg.secondary)
            }
        }
    }
    
    /// Maximum thumb size (pressed state) for consistent layout.
    private static var maxThumbSize: CGFloat { 28 }
    
    /// Normal thumb size for track calculations.
    private static var normalThumbSize: CGFloat { 24 }
    
    /// The slider track with thumb.
    private var sliderTrack: some View {
        let spec = DSSliderSpec.resolve(theme: theme, state: controlState)
        // Use fixed thumb size for positioning to prevent layout jumps
        let thumbSizeForLayout = Self.normalThumbSize
        
        return GeometryReader { geometry in
            let trackWidth = geometry.size.width
            let thumbOffset = normalizedValue * (trackWidth - thumbSizeForLayout) + thumbSizeForLayout / 2
            
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: spec.trackCornerRadius, style: .continuous)
                    .fill(spec.trackColor)
                    .frame(height: spec.trackHeight)
                
                // Active track
                RoundedRectangle(cornerRadius: spec.trackCornerRadius, style: .continuous)
                    .fill(spec.trackActiveColor)
                    .frame(width: thumbOffset, height: spec.trackHeight)
                
                // Discrete tick marks
                if resolvedMode == .discrete, stepCount > 0 {
                    tickMarks(trackWidth: trackWidth, spec: spec)
                }
                
                // Thumb - size animates but doesn't affect layout
                Circle()
                    .fill(spec.thumbColor)
                    .frame(width: spec.thumbSize, height: spec.thumbSize)
                    .overlay(
                        Circle()
                            .stroke(spec.thumbBorderColor, lineWidth: spec.thumbBorderWidth)
                    )
                    .shadow(
                        color: spec.thumbShadow.color,
                        radius: spec.thumbShadow.radius,
                        x: spec.thumbShadow.x,
                        y: spec.thumbShadow.y
                    )
                    .offset(x: thumbOffset - thumbSizeForLayout / 2)
                    .gesture(dragGesture(trackWidth: trackWidth, thumbSize: thumbSizeForLayout))
            }
            .frame(height: Self.maxThumbSize)
        }
        // Fixed height based on max thumb size to prevent layout jumps
        .frame(height: Self.maxThumbSize + 8)
        .contentShape(Rectangle())
        .animation(spec.animation, value: normalizedValue)
        .animation(spec.animation, value: isDragging)
    }
    
    /// Tick marks for discrete mode.
    private func tickMarks(trackWidth: CGFloat, spec: DSSliderSpec) -> some View {
        let count = stepCount + 1
        let thumbSizeForLayout = Self.normalThumbSize
        let spacing = (trackWidth - thumbSizeForLayout) / CGFloat(stepCount)
        
        return HStack(spacing: 0) {
            ForEach(0..<count, id: \.self) { index in
                Circle()
                    .fill(spec.tickColor)
                    .frame(width: spec.tickSize, height: spec.tickSize)
                
                if index < count - 1 {
                    Spacer()
                        .frame(width: spacing - spec.tickSize)
                }
            }
        }
        .padding(.horizontal, thumbSizeForLayout / 2 - spec.tickSize / 2)
    }
    
    /// Drag gesture for slider thumb.
    private func dragGesture(trackWidth: CGFloat, thumbSize: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { gesture in
                guard !isDisabled else { return }
                isDragging = true
                
                let availableWidth = trackWidth - thumbSize
                let newOffset = max(0, min(gesture.location.x - thumbSize / 2, availableWidth))
                let newNormalized = newOffset / availableWidth
                let rangeSpan = range.upperBound - range.lowerBound
                var newValue = range.lowerBound + V(newNormalized) * rangeSpan
                
                // Snap to step if specified
                if let step = step {
                    newValue = round((newValue - range.lowerBound) / step) * step + range.lowerBound
                }
                
                // Clamp to range
                value = max(range.lowerBound, min(newValue, range.upperBound))
            }
            .onEnded { _ in
                isDragging = false
            }
    }
    
    // MARK: - Stepper View (Fallback)
    
    /// Stepper-based fallback for watchOS and other platforms.
    private var stepperView: some View {
        let effectiveStep = step ?? V(1)
        
        return HStack(spacing: theme.spacing.gap.inline) {
            if let label {
                Text(label)
                    .font(theme.typography.component.rowTitle.font)
                    .foregroundStyle(isDisabled ? theme.colors.fg.disabled : theme.colors.fg.primary)
                
                Spacer()
            }
            
            stepperControl(step: effectiveStep)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(Text(formattedValue))
        .accessibilityAdjustableAction { direction in
            adjustValue(direction: direction)
        }
    }
    
    /// The stepper control for fallback mode.
    private func stepperControl(step: V) -> some View {
        HStack(spacing: 0) {
            // Decrement button
            Button(action: { decrement(by: step) }) {
                DSIcon(
                    DSIconToken.Action.minus,
                    size: .medium,
                    color: isDecrementDisabled ? .disabled : .accent
                )
            }
            .buttonStyle(SliderStepperButtonStyle(
                accentColor: theme.colors.accent.primary,
                animation: theme.motion.component.buttonPress
            ))
            .disabled(isDecrementDisabled)
            
            // Value display
            Text(formattedValue)
                .font(.system(size: 16, weight: .medium, design: .monospaced))
                .foregroundStyle(isDisabled ? theme.colors.fg.disabled : theme.colors.fg.primary)
                .frame(minWidth: 48)
                .multilineTextAlignment(.center)
            
            // Increment button
            Button(action: { increment(by: step) }) {
                DSIcon(
                    DSIconToken.Action.plus,
                    size: .medium,
                    color: isIncrementDisabled ? .disabled : .accent
                )
            }
            .buttonStyle(SliderStepperButtonStyle(
                accentColor: theme.colors.accent.primary,
                animation: theme.motion.component.buttonPress
            ))
            .disabled(isIncrementDisabled)
        }
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(theme.colors.bg.surfaceElevated)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(theme.colors.border.subtle, lineWidth: 1)
        )
        .fixedSize()
    }
    
    // MARK: - Computed State
    
    /// Current control state.
    private var controlState: DSControlState {
        var state = DSControlState.normal
        if isDisabled {
            state.insert(.disabled)
        }
        if isDragging {
            state.insert(.pressed)
        }
        return state
    }
    
    /// Whether decrement is disabled.
    private var isDecrementDisabled: Bool {
        isDisabled || value <= range.lowerBound
    }
    
    /// Whether increment is disabled.
    private var isIncrementDisabled: Bool {
        isDisabled || value >= range.upperBound
    }
    
    // MARK: - Actions
    
    /// Decrements the value.
    private func decrement(by amount: V) {
        let newValue = value - amount
        value = max(newValue, range.lowerBound)
    }
    
    /// Increments the value.
    private func increment(by amount: V) {
        let newValue = value + amount
        value = min(newValue, range.upperBound)
    }
    
    /// Adjusts value for accessibility.
    private func adjustValue(direction: AccessibilityAdjustmentDirection) {
        let effectiveStep = step ?? V(1)
        switch direction {
        case .increment:
            increment(by: effectiveStep)
        case .decrement:
            decrement(by: effectiveStep)
        @unknown default:
            break
        }
    }
    
    // MARK: - Accessibility
    
    /// Combined accessibility label for VoiceOver.
    private var accessibilityLabel: Text {
        if let label {
            return Text(label)
        }
        return Text("Slider")
    }
}

// MARK: - String Initializer

extension DSSlider {
    
    /// Creates a design system slider with a plain string label.
    ///
    /// - Parameters:
    ///   - label: The slider label string.
    ///   - value: A binding to the slider's value.
    ///   - range: The allowed range for the value. Defaults to `0...1`.
    ///   - step: The step amount for discrete values. Defaults to `nil` (continuous).
    ///   - mode: The display mode. Defaults to ``DSSliderMode/auto``.
    ///   - showsValue: Whether to show the current value. Defaults to `true`.
    ///   - isDisabled: Whether the slider is disabled. Defaults to `false`.
    ///   - formatStyle: Optional format style for the value display.
    public init<S: StringProtocol>(
        _ label: S,
        value: Binding<V>,
        range: ClosedRange<V> = 0...1,
        step: V? = nil,
        mode: DSSliderMode = .auto,
        showsValue: Bool = true,
        isDisabled: Bool = false,
        formatStyle: FloatingPointFormatStyle<V>? = nil
    ) {
        self.label = LocalizedStringKey(String(label))
        self._value = value
        self.range = range
        self.step = step
        self.mode = mode
        self.showsValue = showsValue
        self.isDisabled = isDisabled
        self.formatStyle = formatStyle
    }
}

// MARK: - Slider Stepper Button Style

/// Internal button style for slider stepper buttons.
private struct SliderStepperButtonStyle: ButtonStyle {
    let accentColor: Color
    let animation: Animation?
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 36, height: 36)
            .contentShape(Rectangle())
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(configuration.isPressed ? accentColor.opacity(0.15) : .clear)
            )
            .animation(animation, value: configuration.isPressed)
    }
}

// MARK: - Previews

#Preview("Basic - Light") {
    @Previewable @State var value = 0.5
    VStack(spacing: 24) {
        DSSlider("Volume", value: $value)
        
        Text("Value: \(value, specifier: "%.2f")")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Basic - Dark") {
    @Previewable @State var value = 0.5
    VStack(spacing: 24) {
        DSSlider("Volume", value: $value)
        
        Text("Value: \(value, specifier: "%.2f")")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("With Range - Light") {
    @Previewable @State var brightness = 50.0
    VStack(spacing: 24) {
        DSSlider("Brightness", value: $brightness, range: 0...100)
        
        Text("Value: \(brightness, specifier: "%.0f")%")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("With Range - Dark") {
    @Previewable @State var brightness = 50.0
    VStack(spacing: 24) {
        DSSlider("Brightness", value: $brightness, range: 0...100)
        
        Text("Value: \(brightness, specifier: "%.0f")%")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Discrete Mode - Light") {
    @Previewable @State var quality = 3.0
    VStack(spacing: 24) {
        DSSlider("Quality", value: $quality, range: 1...5, step: 1, mode: .discrete)
        
        Text("Value: \(quality, specifier: "%.0f")")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Discrete Mode - Dark") {
    @Previewable @State var quality = 3.0
    VStack(spacing: 24) {
        DSSlider("Quality", value: $quality, range: 1...5, step: 1, mode: .discrete)
        
        Text("Value: \(quality, specifier: "%.0f")")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Stepper Mode - Light") {
    @Previewable @State var rating = 3.0
    VStack(spacing: 24) {
        DSSlider("Rating", value: $rating, range: 1...5, step: 1, mode: .stepper)
        
        Text("Value: \(rating, specifier: "%.0f")")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Stepper Mode - Dark") {
    @Previewable @State var rating = 3.0
    VStack(spacing: 24) {
        DSSlider("Rating", value: $rating, range: 1...5, step: 1, mode: .stepper)
        
        Text("Value: \(rating, specifier: "%.0f")")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Disabled - Light") {
    @Previewable @State var value = 0.5
    VStack(spacing: 24) {
        DSSlider("Disabled Slider", value: $value, isDisabled: true)
        DSSlider("Enabled Slider", value: $value)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Disabled - Dark") {
    @Previewable @State var value = 0.5
    VStack(spacing: 24) {
        DSSlider("Disabled Slider", value: $value, isDisabled: true)
        DSSlider("Enabled Slider", value: $value)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Without Label - Light") {
    @Previewable @State var value = 0.5
    HStack {
        Text("Custom Layout")
        Spacer()
        DSSlider(value: $value)
            .frame(width: 150)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Without Label - Dark") {
    @Previewable @State var value = 0.5
    HStack {
        Text("Custom Layout")
        Spacer()
        DSSlider(value: $value)
            .frame(width: 150)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("All Modes - Light") {
    @Previewable @State var continuous = 0.5
    @Previewable @State var discrete = 3.0
    @Previewable @State var stepper = 3.0
    
    VStack(alignment: .leading, spacing: 24) {
        Text("Continuous").font(.caption).foregroundStyle(.secondary)
        DSSlider("Volume", value: $continuous, mode: .continuous)
        
        Text("Discrete (with ticks)").font(.caption).foregroundStyle(.secondary)
        DSSlider("Quality", value: $discrete, range: 1...5, step: 1, mode: .discrete)
        
        Text("Stepper (fallback)").font(.caption).foregroundStyle(.secondary)
        DSSlider("Rating", value: $stepper, range: 1...5, step: 1, mode: .stepper)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("All Modes - Dark") {
    @Previewable @State var continuous = 0.5
    @Previewable @State var discrete = 3.0
    @Previewable @State var stepper = 3.0
    
    VStack(alignment: .leading, spacing: 24) {
        Text("Continuous").font(.caption).foregroundStyle(.secondary)
        DSSlider("Volume", value: $continuous, mode: .continuous)
        
        Text("Discrete (with ticks)").font(.caption).foregroundStyle(.secondary)
        DSSlider("Quality", value: $discrete, range: 1...5, step: 1, mode: .discrete)
        
        Text("Stepper (fallback)").font(.caption).foregroundStyle(.secondary)
        DSSlider("Rating", value: $stepper, range: 1...5, step: 1, mode: .stepper)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#if os(watchOS)
#Preview("watchOS Auto Fallback") {
    @Previewable @State var value = 3.0
    
    VStack(spacing: 16) {
        DSSlider("Rating", value: $value, range: 1...5, step: 1)
        
        Text("Auto mode falls back to stepper")
            .font(.caption2)
    }
    .padding()
    .dsTheme(.light)
}
#endif
