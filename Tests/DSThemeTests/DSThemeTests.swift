// DSThemeTests.swift
// DesignSystem

import Testing
import SwiftUI
@testable import DSTheme
@testable import DSCore

@Suite("DSTheme Tests")
struct DSThemeTests {
    
    // MARK: - Version Tests
    
    @Test("Module version is defined")
    func testVersion() {
        #expect(DSTheme.version == "0.1.0")
    }
    
    // MARK: - Theme Creation Tests
    
    @Test("Default theme can be created")
    func testDefaultTheme() {
        let theme = DSTheme()
        #expect(theme.variant == .light)
        #expect(theme.density == .regular)
        #expect(!theme.isDark)
    }
    
    @Test("Light theme factory")
    func testLightTheme() {
        let theme = DSTheme.light
        #expect(theme.variant == .light)
        #expect(!theme.isDark)
    }
    
    @Test("Dark theme factory")
    func testDarkTheme() {
        let theme = DSTheme.dark
        #expect(theme.variant == .dark)
        #expect(theme.isDark)
    }
    
    @Test("Theme with custom density")
    func testThemeWithDensity() {
        let compact = DSTheme(variant: .light, density: .compact)
        let spacious = DSTheme(variant: .light, density: .spacious)
        
        #expect(compact.density == .compact)
        #expect(spacious.density == .spacious)
    }
    
    @Test("Theme with reduce motion")
    func testThemeWithReduceMotion() {
        let theme = DSTheme(variant: .light, reduceMotion: true)
        #expect(theme.motion.reduceMotionEnabled)
    }
    
    // MARK: - Variant Tests
    
    @Test("Variant from light color scheme")
    func testVariantFromLightScheme() {
        let variant = DSThemeVariant(from: .light)
        #expect(variant == .light)
    }
    
    @Test("Variant from dark color scheme")
    func testVariantFromDarkScheme() {
        let variant = DSThemeVariant(from: .dark)
        #expect(variant == .dark)
    }
    
    // MARK: - Color Resolution Tests
    
    @Test("Light theme has expected color structure")
    func testLightThemeColors() {
        let theme = DSTheme.light
        
        // Verify all color categories exist
        _ = theme.colors.bg.canvas
        _ = theme.colors.fg.primary
        _ = theme.colors.border.subtle
        _ = theme.colors.border.strong
        _ = theme.colors.border.separator
        _ = theme.colors.accent.primary
        _ = theme.colors.state.success
        _ = theme.colors.focusRing
    }
    
    @Test("Dark theme has expected color structure")
    func testDarkThemeColors() {
        let theme = DSTheme.dark
        
        // Verify all color categories exist
        _ = theme.colors.bg.canvas
        _ = theme.colors.fg.primary
        _ = theme.colors.border.subtle
        _ = theme.colors.border.strong
        _ = theme.colors.border.separator
        _ = theme.colors.accent.primary
        _ = theme.colors.state.success
        _ = theme.colors.focusRing
    }
    
    // MARK: - Typography Resolution Tests
    
    @Test("Theme has complete system typography")
    func testSystemTypography() {
        let theme = DSTheme.light
        
        // Verify all system styles
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
    }
    
    @Test("Theme has complete component typography")
    func testComponentTypography() {
        let theme = DSTheme.light
        
        // Verify component styles exist
        _ = theme.typography.component.buttonLabel
        _ = theme.typography.component.fieldText
        _ = theme.typography.component.fieldPlaceholder
        _ = theme.typography.component.helperText
        _ = theme.typography.component.rowTitle
        _ = theme.typography.component.sectionHeader
        _ = theme.typography.component.rowValue
        _ = theme.typography.component.monoText
        
        #expect(theme.typography.component.monoText.isMonospace)
    }
    
    // MARK: - Spacing Resolution Tests
    
    @Test("Theme has complete spacing roles")
    func testSpacingRoles() {
        let theme = DSTheme.light
        
        // Verify padding roles (xxs, xs, s, m, l, xl, xxl)
        #expect(theme.spacing.padding.xxs > 0)
        #expect(theme.spacing.padding.xs > 0)
        #expect(theme.spacing.padding.s > 0)
        #expect(theme.spacing.padding.m > 0)
        #expect(theme.spacing.padding.l > 0)
        #expect(theme.spacing.padding.xl > 0)
        #expect(theme.spacing.padding.xxl > 0)
        
        // Verify gap roles
        #expect(theme.spacing.gap.row > 0)
        #expect(theme.spacing.gap.section > 0)
        #expect(theme.spacing.gap.stack > 0)
        #expect(theme.spacing.gap.inline > 0)
        #expect(theme.spacing.gap.dashboard > 0)
        
        // Verify insets
        #expect(theme.spacing.insets.screen.leading > 0)
        #expect(theme.spacing.insets.card.leading > 0)
        #expect(theme.spacing.insets.section.leading > 0)
        
        // Verify row heights
        #expect(theme.spacing.rowHeight.minimum > 0)
        #expect(theme.spacing.rowHeight.default > 0)
        #expect(theme.spacing.rowHeight.compact > 0)
        #expect(theme.spacing.rowHeight.large > 0)
    }
    
    @Test("Compact density reduces spacing")
    func testCompactDensitySpacing() {
        let regular = DSTheme(variant: .light, density: .regular)
        let compact = DSTheme(variant: .light, density: .compact)
        
        #expect(compact.spacing.padding.m < regular.spacing.padding.m)
        #expect(compact.spacing.rowHeight.default < regular.spacing.rowHeight.default)
    }
    
    @Test("Spacious density increases spacing")
    func testSpaciousDensitySpacing() {
        let regular = DSTheme(variant: .light, density: .regular)
        let spacious = DSTheme(variant: .light, density: .spacious)
        
        #expect(spacious.spacing.padding.m > regular.spacing.padding.m)
        #expect(spacious.spacing.rowHeight.default > regular.spacing.rowHeight.default)
    }
    
    // MARK: - Radii Resolution Tests
    
    @Test("Theme has complete radii roles")
    func testRadiiRoles() {
        let theme = DSTheme.light
        
        // Verify scale roles
        #expect(theme.radii.scale.none == 0)
        #expect(theme.radii.scale.xs > 0)
        #expect(theme.radii.scale.s > 0)
        #expect(theme.radii.scale.m > 0)
        #expect(theme.radii.scale.l > 0)
        #expect(theme.radii.scale.xl > 0)
        #expect(theme.radii.scale.full > 0)
        
        // Verify component roles
        #expect(theme.radii.component.button > 0)
        #expect(theme.radii.component.card > 0)
        #expect(theme.radii.component.field > 0)
    }
    
    // MARK: - Shadow Resolution Tests
    
    @Test("Theme has complete shadow roles")
    func testShadowRoles() {
        let theme = DSTheme.light
        
        // Verify elevation roles
        #expect(theme.shadows.elevation.flat.radius == 0)
        #expect(theme.shadows.elevation.raised.radius >= 0)
        #expect(theme.shadows.elevation.elevated.radius >= 0)
        #expect(theme.shadows.elevation.floating.radius >= 0)
        
        // Verify stroke roles (default, strong, separator, focusRing, glass)
        #expect(theme.shadows.stroke.default.width > 0)
        #expect(theme.shadows.stroke.strong.width > 0)
        #expect(theme.shadows.stroke.separator.width > 0)
        #expect(theme.shadows.stroke.focusRing.width > 0)
        #expect(theme.shadows.stroke.glass.width >= 0)
        
        // Verify component roles
        _ = theme.shadows.component.card
        _ = theme.shadows.component.modal
        _ = theme.shadows.component.dropdown
    }
    
    // MARK: - Motion Resolution Tests
    
    @Test("Standard theme has animations enabled")
    func testStandardMotion() {
        let theme = DSTheme.light
        
        #expect(!theme.motion.reduceMotionEnabled)
        #expect(theme.motion.duration.normal > 0)
    }
    
    @Test("Reduced motion theme has animations disabled")
    func testReducedMotion() {
        let theme = DSTheme(variant: .light, reduceMotion: true)
        
        #expect(theme.motion.reduceMotionEnabled)
        #expect(theme.motion.duration.normal < 0.1)
    }
    
    @Test("Motion has complete duration roles")
    func testDurationRoles() {
        let theme = DSTheme.light
        
        #expect(theme.motion.duration.instant == 0)
        #expect(theme.motion.duration.fastest > 0)
        #expect(theme.motion.duration.fast > theme.motion.duration.fastest)
        #expect(theme.motion.duration.normal > theme.motion.duration.fast)
        #expect(theme.motion.duration.slow > theme.motion.duration.normal)
        #expect(theme.motion.duration.slower > theme.motion.duration.slow)
    }
    
    @Test("Motion has complete spring roles")
    func testSpringRoles() {
        let theme = DSTheme.light
        
        _ = theme.motion.spring.snappy
        _ = theme.motion.spring.bouncy
        _ = theme.motion.spring.smooth
        _ = theme.motion.spring.stiff
        _ = theme.motion.spring.gentle
        _ = theme.motion.spring.interactive
    }
    
    @Test("Motion has complete component animations")
    func testComponentAnimations() {
        let theme = DSTheme.light
        
        _ = theme.motion.component.buttonPress
        _ = theme.motion.component.toggle
        _ = theme.motion.component.focusTransition
        _ = theme.motion.component.pageTransition
        _ = theme.motion.component.sheetPresent
        _ = theme.motion.component.sheetDismiss
        
        #expect(theme.motion.component.listStaggerDelay > 0)
    }
    
    // MARK: - Equatable Tests
    
    @Test("Themes are equatable")
    func testThemeEquatable() {
        let theme1 = DSTheme.light
        let theme2 = DSTheme.light
        let theme3 = DSTheme.dark
        
        #expect(theme1 == theme2)
        #expect(theme1 != theme3)
    }
    
    @Test("Themes with different density are not equal")
    func testThemeDensityEquatable() {
        let regular = DSTheme(variant: .light, density: .regular)
        let compact = DSTheme(variant: .light, density: .compact)
        
        #expect(regular != compact)
    }
}
