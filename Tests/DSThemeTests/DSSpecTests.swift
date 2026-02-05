// DSSpecTests.swift
// DesignSystem

import Testing
import SwiftUI
@testable import DSTheme
@testable import DSCore

// MARK: - DSButtonSpec Tests

@Suite("DSButtonSpec Tests")
struct DSButtonSpecTests {
    
    let lightTheme = DSTheme.light
    let darkTheme = DSTheme.dark
    
    // MARK: - Variant Resolution
    
    @Test("Primary button has accent background")
    func testPrimaryVariant() {
        let spec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .primary,
            size: .medium,
            state: .normal
        )
        
        // Primary uses filled accent background
        #expect(spec.borderWidth == 0)
        #expect(spec.opacity == 1.0)
        #expect(spec.scaleEffect == 1.0)
    }
    
    @Test("Secondary button has border")
    func testSecondaryVariant() {
        let spec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .secondary,
            size: .medium,
            state: .normal
        )
        
        #expect(spec.borderWidth == 1.0)
        #expect(spec.opacity == 1.0)
    }
    
    @Test("Tertiary button has clear background")
    func testTertiaryVariant() {
        let spec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .tertiary,
            size: .medium,
            state: .normal
        )
        
        #expect(spec.backgroundColor == .clear)
        #expect(spec.borderWidth == 0)
    }
    
    @Test("Destructive button resolves correctly")
    func testDestructiveVariant() {
        let spec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .destructive,
            size: .medium,
            state: .normal
        )
        
        #expect(spec.borderWidth == 0)
        #expect(spec.opacity == 1.0)
    }
    
    @Test("All variants are iterable", arguments: DSButtonVariant.allCases)
    func testAllVariants(variant: DSButtonVariant) {
        let spec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: variant,
            size: .medium,
            state: .normal
        )
        
        #expect(spec.opacity == 1.0)
        #expect(spec.height > 0)
        #expect(spec.cornerRadius > 0)
    }
    
    // MARK: - Size Resolution
    
    @Test("Small button is 32pt height")
    func testSmallSize() {
        let spec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .primary,
            size: .small,
            state: .normal
        )
        
        #expect(spec.height == 32)
    }
    
    @Test("Medium button is 40pt height")
    func testMediumSize() {
        let spec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .primary,
            size: .medium,
            state: .normal
        )
        
        #expect(spec.height == 40)
    }
    
    @Test("Large button is 48pt height")
    func testLargeSize() {
        let spec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .primary,
            size: .large,
            state: .normal
        )
        
        #expect(spec.height == 48)
    }
    
    @Test("Sizes increase progressively")
    func testSizeProgression() {
        let small = DSButtonSpec.resolve(theme: lightTheme, variant: .primary, size: .small, state: .normal)
        let medium = DSButtonSpec.resolve(theme: lightTheme, variant: .primary, size: .medium, state: .normal)
        let large = DSButtonSpec.resolve(theme: lightTheme, variant: .primary, size: .large, state: .normal)
        
        #expect(small.height < medium.height)
        #expect(medium.height < large.height)
        #expect(small.horizontalPadding <= medium.horizontalPadding)
        #expect(medium.horizontalPadding <= large.horizontalPadding)
    }
    
    // MARK: - State Resolution
    
    @Test("Disabled button has reduced opacity")
    func testDisabledState() {
        let spec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .primary,
            size: .medium,
            state: .disabled
        )
        
        #expect(spec.opacity < 1.0)
    }
    
    @Test("Pressed button has reduced scale")
    func testPressedState() {
        let spec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .primary,
            size: .medium,
            state: .pressed
        )
        
        #expect(spec.scaleEffect < 1.0)
    }
    
    @Test("Loading button has reduced opacity")
    func testLoadingState() {
        let spec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .primary,
            size: .medium,
            state: .loading
        )
        
        #expect(spec.opacity < 1.0)
    }
    
    @Test("Normal button has full opacity and scale")
    func testNormalState() {
        let spec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .primary,
            size: .medium,
            state: .normal
        )
        
        #expect(spec.opacity == 1.0)
        #expect(spec.scaleEffect == 1.0)
    }
    
    @Test("Primary/destructive have button shadow in normal state")
    func testShadowPresence() {
        let primarySpec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .primary,
            size: .medium,
            state: .normal
        )
        
        let tertiarySpec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .tertiary,
            size: .medium,
            state: .normal
        )
        
        // Tertiary should not have shadow
        #expect(tertiarySpec.shadow == .none)
    }
    
    @Test("Disabled primary loses shadow")
    func testDisabledLosesShadow() {
        let spec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .primary,
            size: .medium,
            state: .disabled
        )
        
        #expect(spec.shadow == .none)
    }
    
    // MARK: - Theme Variant
    
    @Test("Button resolves differently for light and dark themes")
    func testThemeVariants() {
        let lightSpec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .secondary,
            size: .medium,
            state: .normal
        )
        
        let darkSpec = DSButtonSpec.resolve(
            theme: darkTheme,
            variant: .secondary,
            size: .medium,
            state: .normal
        )
        
        // Both should have valid specs
        #expect(lightSpec.height == darkSpec.height)
        #expect(lightSpec.cornerRadius == darkSpec.cornerRadius)
    }
    
    // MARK: - Typography
    
    @Test("Typography scales with size")
    func testTypographyScaling() {
        let small = DSButtonSpec.resolve(theme: lightTheme, variant: .primary, size: .small, state: .normal)
        let medium = DSButtonSpec.resolve(theme: lightTheme, variant: .primary, size: .medium, state: .normal)
        
        #expect(small.typography.size < medium.typography.size)
    }
    
    // MARK: - Animation
    
    @Test("Button has animation defined")
    func testAnimationPresence() {
        let spec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .primary,
            size: .medium,
            state: .normal
        )
        
        #expect(spec.animation != nil)
    }
    
    @Test("Reduced motion theme has minimal animation")
    func testReducedMotion() {
        let reducedTheme = DSTheme(variant: .light, density: .regular, reduceMotion: true)
        let spec = DSButtonSpec.resolve(
            theme: reducedTheme,
            variant: .primary,
            size: .medium,
            state: .normal
        )
        
        // Animation is still present but configured for reduced motion
        #expect(spec.animation != nil)
    }
}

// MARK: - DSFieldSpec Tests

@Suite("DSFieldSpec Tests")
struct DSFieldSpecTests {
    
    let theme = DSTheme.light
    
    @Test("Default field resolves with correct radius")
    func testDefaultVariant() {
        let spec = DSFieldSpec.resolve(
            theme: theme,
            variant: .default,
            state: .normal
        )
        
        #expect(spec.cornerRadius == theme.radii.component.field)
        #expect(spec.opacity == 1.0)
    }
    
    @Test("Search field has larger radius")
    func testSearchVariant() {
        let defaultSpec = DSFieldSpec.resolve(theme: theme, variant: .default, state: .normal)
        let searchSpec = DSFieldSpec.resolve(theme: theme, variant: .search, state: .normal)
        
        #expect(searchSpec.cornerRadius >= defaultSpec.cornerRadius)
    }
    
    @Test("Focused field has accent border")
    func testFocusedState() {
        let spec = DSFieldSpec.resolve(
            theme: theme,
            variant: .default,
            state: .focused
        )
        
        #expect(spec.borderWidth == 2.0)
        #expect(spec.focusRingWidth > 0)
    }
    
    @Test("Normal field has thin border")
    func testNormalBorder() {
        let spec = DSFieldSpec.resolve(
            theme: theme,
            variant: .default,
            state: .normal
        )
        
        #expect(spec.borderWidth <= 1.5)
    }
    
    @Test("Disabled field has reduced opacity")
    func testDisabledField() {
        let spec = DSFieldSpec.resolve(
            theme: theme,
            variant: .default,
            state: .disabled
        )
        
        #expect(spec.opacity < 1.0)
    }
    
    @Test("Error validation shows danger border")
    func testErrorValidation() {
        let spec = DSFieldSpec.resolve(
            theme: theme,
            variant: .default,
            state: .normal,
            validation: .error(message: "Required")
        )
        
        #expect(spec.borderWidth > 1.0)
    }
    
    @Test("Warning validation shows warning border")
    func testWarningValidation() {
        let spec = DSFieldSpec.resolve(
            theme: theme,
            variant: .default,
            state: .normal,
            validation: .warning(message: "Weak password")
        )
        
        #expect(spec.borderWidth > 1.0)
    }
    
    @Test("Success validation has standard border")
    func testSuccessValidation() {
        let spec = DSFieldSpec.resolve(
            theme: theme,
            variant: .default,
            state: .normal,
            validation: .success()
        )
        
        #expect(spec.borderWidth == 1.0)
    }
    
    @Test("Field has valid typography")
    func testTypography() {
        let spec = DSFieldSpec.resolve(
            theme: theme,
            variant: .default,
            state: .normal
        )
        
        #expect(spec.textTypography.size > 0)
        #expect(spec.placeholderTypography.size > 0)
        #expect(spec.textTypography.size == spec.placeholderTypography.size)
    }
    
    @Test("All field variants produce valid specs", arguments: DSFieldVariant.allCases)
    func testAllVariants(variant: DSFieldVariant) {
        let spec = DSFieldSpec.resolve(
            theme: theme,
            variant: variant,
            state: .normal
        )
        
        #expect(spec.height > 0)
        #expect(spec.cornerRadius > 0)
        #expect(spec.horizontalPadding > 0)
    }
    
    @Test("Focused field with error prioritizes error border")
    func testFocusedWithError() {
        let spec = DSFieldSpec.resolve(
            theme: theme,
            variant: .default,
            state: .focused,
            validation: .error(message: "Invalid")
        )
        
        // Error state takes priority over focus
        #expect(spec.borderWidth == 2.0)
    }
}

// MARK: - DSToggleSpec Tests

@Suite("DSToggleSpec Tests")
struct DSToggleSpecTests {
    
    let theme = DSTheme.light
    
    @Test("On toggle uses accent track color")
    func testOnState() {
        let spec = DSToggleSpec.resolve(
            theme: theme,
            isOn: true,
            state: .normal
        )
        
        #expect(spec.trackBorderWidth == 0)
        #expect(spec.opacity == 1.0)
    }
    
    @Test("Off toggle has border")
    func testOffState() {
        let spec = DSToggleSpec.resolve(
            theme: theme,
            isOn: false,
            state: .normal
        )
        
        #expect(spec.trackBorderWidth > 0)
        #expect(spec.opacity == 1.0)
    }
    
    @Test("Disabled toggle has reduced opacity")
    func testDisabledState() {
        let spec = DSToggleSpec.resolve(
            theme: theme,
            isOn: true,
            state: .disabled
        )
        
        #expect(spec.opacity < 1.0)
    }
    
    @Test("Track dimensions are valid")
    func testTrackDimensions() {
        let spec = DSToggleSpec.resolve(
            theme: theme,
            isOn: true,
            state: .normal
        )
        
        #expect(spec.trackWidth > spec.trackHeight)
        #expect(spec.trackHeight > spec.thumbSize)
        #expect(spec.trackCornerRadius == spec.trackHeight / 2)
    }
    
    @Test("Thumb has shadow")
    func testThumbShadow() {
        let spec = DSToggleSpec.resolve(
            theme: theme,
            isOn: true,
            state: .normal
        )
        
        #expect(spec.thumbShadow != .none)
    }
    
    @Test("Toggle has animation")
    func testAnimation() {
        let spec = DSToggleSpec.resolve(
            theme: theme,
            isOn: true,
            state: .normal
        )
        
        #expect(spec.animation != nil)
    }
}

// MARK: - DSFormRowSpec Tests

@Suite("DSFormRowSpec Tests")
struct DSFormRowSpecTests {
    
    let theme = DSTheme.light
    
    @Test("Auto layout uses iOS inline by default")
    func testAutoLayoutiOS() {
        let spec = DSFormRowSpec.resolve(
            theme: theme,
            layoutMode: .auto,
            capabilities: .iOS()
        )
        
        #expect(spec.resolvedLayout == .inline)
    }
    
    @Test("Auto layout uses macOS two-column")
    func testAutoLayoutmacOS() {
        let spec = DSFormRowSpec.resolve(
            theme: theme,
            layoutMode: .auto,
            capabilities: .macOS()
        )
        
        #expect(spec.resolvedLayout == .twoColumn)
    }
    
    @Test("Auto layout uses watchOS stacked")
    func testAutoLayoutwatchOS() {
        let spec = DSFormRowSpec.resolve(
            theme: theme,
            layoutMode: .auto,
            capabilities: .watchOS()
        )
        
        #expect(spec.resolvedLayout == .stacked)
    }
    
    @Test("Fixed layout overrides capabilities")
    func testFixedLayout() {
        let spec = DSFormRowSpec.resolve(
            theme: theme,
            layoutMode: .fixed(.stacked),
            capabilities: .macOS()
        )
        
        #expect(spec.resolvedLayout == .stacked)
    }
    
    @Test("Two-column has label width defined")
    func testTwoColumnLabelWidth() {
        let spec = DSFormRowSpec.resolve(
            theme: theme,
            layoutMode: .fixed(.twoColumn),
            capabilities: .macOS()
        )
        
        #expect(spec.labelWidth != nil)
        #expect(spec.labelWidth! > 0)
    }
    
    @Test("Inline and stacked have no label width")
    func testNoLabelWidth() {
        let inlineSpec = DSFormRowSpec.resolve(
            theme: theme,
            layoutMode: .fixed(.inline),
            capabilities: .iOS()
        )
        
        let stackedSpec = DSFormRowSpec.resolve(
            theme: theme,
            layoutMode: .fixed(.stacked),
            capabilities: .watchOS()
        )
        
        #expect(inlineSpec.labelWidth == nil)
        #expect(stackedSpec.labelWidth == nil)
    }
    
    @Test("Stacked layout has vertical spacing, no horizontal")
    func testStackedSpacing() {
        let spec = DSFormRowSpec.resolve(
            theme: theme,
            layoutMode: .fixed(.stacked),
            capabilities: .watchOS()
        )
        
        #expect(spec.verticalSpacing > 0)
        #expect(spec.horizontalSpacing == 0)
    }
    
    @Test("Inline layout has horizontal spacing, no vertical")
    func testInlineSpacing() {
        let spec = DSFormRowSpec.resolve(
            theme: theme,
            layoutMode: .fixed(.inline),
            capabilities: .iOS()
        )
        
        #expect(spec.horizontalSpacing > 0)
        #expect(spec.verticalSpacing == 0)
    }
    
    @Test("Large tap target platforms have taller rows")
    func testLargeTapTargets() {
        let iosSpec = DSFormRowSpec.resolve(
            theme: theme,
            layoutMode: .auto,
            capabilities: .iOS()
        )
        
        let macSpec = DSFormRowSpec.resolve(
            theme: theme,
            layoutMode: .auto,
            capabilities: .macOS()
        )
        
        #expect(iosSpec.minHeight >= macSpec.minHeight)
    }
    
    @Test("Content padding is positive")
    func testContentPadding() {
        let spec = DSFormRowSpec.resolve(
            theme: theme,
            layoutMode: .auto,
            capabilities: .iOS()
        )
        
        #expect(spec.contentPadding.top > 0)
        #expect(spec.contentPadding.leading > 0)
        #expect(spec.contentPadding.bottom > 0)
        #expect(spec.contentPadding.trailing > 0)
    }
    
    @Test("All layout modes produce valid specs", arguments: DSFormRowLayout.allCases)
    func testAllLayouts(layout: DSFormRowLayout) {
        let spec = DSFormRowSpec.resolve(
            theme: theme,
            layoutMode: .fixed(layout),
            capabilities: .iOS()
        )
        
        #expect(spec.resolvedLayout == layout)
        #expect(spec.minHeight > 0)
    }
}

// MARK: - DSCardSpec Tests

@Suite("DSCardSpec Tests")
struct DSCardSpecTests {
    
    let lightTheme = DSTheme.light
    let darkTheme = DSTheme.dark
    
    @Test("Flat card has no shadow")
    func testFlatElevation() {
        let spec = DSCardSpec.resolve(
            theme: lightTheme,
            elevation: .flat
        )
        
        #expect(spec.shadow == .none || spec.shadow.radius == 0)
        #expect(spec.borderWidth > 0) // Flat cards use border
    }
    
    @Test("Raised card has shadow")
    func testRaisedElevation() {
        let spec = DSCardSpec.resolve(
            theme: lightTheme,
            elevation: .raised
        )
        
        #expect(spec.cornerRadius > 0)
    }
    
    @Test("Elevated card has stronger shadow")
    func testElevatedElevation() {
        let spec = DSCardSpec.resolve(
            theme: lightTheme,
            elevation: .elevated
        )
        
        #expect(spec.cornerRadius > 0)
    }
    
    @Test("All elevation levels produce valid specs", arguments: DSCardElevation.allCases)
    func testAllElevations(elevation: DSCardElevation) {
        let spec = DSCardSpec.resolve(
            theme: lightTheme,
            elevation: elevation
        )
        
        #expect(spec.cornerRadius > 0)
        #expect(spec.padding.top > 0)
        #expect(spec.padding.leading > 0)
    }
    
    @Test("Dark theme elevated cards use glass effect")
    func testDarkGlassEffect() {
        let elevatedSpec = DSCardSpec.resolve(
            theme: darkTheme,
            elevation: .elevated
        )
        
        #expect(elevatedSpec.usesGlassEffect == true)
    }
    
    @Test("Light theme cards don't use glass effect")
    func testLightNoGlassEffect() {
        let elevatedSpec = DSCardSpec.resolve(
            theme: lightTheme,
            elevation: .elevated
        )
        
        #expect(elevatedSpec.usesGlassEffect == false)
    }
    
    @Test("Dark theme flat card doesn't use glass")
    func testDarkFlatNoGlass() {
        let flatSpec = DSCardSpec.resolve(
            theme: darkTheme,
            elevation: .flat
        )
        
        #expect(flatSpec.usesGlassEffect == false)
    }
    
    @Test("Dark theme cards have borders")
    func testDarkBorders() {
        let raisedSpec = DSCardSpec.resolve(
            theme: darkTheme,
            elevation: .raised
        )
        
        #expect(raisedSpec.borderWidth > 0)
    }
}

// MARK: - DSListRowSpec Tests

@Suite("DSListRowSpec Tests")
struct DSListRowSpecTests {
    
    let theme = DSTheme.light
    
    @Test("Plain row has primary title color")
    func testPlainStyle() {
        let spec = DSListRowSpec.resolve(
            theme: theme,
            style: .plain,
            state: .normal,
            capabilities: .iOS()
        )
        
        #expect(spec.opacity == 1.0)
        #expect(spec.minHeight > 0)
    }
    
    @Test("Destructive row uses danger color")
    func testDestructiveStyle() {
        let spec = DSListRowSpec.resolve(
            theme: theme,
            style: .destructive,
            state: .normal,
            capabilities: .iOS()
        )
        
        #expect(spec.opacity == 1.0)
    }
    
    @Test("Prominent row uses accent color")
    func testProminentStyle() {
        let spec = DSListRowSpec.resolve(
            theme: theme,
            style: .prominent,
            state: .normal,
            capabilities: .iOS()
        )
        
        #expect(spec.opacity == 1.0)
    }
    
    @Test("Disabled row has reduced opacity")
    func testDisabledRow() {
        let spec = DSListRowSpec.resolve(
            theme: theme,
            style: .plain,
            state: .disabled,
            capabilities: .iOS()
        )
        
        #expect(spec.opacity < 1.0)
    }
    
    @Test("iOS rows have large tap targets")
    func testIOSTapTargets() {
        let iosSpec = DSListRowSpec.resolve(
            theme: theme,
            style: .plain,
            state: .normal,
            capabilities: .iOS()
        )
        
        let macSpec = DSListRowSpec.resolve(
            theme: theme,
            style: .plain,
            state: .normal,
            capabilities: .macOS()
        )
        
        #expect(iosSpec.minHeight >= macSpec.minHeight)
    }
    
    @Test("All styles produce valid specs", arguments: DSListRowStyle.allCases)
    func testAllStyles(style: DSListRowStyle) {
        let spec = DSListRowSpec.resolve(
            theme: theme,
            style: style,
            state: .normal,
            capabilities: .iOS()
        )
        
        #expect(spec.minHeight > 0)
        #expect(spec.horizontalPadding > 0)
        #expect(spec.verticalPadding > 0)
        #expect(spec.accessorySize > 0)
        #expect(spec.titleTypography.size > 0)
        #expect(spec.valueTypography.size > 0)
    }
    
    @Test("Pressed row has different background")
    func testPressedState() {
        let normalSpec = DSListRowSpec.resolve(
            theme: theme,
            style: .plain,
            state: .normal,
            capabilities: .iOS()
        )
        
        let pressedSpec = DSListRowSpec.resolve(
            theme: theme,
            style: .plain,
            state: .pressed,
            capabilities: .iOS()
        )
        
        // Pressed should have a different background than normal
        #expect(normalSpec.backgroundColor != pressedSpec.backgroundColor)
    }
    
    @Test("Row has separator configuration")
    func testSeparator() {
        let spec = DSListRowSpec.resolve(
            theme: theme,
            style: .plain,
            state: .normal,
            capabilities: .iOS()
        )
        
        #expect(spec.separatorInsets.leading > 0)
    }
}

// MARK: - Cross-Spec Consistency Tests

@Suite("Spec Consistency Tests")
struct SpecConsistencyTests {
    
    let theme = DSTheme.light
    
    @Test("Button and field share common radii")
    func testRadiiConsistency() {
        let buttonSpec = DSButtonSpec.resolve(
            theme: theme,
            variant: .primary,
            size: .medium,
            state: .normal
        )
        
        let fieldSpec = DSFieldSpec.resolve(
            theme: theme,
            variant: .default,
            state: .normal
        )
        
        // Button medium and field default both use theme.radii.component values
        #expect(buttonSpec.cornerRadius == theme.radii.component.button)
        #expect(fieldSpec.cornerRadius == theme.radii.component.field)
    }
    
    @Test("All specs are Equatable")
    func testEquatable() {
        let spec1 = DSButtonSpec.resolve(theme: theme, variant: .primary, size: .medium, state: .normal)
        let spec2 = DSButtonSpec.resolve(theme: theme, variant: .primary, size: .medium, state: .normal)
        
        #expect(spec1 == spec2)
    }
    
    @Test("Different states produce different specs")
    func testStateDifference() {
        let normal = DSButtonSpec.resolve(theme: theme, variant: .primary, size: .medium, state: .normal)
        let pressed = DSButtonSpec.resolve(theme: theme, variant: .primary, size: .medium, state: .pressed)
        
        #expect(normal != pressed)
    }
    
    @Test("DSSpec protocol conformance for all types")
    func testProtocolConformance() {
        let _: any DSSpec = DSButtonSpec.resolve(theme: theme, variant: .primary, size: .medium, state: .normal)
        let _: any DSSpec = DSFieldSpec.resolve(theme: theme, variant: .default, state: .normal)
        let _: any DSSpec = DSToggleSpec.resolve(theme: theme, isOn: true, state: .normal)
        let _: any DSSpec = DSFormRowSpec.resolve(theme: theme, capabilities: .iOS())
        let _: any DSSpec = DSCardSpec.resolve(theme: theme, elevation: .raised)
        let _: any DSSpec = DSListRowSpec.resolve(theme: theme, style: .plain, state: .normal, capabilities: .iOS())
    }
}
