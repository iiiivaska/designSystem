// DSPicker.swift
// DesignSystem
//
// Platform-adaptive picker control with multiple presentation modes.
// Uses DSCapabilities to determine the best presentation per platform.

import SwiftUI
import DSCore
import DSTheme
import DSPrimitives

// MARK: - DSPickerMode

/// Presentation mode for ``DSPicker``.
///
/// Determines how the picker options are presented to the user.
/// Use ``auto`` to let the platform capabilities decide the best
/// presentation automatically.
///
/// ## Overview
///
/// | Mode | Presentation |
/// |------|-------------|
/// | ``auto`` | Determined by ``DSCapabilities/preferredPickerPresentation`` |
/// | ``sheet`` | Modal sheet from bottom (iOS default) |
/// | ``popover`` | Popover near trigger (macOS/iPadOS) |
/// | ``menu`` | Drop-down menu (macOS default) |
/// | ``navigation`` | Navigation push (watchOS default) |
///
/// ## Usage
///
/// ```swift
/// // Let the platform decide
/// DSPicker("Sort", selection: $sort, options: SortOrder.allCases, mode: .auto) {
///     Text($0.name)
/// }
///
/// // Force a specific presentation
/// DSPicker("Sort", selection: $sort, options: SortOrder.allCases, mode: .sheet) {
///     Text($0.name)
/// }
/// ```
///
/// ## Topics
///
/// ### Modes
///
/// - ``auto``
/// - ``sheet``
/// - ``popover``
/// - ``menu``
/// - ``navigation``
public enum DSPickerMode: String, Sendable, Equatable, Hashable, CaseIterable {
    
    /// Automatically select presentation based on platform capabilities.
    ///
    /// Resolves to:
    /// - iOS: ``sheet``
    /// - macOS: ``menu``
    /// - watchOS: ``navigation``
    case auto
    
    /// Present options in a modal sheet.
    ///
    /// Slides up from the bottom of the screen.
    /// Standard presentation for iOS pickers.
    case sheet
    
    /// Present options in a popover.
    ///
    /// Appears near the triggering element.
    /// Best for macOS and iPadOS with pointer.
    case popover
    
    /// Present options as a drop-down menu.
    ///
    /// Compact inline menu presentation.
    /// Preferred on macOS for small option sets.
    case menu
    
    /// Present options via navigation push.
    ///
    /// Pushes a full selection list onto the navigation stack.
    /// Required on watchOS where modals are limited.
    case navigation
    
    /// Resolves the effective presentation from capabilities when mode is `.auto`.
    ///
    /// - Parameter capabilities: The platform capabilities to query.
    /// - Returns: The resolved concrete ``DSPickerPresentation``.
    func resolved(with capabilities: DSCapabilities) -> DSPickerPresentation {
        switch self {
        case .auto:
            return capabilities.preferredPickerPresentation
        case .sheet:
            return .sheet
        case .popover:
            return .popover
        case .menu:
            return .menu
        case .navigation:
            return .navigation
        }
    }
}

// MARK: - DSPicker

/// A platform-adaptive picker control with themed styling.
///
/// `DSPicker` provides a generic single-selection picker that automatically
/// adapts its presentation to the current platform using ``DSCapabilities``.
/// It follows the design system's theming and accessibility guidelines.
///
/// ## Overview
///
/// ```swift
/// enum Fruit: String, CaseIterable, Identifiable {
///     case apple, banana, cherry
///     var id: String { rawValue }
///     var name: String { rawValue.capitalized }
/// }
///
/// @State private var selectedFruit: Fruit = .apple
///
/// DSPicker("Fruit", selection: $selectedFruit, options: Fruit.allCases) { fruit in
///     Text(fruit.name)
/// }
/// ```
///
/// ## Platform Behavior
///
/// | Platform | Default Presentation |
/// |----------|---------------------|
/// | iOS | Sheet from bottom |
/// | macOS | Drop-down menu |
/// | watchOS | Navigation push |
///
/// ## Presentation Modes
///
/// Override the default presentation with the `mode` parameter:
///
/// ```swift
/// // Force sheet on all platforms
/// DSPicker("Sort", selection: $sort, options: options, mode: .sheet) {
///     Text($0.name)
/// }
///
/// // Force popover
/// DSPicker("Sort", selection: $sort, options: options, mode: .popover) {
///     Text($0.name)
/// }
/// ```
///
/// ## Customization
///
/// - **Icon**: Add a leading SF Symbol icon to the trigger.
/// - **Placeholder**: Shown when no value is selected (optional selection).
/// - **Disabled**: Prevents interaction when `isDisabled` is true.
///
/// ## Accessibility
///
/// - Trigger announces the title and current selection via VoiceOver.
/// - Selection list items announce option labels.
/// - Disabled state is communicated via the `.disabled()` modifier.
///
/// ## Topics
///
/// ### Creating Pickers
///
/// - ``init(_:selection:options:mode:icon:isDisabled:optionLabel:)``
///
/// ### Configuration
///
/// - ``DSPickerMode``
///
/// ### Styling
///
/// The picker trigger uses ``DSFieldSpec`` for consistent
/// field-like appearance matching text fields.
public struct DSPicker<SelectionValue: Hashable & Identifiable & Sendable, OptionLabel: View>: View {
    
    // MARK: - Properties
    
    /// The picker title/label text.
    private let title: LocalizedStringKey
    
    /// Binding to the selected value.
    @Binding private var selection: SelectionValue
    
    /// Available options to select from.
    private let options: [SelectionValue]
    
    /// Presentation mode.
    private let mode: DSPickerMode
    
    /// Optional leading SF Symbol icon name for the trigger.
    private let icon: String?
    
    /// Whether the picker is disabled.
    private let isDisabled: Bool
    
    /// Builder that creates a label view for each option.
    private let optionLabel: (SelectionValue) -> OptionLabel
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme: DSTheme
    @Environment(\.dsCapabilities) private var capabilities: DSCapabilities
    
    // MARK: - State
    
    @State private var isSheetPresented = false
    @State private var isPopoverPresented = false
    @State private var isNavigationActive = false
    
    // MARK: - Initializer
    
    /// Creates a platform-adaptive picker.
    ///
    /// - Parameters:
    ///   - title: The picker label text.
    ///   - selection: A binding to the currently selected value.
    ///   - options: The array of selectable options.
    ///   - mode: The presentation mode. Defaults to ``DSPickerMode/auto``.
    ///   - icon: Optional SF Symbol name for a leading icon on the trigger.
    ///   - isDisabled: Whether the picker is disabled. Defaults to `false`.
    ///   - optionLabel: A view builder that creates a label for each option.
    public init(
        _ title: LocalizedStringKey,
        selection: Binding<SelectionValue>,
        options: [SelectionValue],
        mode: DSPickerMode = .auto,
        icon: String? = nil,
        isDisabled: Bool = false,
        @ViewBuilder optionLabel: @escaping (SelectionValue) -> OptionLabel
    ) {
        self.title = title
        self._selection = selection
        self.options = options
        self.mode = mode
        self.icon = icon
        self.isDisabled = isDisabled
        self.optionLabel = optionLabel
    }
    
    // MARK: - Resolved Presentation
    
    /// The resolved presentation mode based on capabilities.
    private var resolvedPresentation: DSPickerPresentation {
        mode.resolved(with: capabilities)
    }
    
    /// The resolved field spec for the trigger's appearance.
    private var fieldSpec: DSFieldSpec {
        let state: DSControlState = isDisabled ? .disabled : .normal
        return theme.resolveField(variant: .default, state: state)
    }
    
    // MARK: - Body
    
    public var body: some View {
        pickerContent
            // Unified dismiss handler: when selection changes, close any open presentation
            .onChange(of: selection) {
                isSheetPresented = false
                isPopoverPresented = false
                isNavigationActive = false
            }
    }
    
    @ViewBuilder
    private var pickerContent: some View {
        switch resolvedPresentation {
        case .menu:
            menuPresentation
        case .sheet:
            sheetPresentation
        case .popover:
            popoverPresentation
        case .navigation:
            navigationPresentation
        }
    }
    
    // MARK: - Menu Presentation
    
    /// Menu-style picker (macOS default, compact).
    private var menuPresentation: some View {
        Menu {
            ForEach(options) { option in
                Button {
                    selection = option
                } label: {
                    HStack {
                        optionLabel(option)
                        if option.id == selection.id {
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundStyle(theme.colors.accent.primary)
                        }
                    }
                }
            }
        } label: {
            triggerContent
        }
        // Force re-render of Menu label when selection changes
        .id(selection.id)
        .disabled(isDisabled)
        .accessibilityLabel(title)
    }
    
    // MARK: - Sheet Presentation
    
    /// Sheet-style picker (iOS default).
    private var sheetPresentation: some View {
        Button {
            isSheetPresented = true
        } label: {
            triggerContent
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .accessibilityLabel(title)
        .sheet(isPresented: $isSheetPresented) {
            NavigationStack {
                optionsListView
                #if !os(watchOS)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") {
                            isSheetPresented = false
                        }
                        .foregroundStyle(theme.colors.accent.primary)
                    }
                }
                #endif
            }
            .dsTheme(theme)
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
    
    // MARK: - Popover Presentation
    
    /// Popover-style picker (macOS alternative, iPadOS).
    private var popoverPresentation: some View {
        Button {
            isPopoverPresented = true
        } label: {
            triggerContent
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .accessibilityLabel(title)
        .popover(isPresented: $isPopoverPresented) {
            NavigationStack {
                optionsListView
                #if !os(watchOS)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") {
                            isPopoverPresented = false
                        }
                        .foregroundStyle(theme.colors.accent.primary)
                    }
                }
                #endif
            }
            .dsTheme(theme)
            .frame(minWidth: 220, minHeight: 200)
        }
    }
    
    // MARK: - Navigation Presentation
    
    /// Navigation-style picker (watchOS default).
    ///
    /// Uses `navigationDestination(isPresented:)` for programmatic
    /// push/pop control that auto-pops after selection via `onChange`.
    private var navigationPresentation: some View {
        Button {
            isNavigationActive = true
        } label: {
            triggerContent
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .accessibilityLabel(title)
        .navigationDestination(isPresented: $isNavigationActive) {
            optionsListView
                .dsTheme(theme)
        }
    }
    
    // MARK: - Trigger Content
    
    /// The trigger button content that displays the title, selected value, and chevron.
    @ViewBuilder
    private var triggerContent: some View {
        let spec = fieldSpec
        
        HStack(spacing: theme.spacing.padding.s) {
            // Leading icon
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(isDisabled ? theme.colors.fg.disabled : theme.colors.fg.secondary)
            }
            
            // Title
            Text(title)
                .font(spec.textTypography.font)
                .foregroundStyle(isDisabled ? theme.colors.fg.disabled : theme.colors.fg.primary)
            
            Spacer()
            
            // Selected value label — .id forces re-render when selection changes
            optionLabel(selection)
                .id(selection.id)
                .font(theme.typography.component.rowValue.font)
                .foregroundStyle(isDisabled ? theme.colors.fg.disabled : theme.colors.fg.secondary)
            
            // Chevron indicator
            Image(systemName: chevronIcon)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(isDisabled ? theme.colors.fg.disabled : theme.colors.fg.tertiary)
        }
        .padding(.horizontal, spec.horizontalPadding)
        .frame(minHeight: spec.height)
        .background(spec.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: spec.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: spec.cornerRadius)
                .stroke(spec.borderColor, lineWidth: spec.borderWidth)
        )
        .opacity(spec.opacity)
        .contentShape(Rectangle())
    }
    
    /// Chevron icon based on resolved presentation.
    private var chevronIcon: String {
        switch resolvedPresentation {
        case .menu:
            return "chevron.up.chevron.down"
        case .navigation:
            return "chevron.right"
        case .sheet, .popover:
            return "chevron.down"
        }
    }
    
    // MARK: - Options List (shared)
    
    /// The selectable options list used by sheet, popover, and navigation presentations.
    private var optionsListView: some View {
        DSPickerOptionsList(
            title: title,
            selection: $selection,
            options: options,
            theme: theme,
            optionLabel: optionLabel
        )
    }
}

// MARK: - String Initializer

extension DSPicker {
    
    /// Creates a platform-adaptive picker with a plain string title.
    ///
    /// - Parameters:
    ///   - title: The picker label string.
    ///   - selection: A binding to the currently selected value.
    ///   - options: The array of selectable options.
    ///   - mode: The presentation mode. Defaults to ``DSPickerMode/auto``.
    ///   - icon: Optional SF Symbol name for a leading icon on the trigger.
    ///   - isDisabled: Whether the picker is disabled. Defaults to `false`.
    ///   - optionLabel: A view builder that creates a label for each option.
    public init<S: StringProtocol>(
        _ title: S,
        selection: Binding<SelectionValue>,
        options: [SelectionValue],
        mode: DSPickerMode = .auto,
        icon: String? = nil,
        isDisabled: Bool = false,
        @ViewBuilder optionLabel: @escaping (SelectionValue) -> OptionLabel
    ) {
        self.title = LocalizedStringKey(String(title))
        self._selection = selection
        self.options = options
        self.mode = mode
        self.icon = icon
        self.isDisabled = isDisabled
        self.optionLabel = optionLabel
    }
}

// MARK: - DSPickerOptionsList

/// Internal selection list view used by ``DSPicker`` for sheet, popover,
/// and navigation presentations.
///
/// Displays a scrollable list of options with checkmarks indicating the
/// current selection. Themed with the design system's accent colors.
///
/// **Important:** This view only sets the `selection` binding — it does NOT
/// call `dismiss()`. The parent ``DSPicker`` handles all dismissal/navigation
/// via a unified `.onChange(of: selection)` handler.
struct DSPickerOptionsList<SelectionValue: Hashable & Identifiable & Sendable, OptionLabel: View>: View {
    
    /// The picker title displayed as the navigation title.
    let title: LocalizedStringKey
    
    /// Binding to the selected value.
    @Binding var selection: SelectionValue
    
    /// Available options.
    let options: [SelectionValue]
    
    /// The current theme.
    let theme: DSTheme
    
    /// Builder for option labels.
    let optionLabel: (SelectionValue) -> OptionLabel
    
    var body: some View {
        List(options) { option in
            Button {
                // Only set selection — parent's onChange handles dismissal
                selection = option
            } label: {
                HStack {
                    optionLabel(option)
                        .foregroundStyle(theme.colors.fg.primary)
                    
                    Spacer()
                    
                    if option.id == selection.id {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(theme.colors.accent.primary)
                    }
                }
                .padding(.vertical, 4)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .listRowBackground(
                option.id == selection.id
                    ? theme.colors.accent.primary.opacity(0.08)
                    : Color.clear
            )
            .accessibilityAddTraits(option.id == selection.id ? .isSelected : [])
        }
        .navigationTitle(title)
    }
}

// MARK: - Previews — Demo Option Type

/// A sample option type used in previews.
private enum PreviewFruit: String, CaseIterable, Identifiable, Sendable {
    case apple = "Apple"
    case banana = "Banana"
    case cherry = "Cherry"
    case date = "Date"
    case elderberry = "Elderberry"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .apple: return "leaf"
        case .banana: return "moon"
        case .cherry: return "heart"
        case .date: return "calendar"
        case .elderberry: return "star"
        }
    }
}

// MARK: - Previews — Menu Mode

#Preview("Menu Mode - Light") {
    @Previewable @State var selection = PreviewFruit.apple
    VStack(spacing: 24) {
        DSPicker("Fruit", selection: $selection, options: PreviewFruit.allCases, mode: .menu) {
            Text($0.rawValue)
        }
        DSPicker("With Icon", selection: $selection, options: PreviewFruit.allCases, mode: .menu, icon: "leaf") {
            Text($0.rawValue)
        }
        DSPicker("Disabled", selection: $selection, options: PreviewFruit.allCases, mode: .menu, isDisabled: true) {
            Text($0.rawValue)
        }
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Menu Mode - Dark") {
    @Previewable @State var selection = PreviewFruit.apple
    VStack(spacing: 24) {
        DSPicker("Fruit", selection: $selection, options: PreviewFruit.allCases, mode: .menu) {
            Text($0.rawValue)
        }
        DSPicker("With Icon", selection: $selection, options: PreviewFruit.allCases, mode: .menu, icon: "leaf") {
            Text($0.rawValue)
        }
        DSPicker("Disabled", selection: $selection, options: PreviewFruit.allCases, mode: .menu, isDisabled: true) {
            Text($0.rawValue)
        }
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

// MARK: - Previews — Sheet Mode

#Preview("Sheet Mode - Light") {
    @Previewable @State var selection = PreviewFruit.banana
    VStack(spacing: 24) {
        DSPicker("Fruit", selection: $selection, options: PreviewFruit.allCases, mode: .sheet) {
            Text($0.rawValue)
        }
        DSPicker("With Icon", selection: $selection, options: PreviewFruit.allCases, mode: .sheet, icon: "leaf") {
            Text($0.rawValue)
        }
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Sheet Mode - Dark") {
    @Previewable @State var selection = PreviewFruit.banana
    VStack(spacing: 24) {
        DSPicker("Fruit", selection: $selection, options: PreviewFruit.allCases, mode: .sheet) {
            Text($0.rawValue)
        }
        DSPicker("With Icon", selection: $selection, options: PreviewFruit.allCases, mode: .sheet, icon: "leaf") {
            Text($0.rawValue)
        }
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

// MARK: - Previews — Navigation Mode

#Preview("Navigation Mode - Light") {
    @Previewable @State var selection = PreviewFruit.cherry
    NavigationStack {
        VStack(spacing: 24) {
            DSPicker("Fruit", selection: $selection, options: PreviewFruit.allCases, mode: .navigation) {
                Text($0.rawValue)
            }
            DSPicker("With Icon", selection: $selection, options: PreviewFruit.allCases, mode: .navigation, icon: "leaf") {
                Text($0.rawValue)
            }
        }
        .padding()
        .navigationTitle("Navigation Picker")
    }
    .dsTheme(.light)
}

#Preview("Navigation Mode - Dark") {
    @Previewable @State var selection = PreviewFruit.cherry
    NavigationStack {
        VStack(spacing: 24) {
            DSPicker("Fruit", selection: $selection, options: PreviewFruit.allCases, mode: .navigation) {
                Text($0.rawValue)
            }
            DSPicker("With Icon", selection: $selection, options: PreviewFruit.allCases, mode: .navigation, icon: "leaf") {
                Text($0.rawValue)
            }
        }
        .padding()
        .navigationTitle("Navigation Picker")
    }
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

// MARK: - Previews — Popover Mode

#Preview("Popover Mode - Light") {
    @Previewable @State var selection = PreviewFruit.date
    VStack(spacing: 24) {
        DSPicker("Fruit", selection: $selection, options: PreviewFruit.allCases, mode: .popover) {
            Text($0.rawValue)
        }
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Popover Mode - Dark") {
    @Previewable @State var selection = PreviewFruit.date
    VStack(spacing: 24) {
        DSPicker("Fruit", selection: $selection, options: PreviewFruit.allCases, mode: .popover) {
            Text($0.rawValue)
        }
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

// MARK: - Previews — Auto Mode (Platform Default)

#Preview("Auto Mode - Light") {
    @Previewable @State var selection = PreviewFruit.apple
    NavigationStack {
        VStack(spacing: 24) {
            DSPicker("Fruit", selection: $selection, options: PreviewFruit.allCases) {
                Text($0.rawValue)
            }
            DSPicker("With Icon", selection: $selection, options: PreviewFruit.allCases, icon: "leaf") {
                Text($0.rawValue)
            }
            DSPicker("Disabled", selection: $selection, options: PreviewFruit.allCases, isDisabled: true) {
                Text($0.rawValue)
            }
        }
        .padding()
        .navigationTitle("Auto Picker")
    }
    .dsTheme(.light)
}

#Preview("Auto Mode - Dark") {
    @Previewable @State var selection = PreviewFruit.apple
    NavigationStack {
        VStack(spacing: 24) {
            DSPicker("Fruit", selection: $selection, options: PreviewFruit.allCases) {
                Text($0.rawValue)
            }
            DSPicker("With Icon", selection: $selection, options: PreviewFruit.allCases, icon: "leaf") {
                Text($0.rawValue)
            }
            DSPicker("Disabled", selection: $selection, options: PreviewFruit.allCases, isDisabled: true) {
                Text($0.rawValue)
            }
        }
        .padding()
        .navigationTitle("Auto Picker")
    }
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

// MARK: - Previews — All Modes Comparison

#Preview("All Modes Comparison") {
    @Previewable @State var menuSelection = PreviewFruit.apple
    @Previewable @State var sheetSelection = PreviewFruit.banana
    @Previewable @State var popoverSelection = PreviewFruit.cherry
    @Previewable @State var navSelection = PreviewFruit.date
    @Previewable @State var autoSelection = PreviewFruit.elderberry
    
    NavigationStack {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Menu").font(.caption).foregroundStyle(.secondary)
                DSPicker("Fruit", selection: $menuSelection, options: PreviewFruit.allCases, mode: .menu) {
                    Text($0.rawValue)
                }
                
                Divider()
                
                Text("Sheet").font(.caption).foregroundStyle(.secondary)
                DSPicker("Fruit", selection: $sheetSelection, options: PreviewFruit.allCases, mode: .sheet) {
                    Text($0.rawValue)
                }
                
                Divider()
                
                Text("Popover").font(.caption).foregroundStyle(.secondary)
                DSPicker("Fruit", selection: $popoverSelection, options: PreviewFruit.allCases, mode: .popover) {
                    Text($0.rawValue)
                }
                
                Divider()
                
                Text("Navigation").font(.caption).foregroundStyle(.secondary)
                DSPicker("Fruit", selection: $navSelection, options: PreviewFruit.allCases, mode: .navigation) {
                    Text($0.rawValue)
                }
                
                Divider()
                
                Text("Auto").font(.caption).foregroundStyle(.secondary)
                DSPicker("Fruit", selection: $autoSelection, options: PreviewFruit.allCases, mode: .auto) {
                    Text($0.rawValue)
                }
            }
            .padding()
        }
        .navigationTitle("All Modes")
    }
    .dsTheme(.light)
}
