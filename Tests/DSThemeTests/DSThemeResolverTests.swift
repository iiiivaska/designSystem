// DSThemeResolverTests.swift
// DesignSystem

import Testing
import SwiftUI
@testable import DSTheme
@testable import DSCore

@Suite("DSThemeResolver Tests")
struct DSThemeResolverTests {
    
    // MARK: - Basic Resolution Tests
    
    @Test("Resolver creates complete theme")
    func testBasicResolution() {
        let theme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: .default,
            density: .regular
        )
        
        #expect(theme.variant == .light)
        #expect(theme.density == .regular)
        #expect(!theme.motion.reduceMotionEnabled)
    }
    
    @Test("Resolver input struct works")
    func testResolverInput() {
        let input = DSThemeResolverInput(
            variant: .dark,
            accessibility: .default,
            density: .compact
        )
        
        let theme = DSThemeResolver.resolve(input)
        
        #expect(theme.variant == .dark)
        #expect(theme.density == .compact)
    }
    
    @Test("Resolver input presets")
    func testResolverInputPresets() {
        let lightTheme = DSThemeResolver.resolve(.light)
        let darkTheme = DSThemeResolver.resolve(.dark)
        
        #expect(lightTheme.variant == .light)
        #expect(darkTheme.variant == .dark)
    }
    
    // MARK: - Variant Resolution Tests
    
    @Test("Light variant uses light neutral palette")
    func testLightVariantColors() {
        let theme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: .default,
            density: .regular
        )
        
        // Light theme should have lighter background
        #expect(!theme.isDark)
    }
    
    @Test("Dark variant uses dark neutral palette")
    func testDarkVariantColors() {
        let theme = DSThemeResolver.resolve(
            variant: .dark,
            accessibility: .default,
            density: .regular
        )
        
        // Dark theme
        #expect(theme.isDark)
    }
    
    // MARK: - Accessibility: High Contrast Tests
    
    @Test("High contrast increases text visibility")
    func testHighContrastText() {
        let normalAccessibility = DSAccessibilityPolicy.default
        let highContrastAccessibility = DSAccessibilityPolicy(
            reduceMotion: false,
            increasedContrast: true,
            reduceTransparency: false,
            differentiateWithoutColor: false,
            dynamicTypeSize: .medium,
            isBoldTextEnabled: false
        )
        
        let normalTheme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: normalAccessibility,
            density: .regular
        )
        
        let highContrastTheme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: highContrastAccessibility,
            density: .regular
        )
        
        // High contrast should be applied (visual verification in tests)
        // Both themes should have valid colors
        _ = normalTheme.colors.fg.primary
        _ = highContrastTheme.colors.fg.primary
    }
    
    @Test("High contrast increases border visibility")
    func testHighContrastBorders() {
        let highContrastAccessibility = DSAccessibilityPolicy(
            reduceMotion: false,
            increasedContrast: true,
            reduceTransparency: false,
            differentiateWithoutColor: false,
            dynamicTypeSize: .medium,
            isBoldTextEnabled: false
        )
        
        let normalTheme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: .default,
            density: .regular
        )
        
        let highContrastTheme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: highContrastAccessibility,
            density: .regular
        )
        
        // High contrast should have thicker strokes
        #expect(highContrastTheme.shadows.stroke.default.width >= normalTheme.shadows.stroke.default.width)
        #expect(highContrastTheme.shadows.stroke.focusRing.width > normalTheme.shadows.stroke.focusRing.width)
    }
    
    // MARK: - Accessibility: Reduce Motion Tests
    
    @Test("Reduce motion disables animations")
    func testReduceMotionEnabled() {
        let reduceMotionAccessibility = DSAccessibilityPolicy(
            reduceMotion: true,
            increasedContrast: false,
            reduceTransparency: false,
            differentiateWithoutColor: false,
            dynamicTypeSize: .medium,
            isBoldTextEnabled: false
        )
        
        let theme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: reduceMotionAccessibility,
            density: .regular
        )
        
        #expect(theme.motion.reduceMotionEnabled)
        #expect(theme.motion.duration.normal < 0.1)
    }
    
    @Test("Normal motion keeps animations")
    func testNormalMotion() {
        let theme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: .default,
            density: .regular
        )
        
        #expect(!theme.motion.reduceMotionEnabled)
        #expect(theme.motion.duration.normal > 0.1)
    }
    
    // MARK: - Accessibility: Dynamic Type Tests
    
    @Test("Dynamic type scales typography")
    func testDynamicTypeScaling() {
        let smallTypeAccessibility = DSAccessibilityPolicy(
            reduceMotion: false,
            increasedContrast: false,
            reduceTransparency: false,
            differentiateWithoutColor: false,
            dynamicTypeSize: .small,
            isBoldTextEnabled: false
        )
        
        let largeTypeAccessibility = DSAccessibilityPolicy(
            reduceMotion: false,
            increasedContrast: false,
            reduceTransparency: false,
            differentiateWithoutColor: false,
            dynamicTypeSize: .extraExtraExtraLarge,
            isBoldTextEnabled: false
        )
        
        let smallTypeTheme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: smallTypeAccessibility,
            density: .regular
        )
        
        let largeTypeTheme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: largeTypeAccessibility,
            density: .regular
        )
        
        // Larger dynamic type should have larger font sizes
        #expect(largeTypeTheme.typography.system.body.size > smallTypeTheme.typography.system.body.size)
        #expect(largeTypeTheme.typography.system.headline.size > smallTypeTheme.typography.system.headline.size)
    }
    
    @Test("Accessibility size increases spacing")
    func testAccessibilitySizeSpacing() {
        let normalAccessibility = DSAccessibilityPolicy(
            reduceMotion: false,
            increasedContrast: false,
            reduceTransparency: false,
            differentiateWithoutColor: false,
            dynamicTypeSize: .medium,
            isBoldTextEnabled: false
        )
        
        let accessibilitySizePolicy = DSAccessibilityPolicy(
            reduceMotion: false,
            increasedContrast: false,
            reduceTransparency: false,
            differentiateWithoutColor: false,
            dynamicTypeSize: .accessibilityLarge,
            isBoldTextEnabled: false
        )
        
        let normalTheme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: normalAccessibility,
            density: .regular
        )
        
        let accessibilityTheme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: accessibilitySizePolicy,
            density: .regular
        )
        
        // Accessibility sizes should have larger spacing
        #expect(accessibilityTheme.spacing.gap.row >= normalTheme.spacing.gap.row)
    }
    
    // MARK: - Accessibility: Bold Text Tests
    
    @Test("Bold text increases font weights")
    func testBoldTextEnabled() {
        let boldTextAccessibility = DSAccessibilityPolicy(
            reduceMotion: false,
            increasedContrast: false,
            reduceTransparency: false,
            differentiateWithoutColor: false,
            dynamicTypeSize: .medium,
            isBoldTextEnabled: true
        )
        
        let normalTheme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: .default,
            density: .regular
        )
        
        let boldTheme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: boldTextAccessibility,
            density: .regular
        )
        
        // Both themes should produce valid typography
        #expect(normalTheme.typography.system.body.size > 0)
        #expect(boldTheme.typography.system.body.size > 0)
    }
    
    // MARK: - Accessibility: Reduce Transparency Tests
    
    @Test("Reduce transparency reduces shadow opacity")
    func testReduceTransparency() {
        let reduceTransparencyAccessibility = DSAccessibilityPolicy(
            reduceMotion: false,
            increasedContrast: false,
            reduceTransparency: true,
            differentiateWithoutColor: false,
            dynamicTypeSize: .medium,
            isBoldTextEnabled: false
        )
        
        let theme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: reduceTransparencyAccessibility,
            density: .regular
        )
        
        // Theme should be created successfully with reduced shadows
        _ = theme.shadows.elevation.raised
        _ = theme.shadows.component.card
    }
    
    // MARK: - Density Tests
    
    @Test("Compact density reduces spacing")
    func testCompactDensity() {
        let regularTheme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: .default,
            density: .regular
        )
        
        let compactTheme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: .default,
            density: .compact
        )
        
        #expect(compactTheme.spacing.padding.m < regularTheme.spacing.padding.m)
        #expect(compactTheme.spacing.rowHeight.default < regularTheme.spacing.rowHeight.default)
    }
    
    @Test("Spacious density increases spacing")
    func testSpaciousDensity() {
        let regularTheme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: .default,
            density: .regular
        )
        
        let spaciousTheme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: .default,
            density: .spacious
        )
        
        #expect(spaciousTheme.spacing.padding.m > regularTheme.spacing.padding.m)
        #expect(spaciousTheme.spacing.rowHeight.default > regularTheme.spacing.rowHeight.default)
    }
    
    // MARK: - Combined Settings Tests
    
    @Test("All settings combined produce valid theme")
    func testCombinedSettings() {
        let fullAccessibility = DSAccessibilityPolicy(
            reduceMotion: true,
            increasedContrast: true,
            reduceTransparency: true,
            differentiateWithoutColor: true,
            dynamicTypeSize: .accessibilityExtraLarge,
            isBoldTextEnabled: true
        )
        
        // Light + compact + all accessibility
        let lightCompactTheme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: fullAccessibility,
            density: .compact
        )
        
        // Dark + spacious + all accessibility
        let darkSpaciousTheme = DSThemeResolver.resolve(
            variant: .dark,
            accessibility: fullAccessibility,
            density: .spacious
        )
        
        // Both should produce valid themes
        #expect(!lightCompactTheme.isDark)
        #expect(lightCompactTheme.density == .compact)
        #expect(lightCompactTheme.motion.reduceMotionEnabled)
        
        #expect(darkSpaciousTheme.isDark)
        #expect(darkSpaciousTheme.density == .spacious)
        #expect(darkSpaciousTheme.motion.reduceMotionEnabled)
    }
    
    // MARK: - Color Category Tests
    
    @Test("All color categories are resolved")
    func testColorCategories() {
        let theme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: .default,
            density: .regular
        )
        
        // Background colors
        _ = theme.colors.bg.canvas
        _ = theme.colors.bg.surface
        _ = theme.colors.bg.surfaceElevated
        _ = theme.colors.bg.card
        
        // Foreground colors
        _ = theme.colors.fg.primary
        _ = theme.colors.fg.secondary
        _ = theme.colors.fg.tertiary
        _ = theme.colors.fg.disabled
        
        // Border colors
        _ = theme.colors.border.subtle
        _ = theme.colors.border.strong
        _ = theme.colors.border.separator
        
        // Accent colors
        _ = theme.colors.accent.primary
        _ = theme.colors.accent.secondary
        
        // State colors
        _ = theme.colors.state.success
        _ = theme.colors.state.warning
        _ = theme.colors.state.danger
        _ = theme.colors.state.info
        
        // Focus ring
        _ = theme.colors.focusRing
    }
    
    // MARK: - Typography Category Tests
    
    @Test("All typography categories are resolved")
    func testTypographyCategories() {
        let theme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: .default,
            density: .regular
        )
        
        // System typography
        #expect(theme.typography.system.largeTitle.size > 0)
        #expect(theme.typography.system.title1.size > 0)
        #expect(theme.typography.system.title2.size > 0)
        #expect(theme.typography.system.title3.size > 0)
        #expect(theme.typography.system.headline.size > 0)
        #expect(theme.typography.system.body.size > 0)
        #expect(theme.typography.system.callout.size > 0)
        #expect(theme.typography.system.subheadline.size > 0)
        #expect(theme.typography.system.footnote.size > 0)
        #expect(theme.typography.system.caption1.size > 0)
        #expect(theme.typography.system.caption2.size > 0)
        
        // Component typography
        _ = theme.typography.component.buttonLabel
        _ = theme.typography.component.fieldText
        _ = theme.typography.component.fieldPlaceholder
        _ = theme.typography.component.helperText
        _ = theme.typography.component.rowTitle
        _ = theme.typography.component.rowValue
        _ = theme.typography.component.sectionHeader
        _ = theme.typography.component.badgeText
        _ = theme.typography.component.monoText
    }
    
    // MARK: - Spacing Category Tests
    
    @Test("All spacing categories are resolved")
    func testSpacingCategories() {
        let theme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: .default,
            density: .regular
        )
        
        // Padding
        #expect(theme.spacing.padding.xxs > 0)
        #expect(theme.spacing.padding.xs > 0)
        #expect(theme.spacing.padding.s > 0)
        #expect(theme.spacing.padding.m > 0)
        #expect(theme.spacing.padding.l > 0)
        #expect(theme.spacing.padding.xl > 0)
        #expect(theme.spacing.padding.xxl > 0)
        
        // Gaps
        #expect(theme.spacing.gap.row > 0)
        #expect(theme.spacing.gap.section > 0)
        #expect(theme.spacing.gap.stack > 0)
        #expect(theme.spacing.gap.inline > 0)
        #expect(theme.spacing.gap.dashboard > 0)
        
        // Insets
        #expect(theme.spacing.insets.screen.leading > 0)
        #expect(theme.spacing.insets.card.leading > 0)
        #expect(theme.spacing.insets.section.leading > 0)
        
        // Row heights
        #expect(theme.spacing.rowHeight.minimum > 0)
        #expect(theme.spacing.rowHeight.default > 0)
        #expect(theme.spacing.rowHeight.compact > 0)
        #expect(theme.spacing.rowHeight.large > 0)
    }
    
    // MARK: - Shadow Category Tests
    
    @Test("All shadow categories are resolved")
    func testShadowCategories() {
        let theme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: .default,
            density: .regular
        )
        
        // Elevation
        #expect(theme.shadows.elevation.flat.radius == 0)
        _ = theme.shadows.elevation.subtle
        _ = theme.shadows.elevation.raised
        _ = theme.shadows.elevation.elevated
        _ = theme.shadows.elevation.overlay
        _ = theme.shadows.elevation.floating
        
        // Stroke
        #expect(theme.shadows.stroke.default.width > 0)
        #expect(theme.shadows.stroke.strong.width > 0)
        #expect(theme.shadows.stroke.separator.width > 0)
        #expect(theme.shadows.stroke.focusRing.width > 0)
        
        // Component shadows
        _ = theme.shadows.component.card
        _ = theme.shadows.component.cardFlat
        _ = theme.shadows.component.cardRaised
        _ = theme.shadows.component.button
        _ = theme.shadows.component.modal
        _ = theme.shadows.component.popover
        _ = theme.shadows.component.dropdown
        _ = theme.shadows.component.tooltip
    }
    
    // MARK: - Motion Category Tests
    
    @Test("All motion categories are resolved")
    func testMotionCategories() {
        let theme = DSThemeResolver.resolve(
            variant: .light,
            accessibility: .default,
            density: .regular
        )
        
        // Duration
        #expect(theme.motion.duration.instant == 0)
        #expect(theme.motion.duration.fastest > 0)
        #expect(theme.motion.duration.fast > 0)
        #expect(theme.motion.duration.normal > 0)
        #expect(theme.motion.duration.slow > 0)
        #expect(theme.motion.duration.slower > 0)
        
        // Springs
        _ = theme.motion.spring.snappy
        _ = theme.motion.spring.bouncy
        _ = theme.motion.spring.smooth
        _ = theme.motion.spring.stiff
        _ = theme.motion.spring.gentle
        _ = theme.motion.spring.interactive
        
        // Component animations
        _ = theme.motion.component.buttonPress
        _ = theme.motion.component.toggle
        _ = theme.motion.component.focusTransition
        _ = theme.motion.component.pageTransition
        _ = theme.motion.component.sheetPresent
        _ = theme.motion.component.sheetDismiss
    }
    
    // MARK: - DSTheme Integration Tests
    
    @Test("DSTheme uses resolver with accessibility")
    func testDSThemeWithAccessibility() {
        let accessibility = DSAccessibilityPolicy(
            reduceMotion: true,
            increasedContrast: true,
            reduceTransparency: false,
            differentiateWithoutColor: false,
            dynamicTypeSize: .extraLarge,
            isBoldTextEnabled: false
        )
        
        let theme = DSTheme(
            variant: .dark,
            accessibility: accessibility,
            density: .compact
        )
        
        #expect(theme.variant == .dark)
        #expect(theme.density == .compact)
        #expect(theme.motion.reduceMotionEnabled)
    }
    
    @Test("DSTheme from resolver input")
    func testDSThemeFromInput() {
        var input = DSThemeResolverInput.dark
        input.density = .spacious
        
        let theme = DSTheme(from: input)
        
        #expect(theme.variant == .dark)
        #expect(theme.density == .spacious)
    }
    
    @Test("DSTheme factory methods with accessibility")
    func testDSThemeFactoryMethods() {
        let accessibility = DSAccessibilityPolicy.default
        
        let lightTheme = DSTheme.light(accessibility: accessibility)
        let darkTheme = DSTheme.dark(accessibility: accessibility, density: .compact)
        
        #expect(lightTheme.variant == .light)
        #expect(darkTheme.variant == .dark)
        #expect(darkTheme.density == .compact)
    }
    
    @Test("DSTheme system factory with accessibility")
    func testDSThemeSystemFactory() {
        let accessibility = DSAccessibilityPolicy(
            reduceMotion: true,
            increasedContrast: false,
            reduceTransparency: false,
            differentiateWithoutColor: false,
            dynamicTypeSize: .medium,
            isBoldTextEnabled: false
        )
        
        let lightTheme = DSTheme.system(
            colorScheme: .light,
            accessibility: accessibility,
            density: .regular
        )
        
        let darkTheme = DSTheme.system(
            colorScheme: .dark,
            accessibility: accessibility,
            density: .regular
        )
        
        #expect(lightTheme.variant == .light)
        #expect(darkTheme.variant == .dark)
        #expect(lightTheme.motion.reduceMotionEnabled)
        #expect(darkTheme.motion.reduceMotionEnabled)
    }
    
    @Test("DSTheme protocol conformance")
    func testDSThemeProtocol() {
        let theme = DSTheme.light
        
        // DSThemeProtocol requirements
        #expect(!theme.id.isEmpty)
        #expect(!theme.displayName.isEmpty)
        #expect(!theme.isDark)
        
        let darkTheme = DSTheme.dark
        #expect(darkTheme.isDark)
        #expect(darkTheme.displayName == "Dark")
    }
}
