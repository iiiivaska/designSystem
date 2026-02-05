import SwiftUI

// MARK: - AnyDSFormRow

/// A type-erased wrapper for form rows.
///
/// `AnyDSFormRow` enables heterogeneous row collections in forms,
/// where different row types can coexist in the same array or list.
///
/// ## Overview
///
/// ```swift
/// let rows: [AnyDSFormRow] = [
///     AnyDSFormRow(TextFieldRow(title: "Name", text: $name)),
///     AnyDSFormRow(ToggleRow(title: "Enabled", isOn: $enabled)),
///     AnyDSFormRow(PickerRow(title: "Option", selection: $option))
/// ]
///
/// ForEach(rows) { row in
///     row
/// }
/// ```
///
/// ## Topics
///
/// ### Creating Rows
///
/// - ``init(id:content:)``
/// - ``init(_:id:)``
///
/// ### Properties
///
/// - ``id``
@MainActor
public struct AnyDSFormRow: View, Identifiable {
    
    /// Unique identifier for the row.
    ///
    /// Used by `ForEach` and other collection views to track row identity.
    public nonisolated let id: UUID
    
    /// The underlying row view.
    private let content: AnyView
    
    /// Creates a type-erased form row using a view builder.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for the row. Defaults to a new UUID.
    ///   - content: A view builder that produces the row content.
    public init(id: UUID = UUID(), @ViewBuilder content: () -> some View) {
        self.id = id
        self.content = AnyView(content())
    }
    
    /// Creates a type-erased form row from an existing view.
    ///
    /// - Parameters:
    ///   - content: The view to wrap.
    ///   - id: A unique identifier for the row. Defaults to a new UUID.
    public init<Content: View>(_ content: Content, id: UUID = UUID()) {
        self.id = id
        self.content = AnyView(content)
    }
    
    public var body: some View {
        content
    }
}

// MARK: - AnyDSFormSection

/// A type-erased wrapper for form sections.
///
/// `AnyDSFormSection` enables heterogeneous section collections in forms.
///
/// ## Usage
///
/// ```swift
/// let sections: [AnyDSFormSection] = [
///     AnyDSFormSection(PersonalInfoSection()),
///     AnyDSFormSection(PreferencesSection())
/// ]
/// ```
///
/// ## Topics
///
/// ### Creating Sections
///
/// - ``init(id:content:)``
/// - ``init(_:id:)``
///
/// ### Properties
///
/// - ``id``
@MainActor
public struct AnyDSFormSection: View, Identifiable {
    
    /// Unique identifier for the section.
    public nonisolated let id: UUID
    
    /// The underlying section view.
    private let content: AnyView
    
    /// Creates a type-erased form section using a view builder.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for the section. Defaults to a new UUID.
    ///   - content: A view builder that produces the section content.
    public init(id: UUID = UUID(), @ViewBuilder content: () -> some View) {
        self.id = id
        self.content = AnyView(content())
    }
    
    /// Creates a type-erased form section from an existing view.
    ///
    /// - Parameters:
    ///   - content: The view to wrap.
    ///   - id: A unique identifier for the section. Defaults to a new UUID.
    public init<Content: View>(_ content: Content, id: UUID = UUID()) {
        self.id = id
        self.content = AnyView(content)
    }
    
    public var body: some View {
        content
    }
}

// MARK: - AnyDSControl

/// A type-erased wrapper for controls in form row slots.
///
/// Use `AnyDSControl` to wrap controls when building custom row layouts
/// with flexible control slots.
///
/// ## Usage
///
/// ```swift
/// let control = AnyDSControl {
///     Toggle("", isOn: $value)
/// }
/// ```
///
/// ## Topics
///
/// ### Creating Controls
///
/// - ``init(content:)``
/// - ``init(_:)``
@MainActor
public struct AnyDSControl: View {
    
    private let content: AnyView
    
    /// Creates a type-erased control using a view builder.
    ///
    /// - Parameter content: A view builder that produces the control.
    public init<Content: View>(@ViewBuilder content: () -> Content) {
        self.content = AnyView(content())
    }
    
    /// Creates a type-erased control from an existing view.
    ///
    /// - Parameter content: The view to wrap.
    public init<Content: View>(_ content: Content) {
        self.content = AnyView(content)
    }
    
    public var body: some View {
        content
    }
}

// MARK: - AnyDSAccessory

/// A type-erased wrapper for row accessories.
///
/// Use `AnyDSAccessory` to wrap trailing accessories like disclosure
/// indicators, value displays, or action buttons.
///
/// ## Usage
///
/// ```swift
/// let accessory = AnyDSAccessory {
///     Image(systemName: "chevron.right")
/// }
/// ```
///
/// ## Topics
///
/// ### Creating Accessories
///
/// - ``init(content:)``
@MainActor
public struct AnyDSAccessory: View {
    
    private let content: AnyView
    
    /// Creates a type-erased accessory using a view builder.
    ///
    /// - Parameter content: A view builder that produces the accessory.
    public init<Content: View>(@ViewBuilder content: () -> Content) {
        self.content = AnyView(content())
    }
    
    public var body: some View {
        content
    }
}

// MARK: - DSRowSlotContent

/// Protocol for views that can fill a form row slot.
///
/// Conform to this protocol to indicate which slot type your
/// content is designed for.
///
/// ## Conformance
///
/// ```swift
/// struct MyLeadingIcon: View, DSRowSlotContent {
///     static var slotType: DSRowSlotType { .leadingIcon }
///
///     var body: some View {
///         Image(systemName: "star")
///     }
/// }
/// ```
///
/// - SeeAlso: ``DSRowSlotType``
@MainActor
public protocol DSRowSlotContent: View {
    /// The slot type this content is intended for.
    static var slotType: DSRowSlotType { get }
}

// MARK: - DSRowSlotType

/// Types of slots in a form row.
///
/// Form rows are composed of multiple slots that can hold different
/// types of content.
///
/// ## Slot Layout
///
/// ```
/// ┌─────────────────────────────────────────────┐
/// │ [leadingIcon] [label    ] [control] [access]│
/// │               [footer                      ]│
/// └─────────────────────────────────────────────┘
/// ```
///
/// ## Topics
///
/// ### Visual Slots
///
/// - ``leadingIcon``
/// - ``label``
/// - ``footer``
///
/// ### Interactive Slots
///
/// - ``control``
/// - ``accessory``
public enum DSRowSlotType: String, Sendable, Equatable, Hashable, CaseIterable {
    
    /// Leading icon or image.
    ///
    /// Typically an SF Symbol or small image displayed before the label.
    case leadingIcon
    
    /// Main label/title.
    ///
    /// The primary text content of the row.
    case label
    
    /// Primary control (input, toggle, etc.).
    ///
    /// The interactive element of the row.
    case control
    
    /// Trailing accessory (chevron, value display, etc.).
    ///
    /// Secondary content displayed after the control.
    case accessory
    
    /// Footer/helper text.
    ///
    /// Additional information displayed below the main row content.
    case footer
}

// MARK: - DSRowBuilder

/// Result builder for constructing row content.
///
/// Use this builder with view modifiers or custom row implementations.
///
/// ## Usage
///
/// ```swift
/// func customRow(@DSRowBuilder content: () -> some View) -> some View {
///     content()
/// }
/// ```
@MainActor
@resultBuilder
public struct DSRowBuilder {
    
    public static func buildBlock<Content: View>(_ content: Content) -> some View {
        content
    }
    
    public static func buildOptional<Content: View>(_ content: Content?) -> some View {
        content
    }
    
    public static func buildEither<First: View, Second: View>(first: First) -> some View {
        first
    }
    
    public static func buildEither<First: View, Second: View>(second: Second) -> some View {
        second
    }
}

// MARK: - DSSectionBuilder

/// Result builder for constructing section content with rows.
///
/// Use this builder to create sections with variadic row content.
///
/// ## Usage
///
/// ```swift
/// func customSection(
///     @DSSectionBuilder rows: () -> [AnyDSFormRow]
/// ) -> some View {
///     ForEach(rows()) { row in
///         row
///     }
/// }
/// ```
@MainActor
@resultBuilder
public struct DSSectionBuilder {
    
    public static func buildBlock(_ rows: AnyDSFormRow...) -> [AnyDSFormRow] {
        rows
    }
    
    public static func buildOptional(_ rows: [AnyDSFormRow]?) -> [AnyDSFormRow] {
        rows ?? []
    }
    
    public static func buildEither(first rows: [AnyDSFormRow]) -> [AnyDSFormRow] {
        rows
    }
    
    public static func buildEither(second rows: [AnyDSFormRow]) -> [AnyDSFormRow] {
        rows
    }
    
    public static func buildArray(_ components: [[AnyDSFormRow]]) -> [AnyDSFormRow] {
        components.flatMap { $0 }
    }
}

// MARK: - DSFormBuilder

/// Result builder for constructing forms with sections.
///
/// Use this builder to create forms with variadic section content.
///
/// ## Usage
///
/// ```swift
/// func customForm(
///     @DSFormBuilder sections: () -> [AnyDSFormSection]
/// ) -> some View {
///     ForEach(sections()) { section in
///         section
///     }
/// }
/// ```
@MainActor
@resultBuilder
public struct DSFormBuilder {
    
    public static func buildBlock(_ sections: AnyDSFormSection...) -> [AnyDSFormSection] {
        sections
    }
    
    public static func buildOptional(_ sections: [AnyDSFormSection]?) -> [AnyDSFormSection] {
        sections ?? []
    }
    
    public static func buildEither(first sections: [AnyDSFormSection]) -> [AnyDSFormSection] {
        sections
    }
    
    public static func buildEither(second sections: [AnyDSFormSection]) -> [AnyDSFormSection] {
        sections
    }
    
    public static func buildArray(_ components: [[AnyDSFormSection]]) -> [AnyDSFormSection] {
        components.flatMap { $0 }
    }
}

// MARK: - DSIdentifiable

/// Wraps any value to make it `Identifiable` with a sendable ID.
///
/// Use `DSIdentifiable` when you need to iterate over values that
/// don't naturally conform to `Identifiable`.
///
/// ## Usage
///
/// ```swift
/// let items = ["Apple", "Banana", "Cherry"]
///     .map { DSIdentifiable(value: $0) }
///
/// ForEach(items) { item in
///     Text(item.value)
/// }
/// ```
///
/// ## Topics
///
/// ### Properties
///
/// - ``id``
/// - ``value``
///
/// ### Creating Identifiable Wrappers
///
/// - ``init(id:value:)``
/// - ``init(value:)``
public struct DSIdentifiable<Value, ID: Hashable & Sendable>: Identifiable, Sendable where Value: Sendable {
    
    /// The identifier for this wrapper.
    public let id: ID
    
    /// The wrapped value.
    public let value: Value
    
    /// Creates an identifiable wrapper with a specific ID.
    ///
    /// - Parameters:
    ///   - id: The identifier for this wrapper.
    ///   - value: The value to wrap.
    public init(id: ID, value: Value) {
        self.id = id
        self.value = value
    }
}

extension DSIdentifiable where ID == UUID {
    
    /// Creates an identifiable wrapper with an auto-generated UUID.
    ///
    /// - Parameter value: The value to wrap.
    public init(value: Value) {
        self.id = UUID()
        self.value = value
    }
}

// MARK: - DSHashableWrapper

/// Wraps any `AnyObject` value to make it `Hashable` using object identity.
///
/// Use `DSHashableWrapper` when you need to use reference types as
/// dictionary keys or set members.
///
/// ## Usage
///
/// ```swift
/// class MyController { }
///
/// let controller = MyController()
/// let wrapped = DSHashableWrapper(controller)
///
/// var set: Set<DSHashableWrapper<MyController>> = [wrapped]
/// ```
///
/// ## Topics
///
/// ### Properties
///
/// - ``value``
///
/// ### Creating Wrappers
///
/// - ``init(_:)``
public struct DSHashableWrapper<Value: AnyObject>: Hashable, @unchecked Sendable {
    
    private let _id: ObjectIdentifier
    
    /// The wrapped reference value.
    public let value: Value
    
    /// Creates a hashable wrapper for a reference type.
    ///
    /// - Parameter value: The reference to wrap.
    public init(_ value: Value) {
        self._id = ObjectIdentifier(value)
        self.value = value
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
    }
    
    public static func == (lhs: DSHashableWrapper<Value>, rhs: DSHashableWrapper<Value>) -> Bool {
        lhs._id == rhs._id
    }
}

// MARK: - DSStringID

/// A sendable string-based identifier for cases where string IDs are needed.
///
/// `DSStringID` provides a type-safe wrapper around string identifiers,
/// with `ExpressibleByStringLiteral` for convenient initialization.
///
/// ## Usage
///
/// ```swift
/// let id: DSStringID = "my-identifier"
/// let explicit = DSStringID("another-id")
///
/// // Use in dictionaries
/// var map: [DSStringID: String] = [:]
/// map[id] = "value"
/// ```
///
/// ## Topics
///
/// ### Properties
///
/// - ``value``
///
/// ### Creating IDs
///
/// - ``init(_:)``
/// - ``init(stringLiteral:)``
public struct DSStringID: Hashable, Sendable, ExpressibleByStringLiteral, CustomStringConvertible {
    
    /// The underlying string value.
    public let value: String
    
    /// Creates a string ID.
    ///
    /// - Parameter value: The string value.
    public init(_ value: String) {
        self.value = value
    }
    
    /// Creates a string ID from a string literal.
    ///
    /// - Parameter value: The string literal.
    public init(stringLiteral value: String) {
        self.value = value
    }
    
    public var description: String {
        value
    }
}
