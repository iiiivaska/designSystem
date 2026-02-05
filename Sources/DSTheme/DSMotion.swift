// DSMotion.swift
// DesignSystem
//
// Semantic motion/animation roles for the design system.
// Components use these roles for consistent animation timing.

import SwiftUI
import DSTokens

// MARK: - Animation Style

/// A resolved animation configuration ready for SwiftUI.
///
/// Encapsulates all parameters needed to create consistent
/// animations, respecting reduce motion preferences.
///
/// ## Usage
///
/// ```swift
/// withAnimation(style.animation) {
///     isExpanded.toggle()
/// }
/// ```
public struct DSAnimationStyle: Sendable, Equatable {
    
    /// The SwiftUI animation to use.
    ///
    /// May be nil if animations are disabled (reduce motion).
    public let animation: Animation?
    
    /// The duration in seconds.
    public let duration: TimeInterval
    
    /// Whether animations are enabled.
    ///
    /// When false, changes should happen instantly.
    public let isEnabled: Bool
    
    /// Creates a new animation style.
    ///
    /// - Parameters:
    ///   - animation: SwiftUI animation (nil for instant)
    ///   - duration: Duration in seconds
    ///   - isEnabled: Whether animations are enabled
    public init(
        animation: Animation?,
        duration: TimeInterval,
        isEnabled: Bool = true
    ) {
        self.animation = animation
        self.duration = duration
        self.isEnabled = isEnabled
    }
    
    /// Instant transition with no animation.
    public static let none = DSAnimationStyle(
        animation: nil,
        duration: 0,
        isEnabled: false
    )
    
    /// Creates a timing curve animation style.
    ///
    /// - Parameters:
    ///   - duration: Duration in seconds
    ///   - curve: Easing curve definition
    /// - Returns: An animation style
    public static func timing(
        duration: TimeInterval,
        curve: DSEasingDefinition
    ) -> DSAnimationStyle {
        DSAnimationStyle(
            animation: .timingCurve(
                curve.x1,
                curve.y1,
                curve.x2,
                curve.y2,
                duration: duration
            ),
            duration: duration
        )
    }
    
    /// Creates a spring animation style.
    ///
    /// - Parameter spring: Spring definition
    /// - Returns: An animation style
    public static func spring(_ spring: DSSpringDefinition) -> DSAnimationStyle {
        DSAnimationStyle(
            animation: .spring(
                response: spring.response,
                dampingFraction: spring.dampingFraction,
                blendDuration: spring.blendDuration
            ),
            duration: spring.response
        )
    }
}

// MARK: - Duration Roles

/// Semantic duration roles for animations.
///
/// Duration roles provide consistent timing across
/// the design system.
///
/// ## Overview
///
/// | Role | Duration | Usage |
/// |------|----------|-------|
/// | ``instant`` | 0 | No animation |
/// | ``fastest`` | 100ms | Micro-interactions |
/// | ``fast`` | 150ms | Quick feedback |
/// | ``normal`` | 250ms | Standard transitions |
/// | ``slow`` | 350ms | Page transitions |
/// | ``slower`` | 500ms | Complex animations |
public struct DSDurationRoles: Sendable, Equatable {
    
    /// Instant (no animation).
    public let instant: TimeInterval
    
    /// Fastest duration (100ms).
    ///
    /// Micro-interactions: button press, toggle.
    public let fastest: TimeInterval
    
    /// Fast duration (150ms).
    ///
    /// Quick feedback: hover states, focus.
    public let fast: TimeInterval
    
    /// Normal duration (250ms).
    ///
    /// Standard transitions: most UI changes.
    public let normal: TimeInterval
    
    /// Slow duration (350ms).
    ///
    /// Page transitions, larger movements.
    public let slow: TimeInterval
    
    /// Slower duration (500ms).
    ///
    /// Complex animations, loading sequences.
    public let slower: TimeInterval
    
    /// Creates a new duration roles instance.
    public init(
        instant: TimeInterval = 0,
        fastest: TimeInterval = 0.1,
        fast: TimeInterval = 0.15,
        normal: TimeInterval = 0.25,
        slow: TimeInterval = 0.35,
        slower: TimeInterval = 0.5
    ) {
        self.instant = instant
        self.fastest = fastest
        self.fast = fast
        self.normal = normal
        self.slow = slow
        self.slower = slower
    }
    
    /// Creates duration roles for reduced motion.
    ///
    /// All durations are set to minimum for instant transitions.
    public static let reducedMotion = DSDurationRoles(
        instant: 0,
        fastest: 0.01,
        fast: 0.01,
        normal: 0.01,
        slow: 0.01,
        slower: 0.01
    )
}

// MARK: - Spring Roles

/// Semantic spring animation roles.
///
/// Spring roles provide natural-feeling motion
/// with consistent physics across the design system.
///
/// ## Overview
///
/// | Role | Response | Damping | Usage |
/// |------|----------|---------|-------|
/// | ``snappy`` | 0.3 | 0.7 | Quick, responsive |
/// | ``bouncy`` | 0.5 | 0.5 | Playful, energetic |
/// | ``smooth`` | 0.5 | 0.8 | Smooth transitions |
/// | ``stiff`` | 0.2 | 0.9 | Immediate response |
/// | ``gentle`` | 0.8 | 0.7 | Soft, slow motion |
public struct DSSpringRoles: Sendable, Equatable {
    
    /// Snappy spring (quick and responsive).
    ///
    /// For UI controls, toggles, quick feedback.
    public let snappy: Animation
    
    /// Bouncy spring (playful with oscillation).
    ///
    /// For celebratory moments, playful interactions.
    public let bouncy: Animation
    
    /// Smooth spring (natural transitions).
    ///
    /// Default spring for most UI transitions.
    public let smooth: Animation
    
    /// Stiff spring (minimal overshoot).
    ///
    /// For precise positioning, no oscillation.
    public let stiff: Animation
    
    /// Gentle spring (slow and soft).
    ///
    /// For large page transitions, reveals.
    public let gentle: Animation
    
    /// Interactive spring (matches finger movement).
    ///
    /// For drag gestures, follows touch.
    public let interactive: Animation
    
    /// Creates a new spring roles instance.
    public init(
        snappy: Animation,
        bouncy: Animation,
        smooth: Animation,
        stiff: Animation,
        gentle: Animation,
        interactive: Animation
    ) {
        self.snappy = snappy
        self.bouncy = bouncy
        self.smooth = smooth
        self.stiff = stiff
        self.gentle = gentle
        self.interactive = interactive
    }
    
    /// Creates spring roles from token definitions.
    ///
    /// - Returns: Spring roles using token values
    public static func fromTokens() -> DSSpringRoles {
        DSSpringRoles(
            snappy: .spring(
                response: DSSpring.snappy.response,
                dampingFraction: DSSpring.snappy.dampingFraction
            ),
            bouncy: .spring(
                response: DSSpring.bouncy.response,
                dampingFraction: DSSpring.bouncy.dampingFraction
            ),
            smooth: .spring(
                response: DSSpring.smooth.response,
                dampingFraction: DSSpring.smooth.dampingFraction
            ),
            stiff: .spring(
                response: DSSpring.stiff.response,
                dampingFraction: DSSpring.stiff.dampingFraction
            ),
            gentle: .spring(
                response: DSSpring.gentle.response,
                dampingFraction: DSSpring.gentle.dampingFraction
            ),
            interactive: .spring(
                response: DSSpring.interactive.response,
                dampingFraction: DSSpring.interactive.dampingFraction
            )
        )
    }
    
    /// Creates spring roles for reduced motion.
    ///
    /// All springs use linear animation with minimal duration.
    public static let reducedMotion = DSSpringRoles(
        snappy: .linear(duration: 0.01),
        bouncy: .linear(duration: 0.01),
        smooth: .linear(duration: 0.01),
        stiff: .linear(duration: 0.01),
        gentle: .linear(duration: 0.01),
        interactive: .linear(duration: 0.01)
    )
}

// MARK: - Component Animation Roles

/// Component-specific animation roles.
///
/// Semantic animations for specific UI components.
public struct DSComponentAnimationRoles: Sendable, Equatable {
    
    /// Button press animation.
    public let buttonPress: Animation
    
    /// Toggle switch animation.
    public let toggle: Animation
    
    /// Validation message appear.
    public let validationAppear: Animation
    
    /// Focus transition.
    public let focusTransition: Animation
    
    /// Page transition.
    public let pageTransition: Animation
    
    /// Sheet presentation.
    public let sheetPresent: Animation
    
    /// Sheet dismissal.
    public let sheetDismiss: Animation
    
    /// Card hover lift.
    public let cardHover: Animation
    
    /// List item appear.
    public let listItemAppear: Animation
    
    /// List item stagger delay.
    public let listStaggerDelay: TimeInterval
    
    /// Creates a new component animation roles instance.
    public init(
        buttonPress: Animation,
        toggle: Animation,
        validationAppear: Animation,
        focusTransition: Animation,
        pageTransition: Animation,
        sheetPresent: Animation,
        sheetDismiss: Animation,
        cardHover: Animation,
        listItemAppear: Animation,
        listStaggerDelay: TimeInterval
    ) {
        self.buttonPress = buttonPress
        self.toggle = toggle
        self.validationAppear = validationAppear
        self.focusTransition = focusTransition
        self.pageTransition = pageTransition
        self.sheetPresent = sheetPresent
        self.sheetDismiss = sheetDismiss
        self.cardHover = cardHover
        self.listItemAppear = listItemAppear
        self.listStaggerDelay = listStaggerDelay
    }
    
    /// Creates component animations from tokens and springs.
    ///
    /// - Parameter springs: Spring roles to use
    /// - Returns: Component animation roles
    public static func fromTokens(springs: DSSpringRoles) -> DSComponentAnimationRoles {
        DSComponentAnimationRoles(
            buttonPress: springs.snappy,
            toggle: springs.snappy,
            validationAppear: springs.smooth,
            focusTransition: .easeInOut(duration: DSDuration.fast),
            pageTransition: springs.smooth,
            sheetPresent: springs.smooth,
            sheetDismiss: springs.gentle,
            cardHover: springs.snappy,
            listItemAppear: springs.smooth,
            listStaggerDelay: DSComponentMotion.listStaggerDelay
        )
    }
    
    /// Creates component animations for reduced motion.
    public static let reducedMotion = DSComponentAnimationRoles(
        buttonPress: .linear(duration: 0.01),
        toggle: .linear(duration: 0.01),
        validationAppear: .linear(duration: 0.01),
        focusTransition: .linear(duration: 0.01),
        pageTransition: .linear(duration: 0.01),
        sheetPresent: .linear(duration: 0.01),
        sheetDismiss: .linear(duration: 0.01),
        cardHover: .linear(duration: 0.01),
        listItemAppear: .linear(duration: 0.01),
        listStaggerDelay: 0
    )
}

// MARK: - DSMotion Container

/// Complete semantic motion/animation system.
///
/// `DSMotion` contains all animation roles organized by category.
/// Components use these semantic roles for consistent animation.
///
/// ## Categories
///
/// - ``duration``: Animation duration values
/// - ``spring``: Spring animation presets
/// - ``component``: Component-specific animations
/// - ``reduceMotionEnabled``: Whether reduce motion is active
///
/// ## Usage
///
/// ```swift
/// @Environment(\.dsTheme) private var theme
///
/// var body: some View {
///     Button("Tap") {
///         withAnimation(theme.motion.spring.snappy) {
///             isPressed.toggle()
///         }
///     }
/// }
/// ```
///
/// ## Accessibility
///
/// When ``reduceMotionEnabled`` is true, all animations
/// should be simplified or disabled. Use the animation
/// values directly - they will already be configured
/// appropriately for the user's preferences.
///
/// ## Topics
///
/// ### Animation Categories
///
/// - ``DSAnimationStyle``
/// - ``DSDurationRoles``
/// - ``DSSpringRoles``
/// - ``DSComponentAnimationRoles``
public struct DSMotion: Sendable, Equatable {
    
    /// Whether reduce motion is enabled.
    ///
    /// When true, animations are minimized for accessibility.
    public let reduceMotionEnabled: Bool
    
    /// Duration values.
    public let duration: DSDurationRoles
    
    /// Spring animation presets.
    public let spring: DSSpringRoles
    
    /// Component-specific animations.
    public let component: DSComponentAnimationRoles
    
    /// Creates a new motion container.
    ///
    /// - Parameters:
    ///   - reduceMotionEnabled: Whether reduce motion is enabled
    ///   - duration: Duration roles
    ///   - spring: Spring roles
    ///   - component: Component animation roles
    public init(
        reduceMotionEnabled: Bool,
        duration: DSDurationRoles,
        spring: DSSpringRoles,
        component: DSComponentAnimationRoles
    ) {
        self.reduceMotionEnabled = reduceMotionEnabled
        self.duration = duration
        self.spring = spring
        self.component = component
    }
    
    /// Creates a motion container with standard animations.
    public static let standard = DSMotion(
        reduceMotionEnabled: false,
        duration: DSDurationRoles(),
        spring: .fromTokens(),
        component: .fromTokens(springs: .fromTokens())
    )
    
    /// Creates a motion container for reduced motion.
    public static let reducedMotion = DSMotion(
        reduceMotionEnabled: true,
        duration: .reducedMotion,
        spring: .reducedMotion,
        component: .reducedMotion
    )
}
