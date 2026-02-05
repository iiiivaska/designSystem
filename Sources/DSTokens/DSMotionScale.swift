// DSMotionScale.swift
// DesignSystem
//
// Raw motion tokens - durations, springs, easing curves.
// These are "raw material" with no semantic meaning.

import Foundation

// MARK: - Duration Scale

/// Raw animation duration scale in seconds.
///
/// Standard durations for consistent animation timing.
/// All values should respect reduce motion preferences.
///
/// ## Scale Overview
/// | Token | Duration | Typical Usage |
/// |-------|----------|---------------|
/// | instant | 0 | No animation |
/// | fastest | 0.1s | Micro-interactions |
/// | fast | 0.15s | Quick feedback |
/// | normal | 0.25s | Standard transitions |
/// | slow | 0.35s | Page transitions |
/// | slower | 0.5s | Complex animations |
/// | slowest | 0.8s | Dramatic reveals |
public enum DSDuration {
    /// Instant - 0s
    ///
    /// No animation, immediate change.
    public static let instant: Double = 0
    
    /// Fastest - 100ms
    ///
    /// Micro-interactions: button press, toggle.
    public static let fastest: Double = 0.1
    
    /// Fast - 150ms
    ///
    /// Quick feedback: hover states, focus.
    public static let fast: Double = 0.15
    
    /// Normal - 250ms
    ///
    /// Standard transitions: most UI changes.
    public static let normal: Double = 0.25
    
    /// Slow - 350ms
    ///
    /// Page transitions, larger movements.
    public static let slow: Double = 0.35
    
    /// Slower - 500ms
    ///
    /// Complex animations, loading sequences.
    public static let slower: Double = 0.5
    
    /// Slowest - 800ms
    ///
    /// Dramatic reveals, onboarding.
    public static let slowest: Double = 0.8
}

// MARK: - Spring Definition

/// A raw spring animation definition.
///
/// Contains physics parameters for spring-based animations.
/// SwiftUI uses these to create natural-feeling motion.
public struct DSSpringDefinition: Equatable, Sendable {
    /// Spring response (how long it takes to settle)
    public let response: Double
    
    /// Damping fraction (0 = no damping, 1 = critical damping)
    public let dampingFraction: Double
    
    /// Blend duration (for spring with duration)
    public let blendDuration: Double
    
    /// Creates a new spring definition.
    ///
    /// - Parameters:
    ///   - response: How quickly the spring responds (seconds)
    ///   - dampingFraction: How much oscillation (0-1)
    ///   - blendDuration: Duration to blend with
    public init(
        response: Double,
        dampingFraction: Double,
        blendDuration: Double = 0
    ) {
        self.response = response
        self.dampingFraction = dampingFraction
        self.blendDuration = blendDuration
    }
}

// MARK: - Spring Scale

/// Raw spring presets for natural animations.
///
/// Springs provide more natural-feeling motion than linear timing.
/// Each preset is tuned for specific use cases.
///
/// ## Presets Overview
/// | Token | Response | Damping | Usage |
/// |-------|----------|---------|-------|
/// | snappy | 0.3 | 0.7 | Quick, responsive |
/// | bouncy | 0.5 | 0.5 | Playful, energetic |
/// | smooth | 0.5 | 0.8 | Smooth transitions |
/// | stiff | 0.2 | 0.9 | Immediate response |
/// | gentle | 0.8 | 0.7 | Soft, slow motion |
public enum DSSpring {
    /// Snappy spring - quick and responsive
    ///
    /// For UI controls, toggles, quick feedback.
    public static let snappy = DSSpringDefinition(
        response: 0.3,
        dampingFraction: 0.7
    )
    
    /// Bouncy spring - playful with oscillation
    ///
    /// For celebratory moments, playful interactions.
    public static let bouncy = DSSpringDefinition(
        response: 0.5,
        dampingFraction: 0.5
    )
    
    /// Smooth spring - natural transitions
    ///
    /// Default spring for most UI transitions.
    public static let smooth = DSSpringDefinition(
        response: 0.5,
        dampingFraction: 0.8
    )
    
    /// Stiff spring - minimal overshoot
    ///
    /// For precise positioning, no oscillation.
    public static let stiff = DSSpringDefinition(
        response: 0.2,
        dampingFraction: 0.9
    )
    
    /// Gentle spring - slow and soft
    ///
    /// For large page transitions, reveals.
    public static let gentle = DSSpringDefinition(
        response: 0.8,
        dampingFraction: 0.7
    )
    
    /// Interactive spring - matches finger movement
    ///
    /// For drag gestures, follows touch.
    public static let interactive = DSSpringDefinition(
        response: 0.35,
        dampingFraction: 1.0
    )
}

// MARK: - Easing Definition

/// A raw bezier curve easing definition.
///
/// Standard easing curves for non-spring animations.
/// Represented as control points for cubic bezier.
public struct DSEasingDefinition: Equatable, Sendable {
    /// First control point X
    public let x1: Double
    
    /// First control point Y
    public let y1: Double
    
    /// Second control point X
    public let x2: Double
    
    /// Second control point Y
    public let y2: Double
    
    /// Creates a new easing definition.
    ///
    /// - Parameters:
    ///   - x1: First control point X (0-1)
    ///   - y1: First control point Y
    ///   - x2: Second control point X (0-1)
    ///   - y2: Second control point Y
    public init(x1: Double, y1: Double, x2: Double, y2: Double) {
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
    }
}

// MARK: - Easing Scale

/// Raw easing curve presets.
///
/// Standard bezier curves for timing-based animations.
/// Use springs for most interactive animations.
public enum DSEasing {
    /// Linear - constant speed
    ///
    /// No acceleration. Use sparingly.
    public static let linear = DSEasingDefinition(
        x1: 0, y1: 0, x2: 1, y2: 1
    )
    
    /// Ease in - slow start
    ///
    /// Accelerates from rest.
    public static let easeIn = DSEasingDefinition(
        x1: 0.42, y1: 0, x2: 1, y2: 1
    )
    
    /// Ease out - slow end
    ///
    /// Decelerates to rest. Most common for UI.
    public static let easeOut = DSEasingDefinition(
        x1: 0, y1: 0, x2: 0.58, y2: 1
    )
    
    /// Ease in out - slow start and end
    ///
    /// S-curve, smooth both ends.
    public static let easeInOut = DSEasingDefinition(
        x1: 0.42, y1: 0, x2: 0.58, y2: 1
    )
    
    /// Emphasized ease out - Apple-style
    ///
    /// Quick start, long deceleration.
    public static let emphasizedDecelerate = DSEasingDefinition(
        x1: 0.05, y1: 0.7, x2: 0.1, y2: 1
    )
    
    /// Emphasized ease in - for exits
    ///
    /// Slow start, quick exit.
    public static let emphasizedAccelerate = DSEasingDefinition(
        x1: 0.3, y1: 0, x2: 0.8, y2: 0.15
    )
}

// MARK: - Component Motion Recommendations

/// Recommended motion for common animations.
///
/// These are guideline values - actual motion is determined
/// by the theme layer based on reduce motion preferences.
public enum DSComponentMotion {
    // MARK: - Button
    
    /// Button press animation
    public static let buttonPress = DSSpring.snappy
    
    /// Button loading spinner duration
    public static let buttonLoadingDuration = DSDuration.slower
    
    // MARK: - Toggle
    
    /// Toggle switch animation
    public static let toggle = DSSpring.snappy
    
    // MARK: - Form
    
    /// Validation message appear
    public static let validationAppear = DSSpring.smooth
    
    /// Focus transition
    public static let focusTransition = DSDuration.fast
    
    // MARK: - Navigation
    
    /// Page transition
    public static let pageTransition = DSSpring.smooth
    
    /// Sheet presentation
    public static let sheetPresent = DSSpring.smooth
    
    /// Sheet dismissal
    public static let sheetDismiss = DSSpring.gentle
    
    // MARK: - Cards
    
    /// Card hover lift
    public static let cardHover = DSSpring.snappy
    
    /// Card press
    public static let cardPress = DSDuration.fastest
    
    // MARK: - Lists
    
    /// List item appear (staggered)
    public static let listItemAppear = DSSpring.smooth
    
    /// List item stagger delay
    public static let listStaggerDelay = 0.05
}

// MARK: - Reduce Motion Adjustments

/// Motion adjustments for accessibility.
///
/// When reduce motion is enabled, all animations should
/// either be disabled or simplified to basic fades.
public enum DSReduceMotionAdjustment {
    /// Minimum duration when reduce motion is on
    public static let minimumDuration: Double = 0.01
    
    /// Simplified fade duration
    public static let fadeDuration: Double = 0.2
    
    /// Whether to use crossfade instead of complex animation
    public static let useCrossfade: Bool = true
    
    /// Whether to disable spring animations
    public static let disableSprings: Bool = true
}

// MARK: - Motion Scale Container

/// Complete motion scale containing all raw animation tokens.
///
/// This is the central access point for all motion tokens.
/// Values here are raw definitions - they are converted to
/// SwiftUI animations in the theme layer.
///
/// ## Usage
/// ```swift
/// // Access durations
/// let normalDuration = DSMotionScale.duration.normal
///
/// // Access springs
/// let smoothSpring = DSMotionScale.spring.smooth
///
/// // Access easing curves
/// let easeOut = DSMotionScale.easing.easeOut
///
/// // Access component recommendations
/// let buttonMotion = DSMotionScale.component.buttonPress
/// ```
public enum DSMotionScale {
    /// Duration tokens (instant through slowest)
    public static let duration = DSDuration.self
    
    /// Spring animation presets
    public static let spring = DSSpring.self
    
    /// Easing curve presets
    public static let easing = DSEasing.self
    
    /// Component-specific motion recommendations
    public static let component = DSComponentMotion.self
    
    /// Reduce motion accessibility adjustments
    public static let reduceMotion = DSReduceMotionAdjustment.self
}
