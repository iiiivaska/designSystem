// DSComponentStylesTests.swift
// DesignSystem

import Testing
import SwiftUI
@testable import DSTheme
@testable import DSCore

// MARK: - DSComponentStyles Tests

@Suite("DSComponentStyles Tests")
struct DSComponentStylesTests {
    
    // MARK: - Registry Tests
    
    @Test("Default registry has all resolvers")
    func testDefaultRegistryComplete() {
        let styles = DSComponentStyles.default
        
        // All resolver IDs should be "default"
        #expect(styles.button.id == "default")
        #expect(styles.field.id == "default")
        #expect(styles.toggle.id == "default")
        #expect(styles.formRow.id == "default")
        #expect(styles.card.id == "default")
        #expect(styles.listRow.id == "default")
    }
    
    @Test("Registry is Equatable")
    func testRegistryEquatable() {
        let a = DSComponentStyles.default
        let b = DSComponentStyles.default
        
        #expect(a == b)
    }
    
    @Test("Custom resolver changes equality")
    func testCustomResolverChangesEquality() {
        let a = DSComponentStyles.default
        
        var b = DSComponentStyles.default
        b.button = DSButtonStyleResolver(id: "custom") { theme, variant, size, state in
            DSButtonSpec.resolve(theme: theme, variant: variant, size: size, state: state)
        }
        
        #expect(a != b)
    }
    
    @Test("Registry initializer with defaults")
    func testRegistryInitializerDefaults() {
        let styles = DSComponentStyles()
        
        #expect(styles == DSComponentStyles.default)
    }
    
    @Test("Registry initializer with custom resolvers")
    func testRegistryInitializerCustom() {
        let customButton = DSButtonStyleResolver(id: "custom-btn") { theme, variant, size, state in
            DSButtonSpec.resolve(theme: theme, variant: variant, size: size, state: state)
        }
        
        let styles = DSComponentStyles(button: customButton)
        
        #expect(styles.button.id == "custom-btn")
        #expect(styles.field.id == "default")
    }
}

// MARK: - Button Style Resolver Tests

@Suite("DSButtonStyleResolver Tests")
struct DSButtonStyleResolverTests {
    
    let theme = DSTheme.light
    
    @Test("Default resolver matches static resolve")
    func testDefaultResolverMatchesStatic() {
        let resolver = DSButtonStyleResolver.default
        
        let resolvedViaResolver = resolver.resolve(
            theme: theme,
            variant: .primary,
            size: .medium,
            state: .normal
        )
        
        let resolvedDirectly = DSButtonSpec.resolve(
            theme: theme,
            variant: .primary,
            size: .medium,
            state: .normal
        )
        
        #expect(resolvedViaResolver == resolvedDirectly)
    }
    
    @Test("Custom resolver produces different results")
    func testCustomResolverDifferentResults() {
        let customResolver = DSButtonStyleResolver(id: "pill") { theme, variant, size, state in
            let base = DSButtonSpec.resolve(theme: theme, variant: variant, size: size, state: state)
            return DSButtonSpec(
                backgroundColor: base.backgroundColor,
                foregroundColor: base.foregroundColor,
                borderColor: base.borderColor,
                borderWidth: base.borderWidth,
                height: base.height,
                horizontalPadding: base.horizontalPadding,
                verticalPadding: base.verticalPadding,
                cornerRadius: 999,
                typography: base.typography,
                shadow: base.shadow,
                opacity: base.opacity,
                scaleEffect: base.scaleEffect,
                animation: base.animation
            )
        }
        
        let spec = customResolver.resolve(
            theme: theme,
            variant: .primary,
            size: .medium,
            state: .normal
        )
        
        #expect(spec.cornerRadius == 999)
    }
    
    @Test("Resolver equality by ID")
    func testResolverEquality() {
        let a = DSButtonStyleResolver.default
        let b = DSButtonStyleResolver.default
        let c = DSButtonStyleResolver(id: "custom") { _, _, _, _ in
            DSButtonSpec.resolve(theme: DSTheme.light, variant: .primary, size: .medium, state: .normal)
        }
        
        #expect(a == b)
        #expect(a != c)
    }
    
    @Test("Default resolver works for all variants")
    func testAllVariants() {
        let resolver = DSButtonStyleResolver.default
        
        for variant in DSButtonVariant.allCases {
            for size in DSButtonSize.allCases {
                let spec = resolver.resolve(theme: theme, variant: variant, size: size, state: .normal)
                #expect(spec.height > 0)
                #expect(spec.opacity == 1.0)
            }
        }
    }
}

// MARK: - Field Style Resolver Tests

@Suite("DSFieldStyleResolver Tests")
struct DSFieldStyleResolverTests {
    
    let theme = DSTheme.light
    
    @Test("Default resolver matches static resolve")
    func testDefaultResolverMatchesStatic() {
        let resolver = DSFieldStyleResolver.default
        
        let resolvedViaResolver = resolver.resolve(
            theme: theme,
            variant: .default,
            state: .normal
        )
        
        let resolvedDirectly = DSFieldSpec.resolve(
            theme: theme,
            variant: .default,
            state: .normal,
            validation: .none
        )
        
        #expect(resolvedViaResolver == resolvedDirectly)
    }
    
    @Test("Custom resolver for taller fields")
    func testCustomResolver() {
        let tallFieldResolver = DSFieldStyleResolver(id: "tall") { theme, variant, state, validation in
            let base = DSFieldSpec.resolve(theme: theme, variant: variant, state: state, validation: validation)
            return DSFieldSpec(
                backgroundColor: base.backgroundColor,
                foregroundColor: base.foregroundColor,
                placeholderColor: base.placeholderColor,
                borderColor: base.borderColor,
                borderWidth: base.borderWidth,
                focusRingColor: base.focusRingColor,
                focusRingWidth: base.focusRingWidth,
                height: 56,
                horizontalPadding: base.horizontalPadding,
                verticalPadding: base.verticalPadding,
                cornerRadius: base.cornerRadius,
                textTypography: base.textTypography,
                placeholderTypography: base.placeholderTypography,
                opacity: base.opacity,
                animation: base.animation
            )
        }
        
        let spec = tallFieldResolver.resolve(
            theme: theme,
            variant: .default,
            state: .normal
        )
        
        #expect(spec.height == 56)
    }
    
    @Test("Resolver equality by ID")
    func testResolverEquality() {
        let a = DSFieldStyleResolver.default
        let b = DSFieldStyleResolver(id: "default") { theme, variant, state, validation in
            DSFieldSpec.resolve(theme: theme, variant: variant, state: state, validation: validation)
        }
        
        #expect(a == b) // same ID
    }
}

// MARK: - Toggle Style Resolver Tests

@Suite("DSToggleStyleResolver Tests")
struct DSToggleStyleResolverTests {
    
    let theme = DSTheme.light
    
    @Test("Default resolver matches static resolve")
    func testDefaultResolverMatchesStatic() {
        let resolver = DSToggleStyleResolver.default
        
        let resolvedViaResolver = resolver.resolve(theme: theme, isOn: true, state: .normal)
        let resolvedDirectly = DSToggleSpec.resolve(theme: theme, isOn: true, state: .normal)
        
        #expect(resolvedViaResolver == resolvedDirectly)
    }
    
    @Test("Resolver resolves on and off states")
    func testOnOffStates() {
        let resolver = DSToggleStyleResolver.default
        
        let onSpec = resolver.resolve(theme: theme, isOn: true, state: .normal)
        let offSpec = resolver.resolve(theme: theme, isOn: false, state: .normal)
        
        #expect(onSpec.trackColor != offSpec.trackColor)
    }
}

// MARK: - FormRow Style Resolver Tests

@Suite("DSFormRowStyleResolver Tests")
struct DSFormRowStyleResolverTests {
    
    let theme = DSTheme.light
    
    @Test("Default resolver matches static resolve")
    func testDefaultResolverMatchesStatic() {
        let resolver = DSFormRowStyleResolver.default
        let capabilities = DSCapabilities.iOS()
        
        let resolvedViaResolver = resolver.resolve(
            theme: theme,
            layoutMode: .auto,
            capabilities: capabilities
        )
        
        let resolvedDirectly = DSFormRowSpec.resolve(
            theme: theme,
            layoutMode: .auto,
            capabilities: capabilities
        )
        
        #expect(resolvedViaResolver == resolvedDirectly)
    }
    
    @Test("Auto-degradation through resolver")
    func testAutoDegradation() {
        let resolver = DSFormRowStyleResolver.default
        
        let iosSpec = resolver.resolve(theme: theme, capabilities: DSCapabilities.iOS())
        let watchSpec = resolver.resolve(theme: theme, capabilities: DSCapabilities.watchOS())
        
        #expect(iosSpec.resolvedLayout == .inline)
        #expect(watchSpec.resolvedLayout == .stacked)
    }
}

// MARK: - Card Style Resolver Tests

@Suite("DSCardStyleResolver Tests")
struct DSCardStyleResolverTests {
    
    @Test("Default resolver matches static resolve")
    func testDefaultResolverMatchesStatic() {
        let theme = DSTheme.light
        let resolver = DSCardStyleResolver.default
        
        for elevation in DSCardElevation.allCases {
            let resolvedViaResolver = resolver.resolve(theme: theme, elevation: elevation)
            let resolvedDirectly = DSCardSpec.resolve(theme: theme, elevation: elevation)
            
            #expect(resolvedViaResolver == resolvedDirectly)
        }
    }
    
    @Test("Custom resolver for no-shadow cards")
    func testCustomNoShadowResolver() {
        let noShadowResolver = DSCardStyleResolver(id: "flat-only") { theme, _ in
            // Always resolve as flat regardless of requested elevation
            DSCardSpec.resolve(theme: theme, elevation: .flat)
        }
        
        let spec = noShadowResolver.resolve(theme: DSTheme.dark, elevation: .overlay)
        
        #expect(spec.shadow == .none)
    }
}

// MARK: - ListRow Style Resolver Tests

@Suite("DSListRowStyleResolver Tests")
struct DSListRowStyleResolverTests {
    
    let theme = DSTheme.light
    let capabilities = DSCapabilities.iOS()
    
    @Test("Default resolver matches static resolve")
    func testDefaultResolverMatchesStatic() {
        let resolver = DSListRowStyleResolver.default
        
        for style in DSListRowStyle.allCases {
            let resolvedViaResolver = resolver.resolve(
                theme: theme,
                style: style,
                state: .normal,
                capabilities: capabilities
            )
            
            let resolvedDirectly = DSListRowSpec.resolve(
                theme: theme,
                style: style,
                state: .normal,
                capabilities: capabilities
            )
            
            #expect(resolvedViaResolver == resolvedDirectly)
        }
    }
}

// MARK: - DSTheme Integration Tests

@Suite("DSTheme Component Styles Integration")
struct DSThemeComponentStylesIntegrationTests {
    
    @Test("Theme has default component styles")
    func testThemeHasDefaultStyles() {
        let theme = DSTheme.light
        
        #expect(theme.componentStyles == DSComponentStyles.default)
    }
    
    @Test("Dark theme has default component styles")
    func testDarkThemeHasDefaultStyles() {
        let theme = DSTheme.dark
        
        #expect(theme.componentStyles == DSComponentStyles.default)
    }
    
    @Test("Theme with custom component styles")
    func testThemeWithCustomStyles() {
        var styles = DSComponentStyles.default
        styles.button = DSButtonStyleResolver(id: "custom") { theme, variant, size, state in
            DSButtonSpec.resolve(theme: theme, variant: variant, size: size, state: state)
        }
        
        let theme = DSTheme(variant: .light, componentStyles: styles)
        
        #expect(theme.componentStyles.button.id == "custom")
    }
    
    @Test("Theme resolveButton convenience method")
    func testResolveButtonConvenience() {
        let theme = DSTheme.light
        
        let spec = theme.resolveButton(variant: .primary, size: .medium, state: .normal)
        let directSpec = DSButtonSpec.resolve(theme: theme, variant: .primary, size: .medium, state: .normal)
        
        #expect(spec == directSpec)
    }
    
    @Test("Theme resolveField convenience method")
    func testResolveFieldConvenience() {
        let theme = DSTheme.light
        
        let spec = theme.resolveField(variant: .default, state: .normal)
        let directSpec = DSFieldSpec.resolve(theme: theme, variant: .default, state: .normal)
        
        #expect(spec == directSpec)
    }
    
    @Test("Theme resolveToggle convenience method")
    func testResolveToggleConvenience() {
        let theme = DSTheme.light
        
        let spec = theme.resolveToggle(isOn: true, state: .normal)
        let directSpec = DSToggleSpec.resolve(theme: theme, isOn: true, state: .normal)
        
        #expect(spec == directSpec)
    }
    
    @Test("Theme resolveFormRow convenience method")
    func testResolveFormRowConvenience() {
        let theme = DSTheme.light
        let capabilities = DSCapabilities.iOS()
        
        let spec = theme.resolveFormRow(capabilities: capabilities)
        let directSpec = DSFormRowSpec.resolve(theme: theme, capabilities: capabilities)
        
        #expect(spec == directSpec)
    }
    
    @Test("Theme resolveCard convenience method")
    func testResolveCardConvenience() {
        let theme = DSTheme.light
        
        let spec = theme.resolveCard(elevation: .raised)
        let directSpec = DSCardSpec.resolve(theme: theme, elevation: .raised)
        
        #expect(spec == directSpec)
    }
    
    @Test("Theme resolveListRow convenience method")
    func testResolveListRowConvenience() {
        let theme = DSTheme.light
        let capabilities = DSCapabilities.iOS()
        
        let spec = theme.resolveListRow(style: .plain, state: .normal, capabilities: capabilities)
        let directSpec = DSListRowSpec.resolve(theme: theme, style: .plain, state: .normal, capabilities: capabilities)
        
        #expect(spec == directSpec)
    }
    
    @Test("Custom styles flow through convenience methods")
    func testCustomStylesThroughConvenience() {
        var styles = DSComponentStyles.default
        styles.card = DSCardStyleResolver(id: "always-flat") { theme, _ in
            DSCardSpec.resolve(theme: theme, elevation: .flat)
        }
        
        let theme = DSTheme(variant: .light, componentStyles: styles)
        
        // resolveCard should use the custom resolver
        let flatSpec = theme.resolveCard(elevation: .flat)
        let overlaySpec = theme.resolveCard(elevation: .overlay)
        
        // Both should resolve to flat (since our custom resolver ignores elevation)
        #expect(flatSpec == overlaySpec)
    }
    
    @Test("Theme with accessibility retains component styles")
    func testAccessibilityRetainsStyles() {
        var styles = DSComponentStyles.default
        styles.button = DSButtonStyleResolver(id: "custom") { theme, variant, size, state in
            DSButtonSpec.resolve(theme: theme, variant: variant, size: size, state: state)
        }
        
        let theme = DSTheme(
            variant: .light,
            accessibility: .default,
            componentStyles: styles
        )
        
        #expect(theme.componentStyles.button.id == "custom")
    }
    
    @Test("Theme equality includes component styles")
    func testEqualityIncludesStyles() {
        let theme1 = DSTheme(variant: .light, componentStyles: .default)
        let theme2 = DSTheme(variant: .light, componentStyles: .default)
        
        var customStyles = DSComponentStyles.default
        customStyles.button = DSButtonStyleResolver(id: "custom") { theme, variant, size, state in
            DSButtonSpec.resolve(theme: theme, variant: variant, size: size, state: state)
        }
        let theme3 = DSTheme(variant: .light, componentStyles: customStyles)
        
        #expect(theme1 == theme2)
        #expect(theme1 != theme3)
    }
}
