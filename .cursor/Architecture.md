# SwiftUI Design System (iOS + macOS + watchOS) — Architecture & Implementation Plan (for Cursor)

## Цель проекта
Построить переиспользуемую дизайн-систему на SwiftUI, покрывающую:
- **уровни**: tokens → semantic theme → component styles/specs → atoms/primitives → composites (forms/settings) → layouts/patterns
- **платформы**: iOS, macOS, watchOS (watch — часто “Lite” реализации)
- **максимальная конфигурируемость**: компоненты (особенно формы) должны собираться из любых поддерживаемых подкомпонентов (slots/builders), и быть кастомизируемыми через Theme/Styles.

Фокус первой итерации: **Forms + Settings**.

---

## Ключевые принципы (не нарушать)
1. **Компоненты зависят от semantic roles**, а не от “сырых” цветов/значений.
2. **Theme/Styles живут в Environment**, компоненты читают их через `@Environment`.
3. **Resolve → Render**: компонент сначала резолвит `Spec` (параметры), потом рендерит UI.
4. Кроссплатформенность достигается **через theme/spec/capabilities**, а не через `#if` в каждом компоненте.
5. watchOS: **авто-деградация** (Full → Lite), единый public API.

---

## Архитектура слоёв

### 1) DSCore (foundation)
Назначение: общие абстракции и “контракт” поведения.
Содержит:
- Platform metrics: платформа, hover/focus availability, input modality, window size category
- Accessibility policy: reduce motion, increased contrast, dynamic type
- Localization policy: дефолтные строки, форматирование
- Общие типы состояний: pressed/hovered/focused/disabled/loading/selected/validation
- Utilities: stable IDs, measurement helpers, type erasure helpers

**Подсказка реализации**:
- Стараться держать DSCore без UI.
- Platform metrics можно агрегировать из system Environment + `#if os(...)` в одном месте.

### 2) DSTokens (raw scales)
Назначение: “сырьё” (палитры/шкалы), не знает про UI.
Содержит:
- Color palettes (neutral/accent/danger/success…)
- Typography scale
- Spacing scale
- Radii scale
- Shadows scale
- Motion scale (durations/easings/spring presets)

### 3) DSTheme (semantic mapping)
Назначение: семантические роли + адаптация под system env.
Содержит:
- `DSTheme` контейнер:
  - `DSColors` semantic roles: textPrimary/surface/accent/danger/border/focusRing…
  - `DSTypography` roles: title/body/caption/buttonLabel/fieldText/helperText…
  - `DSSpacing`, `DSRadii`, `DSMotion`, `DSShadows`
  - `DSDensity` (compact/regular/spacious)
  - `DSCapabilities` (см. ниже)
  - `DSComponentStyles` (реестр specs)
- ThemeResolver: tokens + env (light/dark, contrast, reduce motion, dynamic type, platform metrics) → готовая тема

**Подсказка реализации**:
- ThemeResolver — единственная точка, где учитываются accessibility/платформа.
- Избегать прямых `Color("...")` в компонентах: только `theme.colors.*`.

### 4) DSStyles (component specs registry)
Назначение: контракты внешнего вида и поведения компонентов.
Для MVP (Forms/Settings) specs:
- ButtonSpec
- FieldSpec (TextField/Secure/Multiline)
- ToggleSpec / SelectionSpec
- CardSpec
- ListRowSpec
- FormSpec
- DialogSpec (минимум confirm)
- ToastSpec (опционально)

**Resolve API** (идея): `resolve(variant, size, state, metrics)` → конкретные параметры (цвета/отступы/типографика/анимации).

**Подсказка реализации**:
- Это “полиморфизм данных”: разные бренды/платформы меняют specs без правки view-кода.
- Можно использовать протоколы для specs или простые struct + closures (на усмотрение).

### 5) DSPrimitives (atoms)
Минимальный набор:
- Text (role-based)
- Icon (SF Symbols wrapper)
- Surface / Background
- Divider
- Card
- Loader/Progress

### 6) DSControls (atoms interactive)
Для MVP settings/forms:
- Button (primary/secondary/destructive/link)
- Toggle (+ Checkbox для macOS)
- TextField + Secure + Multiline (как минимум)
- Picker (single select)
- Stepper
- Slider (optional, но часто нужен)

### 7) DSForms (composites for forms)
Содержит:
- Form container (layout)
- FormSection (header/footer)
- FormRow layout (inline/stacked; macOS: two-column preset)
- Validation presentation (hint/error/warning/success)
- Focus/submit chain (iOS keyboard + macOS focus)
- “Field chrome” (лейбл/подсказка/ошибка/required marker)

**Конфигурируемость форм**: “наполнять чем угодно”
- Подход 1 (практичный): **Form = контейнер + Rows** (rows могут быть любыми views)
- Для удобства: result builder, type erasure для row items, или слот-архитектура.

### 8) DSSettings (готовые patterns)
MVP rows:
- NavigationRow (title/subtitle/value + chevron)
- ToggleRow
- PickerRow
- TextFieldRow (inline или separate edit screen по платформе)
- InfoRow (key-value, версия, копирование)
- ActionRow
- DestructiveRow (confirm)
- NoticeBlock (inline banner)
- SectionHeader/SectionFooter (описания/ссылки)

---

## Платформенность и “в сборку попадает только нужное”

### Рекомендуемая структура SwiftPM Targets (модульность по фичам)
Targets:
- DSCore
- DSTokens
- DSTheme
- DSPrimitives
- DSControls
- DSForms
- DSSettings
- DSiOSSupport (маленький glue)
- DSmacOSSupport (маленький glue)
- DSwatchOSSupport (маленький glue)
- (опционально) DSControlsWatch / DSFormsWatch / DSSettingsWatch (Lite targets)

**Почему так**:
- SwiftPM подтягивает в сборку только зависимые targets.
- Heavy фичи (Media/DataDisplay/Overlays advanced) — отдельными targets, не подключаются SettingsKit’ом.

### Products (то, что импортируют приложения)
- DSBase = DSTheme (подтянет DSCore + DSTokens)
- DSFormsKit = DSForms
- DSSettingsKit = DSSettings
- DS_iOS = DSSettings + DSiOSSupport
- DS_macOS = DSSettings + DSmacOSSupport
- DS_watchOS = (DSSettingsWatch или DSForms+DSSettingsLite) + DSwatchOSSupport

### Как реализовать платформенные различия
1) **Capabilities** в теме (предпочтительно)
2) Platform glue targets (минимальные различия)
3) `#if os(...)` — только внутри support targets или единичных адаптеров, не повсеместно.

---

## Capabilities (для авто-деградации Full → Lite)
Рекомендованный набор (пример):
- supportsHover
- supportsFocusRing
- supportsInlineTextEditing
- supportsInlinePickers
- supportsToasts
- preferredFormRowLayout: stacked/inline/twoColumn
- preferredPickerPresentation: sheet/popover/menu/navigation
- prefersLargeTapTargets (watch)

Значения по платформам:
- iOS: inline text ✅, pickers sheet ✅, hover ❌ (кроме pointer iPad), focus ✅ (keyboard)
- macOS: hover ✅, focus ring ✅, inline ✅, picker popover/menu ✅
- watchOS: inline text ❌ (обычно), inline pickers ❌, picker navigation ✅, large tap targets ✅

**Поведение**:
- `.auto` в API деградирует согласно capabilities.
- Пример: TextFieldRow `.auto` → watch: separate edit screen.

---

## MVP Scope (Forms/Settings)

### Must-have компоненты
Primitives:
- Text/Icon/Surface/Card/Divider/Loader

Controls:
- Button
- Toggle (+ checkbox на macOS)
- TextField + Secure + Multiline
- Picker (single)
- Stepper
- Slider (optional)

Forms:
- Form + Section + Row layout
- Validation: hint/error
- Required marker
- Disabled propagation
- Focus chain (iOS/macOS)

Settings:
- NavigationRow / ToggleRow / PickerRow / TextFieldRow / InfoRow / ActionRow / DestructiveRow
- NoticeBlock
- Section footer/header

---

## “Full vs Lite” матрица (watchOS)
Цель: единый API, разные реализации.
- FormRow layout: Full inline/stacked/twoColumn → watch: stacked only
- TextFieldRow: Full inline → watch: separate edit screen
- PickerRow: Full sheet/popover/menu → watch: navigation list
- SliderRow: Full slider → watch: stepper/pickerDiscrete
- Dialog/confirm: Full alert/sheet → watch: confirm screen

---

## План реализации (примерные шаги)

### Шаг 0 — Репозиторий и структура
- Создать Swift Package `DesignSystem` (SPM) с targets/products (см. выше)
- Создать отдельный `Showcase` app (лучше отдельным Xcode workspace/project), чтобы:
  - быстро смотреть компоненты на iOS/macOS/watchOS
  - делать визуальные превью и UI-тесты

**Рекомендация**:
- Лучшее сочетание: **SPM пакет + Showcase приложения** (в одном репо, но отдельно).
- Пакет — “библиотека”, Showcase — “демо/каталог/тестовый стенд”.

### Шаг 1 — DSCore
- Platform metrics + capabilities
- Accessibility + localization policy
- State model (pressed/hover/focus/disabled/loading/validation)
- Environment keys (в т.ч. theme injection)

### Шаг 2 — Tokens + Theme
- DSTokens шкалы
- DSTheme semantic roles
- ThemeResolver: light/dark + contrast + reduce motion + dynamic type + platform density
- Default themes: минимум 1 бренд, 2 режима (light/dark)

### Шаг 3 — Specs registry
- Определить Specs: ButtonSpec, FieldSpec, FormSpec, ListRowSpec, CardSpec
- Внедрить их в DSTheme.components
- Определить resolve-правила по variant/size/state/metrics

### Шаг 4 — Primitives
- Text (role-based)
- Icon
- Surface/Card/Divider
- Loader/Progress

### Шаг 5 — Controls MVP
- DSButton (resolve spec by state)
- DSToggle (+ DSCheckbox macOS)
- DSTextField / DSSecure / DSMultiline
- DSPicker (single)
- DSStepper
- (optional) DSSlider

### Шаг 6 — Forms MVP
- DSForm container + DSFormSection
- DSFormRow layout:
  - .stacked, .inline (iOS/macOS)
  - .twoColumn preset (macOS)
  - auto → capabilities
- Validation UI: hint/error, required marker
- Focus chain integration (iOS keyboard, macOS focus ring)

### Шаг 7 — Settings patterns MVP
- NavigationRow
- ToggleRow
- PickerRow (presentation авто)
- TextFieldRow (mode авто → watch separate edit screen)
- InfoRow
- ActionRow
- DestructiveRow + confirm dialog
- NoticeBlock

### Шаг 8 — Platform glue
- DSiOSSupport: picker sheet style + keyboard submit chain, large title scaffold integration
- DSmacOSSupport: hover/focus ring conventions, toolbar integration, two-column forms preset
- DSwatchOSSupport: navigation pickers/edit screens, large tap targets, simplified density

### Шаг 9 — Documentation + public API stabilization
- Сформировать “public surface” (то, что обещаем не ломать)
- Ограничить public API до SettingsKit/FormsKit

### Шаг 10 — Tests (unit + UI + snapshots where possible)
(см. раздел ниже)

---

## Где нужны `#if os(...)`, а где лучше полиморфизм
### Использовать `#if os(...)`:
- В support targets (DSiOSSupport/DSmacOSSupport/DSwatchOSSupport)
- В единичных адаптерах, где платформа реально диктует API (например, macOS focus ring specifics)
- В Package.swift для conditional dependencies `.when(platforms: ...)`

### Использовать полиморфизм/резолверы:
- В выборе layout/presentation (`capabilities.preferredPickerPresentation`)
- В выборе density и размеров
- В выборе поведения анимаций (reduce motion)
- В выборе компонентов (registry/factory — опционально)

---

## Что обязательно задокументировать (пометки)
### 1) Архитектура и зависимости
- Слои: tokens → theme → styles → components → composites
- Почему нельзя использовать raw цвета в компонентах
- Как работает ThemeResolver и какие env учитывает

### 2) Theming & Customization Guide
- Как создать новый бренд (tokens → theme)
- Как override’ить component specs
- Как подключать тему в приложении (Environment injection)

### 3) Capabilities и деградации
- Таблица возможностей iOS/macOS/watchOS
- Правила “auto” для form row layout, picker presentation, edit mode

### 4) Public API contracts
- Что относится к “stable API”
- Что advanced/internal
- Версионирование и migration notes

### 5) Settings Patterns cookbook
- Примеры сборки typical settings screen из DSSettings rows

---

## Тестирование (Unit + UI + “визуальные”)

### A) Unit tests (обязательно)
Цель: стабильность “resolve” и правил.
Тестировать:
- ThemeResolver:
  - light/dark
  - increased contrast
  - reduce motion
  - dynamic type → корректные typography roles
  - platform density mapping
- Specs resolve:
  - ButtonSpec: variant/state → правильные параметры
  - FieldSpec: focused/error/disabled → правильные параметры
  - FormSpec: row layout auto → ожидаемая деградация
- Capabilities:
  - iOS/macOS/watch профили корректны

**Почему unit важны**: UI может меняться, но правила и резолверы должны быть железобетонные.

### B) UI tests (выборочно, но полезно)
Цель: проверить, что flows работают (особенно settings).
Сценарии:
- NavigationRow открывает subpage
- ToggleRow меняет состояние, disabled ведёт себя правильно
- PickerRow открывает правильный presentation:
  - iOS: sheet
  - macOS: popover/menu
  - watchOS: navigation screen
- TextFieldRow:
  - iOS/macOS: фокус/ввод
  - watchOS: отдельный edit screen
- DestructiveRow: confirm flow

### C) Snapshot / visual regression (по желанию)
Если есть инфраструктура:
- Генерировать скриншоты из Showcase для наборов стилей и сравнивать (особенно для тем/контраста/динамик-тайпа).
- Минимально: “golden screenshots” на iOS/macOS для критичных компонентов.

---

## Showcase app (обязательно как часть проекта)
Почему: SwiftUI дизайн-системы невозможно качественно развивать без каталога.
Структура каталога:
- Tokens preview (colors/typography/spacing)
- Components: primitives/controls
- Forms: row layouts + validation
- Settings: набор готовых экранов (General, Privacy, About)
- Accessibility modes toggles (simulate dynamic type/contrast/reduce motion where возможно)
- Platform variants (iOS/macOS/watch schemes)

---

## Итоговая цель первой версии (Definition of Done)
- Можно собрать реальный Settings экран на iOS/macOS/watchOS из DSSettings.
- Переключение темы (light/dark) влияет на все компоненты.
- Auto деградация на watch работает (inline → separate screen, sheet → navigation).
- Unit tests покрывают resolver/specs/capabilities.
- Showcase содержит примеры и служит “живой документацией”.

---

# ADDITIONAL: Public API (что экспортировать) + Anti-Patterns (что нельзя)

## 1) Public API: рекомендуемый “компактный” набор типов
Цель: минимальный стабильный интерфейс, который редко ломается.

### Пакеты/продукты
Экспортируемые продукты (SPM):
- `DSBase`
- `DSFormsKit`
- `DSSettingsKit`
- `DS_iOS`, `DS_macOS`, `DS_watchOS` (опционально, как “батарейки”)

### DSBase (публично)
- `DSTheme` (контейнер темы)
- `DSThemeResolver` (или `DSThemeFactory`)
- `DSThemeVariant` (light/dark/highContrast/reduceMotion)
- `DSCapabilities`
- `DSDensity`
- `DSTokens` (только если нужно для кастом тем)
- `View.dsTheme(_:)` (инъекция темы)

> Документация: “как подключить тему” + “как создать свою тему”.

### DSPrimitives (публично)
- `DSText` (+ `DSTextRole`)
- `DSIcon` (+ `DSIconToken`/`DSIconSize`)
- `DSSurface`
- `DSCard`
- `DSDivider`
- `DSLoader`/`DSProgress`

### DSControls (публично)
- `DSButton` (+ `DSButtonVariant`, `DSButtonSize`)
- `DSToggle`
- `DSCheckbox` (macOS only)
- `DSTextField` / `DSSecureField` / `DSMultilineField` (или unified `DSField`)
- `DSPicker` / `DSPickerRow` (если строится вокруг row)
- `DSStepper`
- `DSSlider` (optional)

### DSFormsKit (публично)
- `DSForm`
- `DSFormSection`
- `DSFormRow`
- `DSFormRowLayout` (.auto/.stacked/.inline/.twoColumnPreset)
- `DSValidationState` (none/error/warning/success)
- `DSFieldChrome` (если отдельная сущность для label/hint/error)
- (если используешь builder) `DSFormBuilder` + `AnyFormRow` (advanced)

### DSSettingsKit (публично)
Rows/Patterns:
- `DSSettingsScreen` (если хочешь “готовый scaffold”)
- `DSNavigationRow`
- `DSToggleRow`
- `DSPickerRow`
- `DSTextFieldRow` (+ `DSEditMode`: .auto/.inline/.separateScreen)
- `DSInfoRow` (+ copy support optional)
- `DSActionRow`
- `DSDestructiveRow`
- `DSNoticeBlock`
- `DSSectionHeader`, `DSSectionFooter`

Presentation/Hosts:
- `DSDialogHost` (или `DSOverlayHost`)
- `present(dialog:)` API (через environment controller)

### Что держать НЕ публичным (или “advanced / underscored”)
- Внутренние `Spec` структуры и resolver rules можно оставить public для кастомизации,
  но лучше пометить как “Advanced” и документировать отдельно.
- Низкоуровневые type-erasure и internal state machine детали.

**Рекомендация:** держать “spec API” публичным только после того, как определится стиль брендов/вариантов.

---

## 2) Anti-Patterns (строго запрещено)
Это список для модели в Cursor, чтобы не “испортить” архитектуру.

### A) Прямые значения в компонентах
❌ Нельзя:
- хардкод цветов/шрифтов/отступов в компоненте
- использовать `Color(...)` напрямую, кроме debug/showcase
✅ Нужно:
- только `theme.colors.*`, `theme.spacing.*`, `theme.typography.*`

### B) Смешивание темы и UI
❌ Нельзя:
- класть SwiftUI View-логику в Theme/Specs
✅ Нужно:
- Theme/Specs дают параметры; View рендерит

### C) `#if os(...)` в каждом компоненте
❌ Нельзя:
- размазывать `#if` по всей кодовой базе
✅ Нужно:
- capabilities + support targets + platform-specific files

### D) Огромный “DSComponents” монолит
❌ Нельзя:
- один target со всем (Forms + Media + Tables + Overlays) — будет тащить лишнее в сборку
✅ Нужно:
- feature modules + products (SettingsKit/FormsKit)

### E) Слабая типизация public API
❌ Нельзя:
- `String` вместо enum для variant/role/size/presentation
✅ Нужно:
- enum для вариативности (variant/size/layout/presentation)

### F) Ломать API ради реализации
❌ Нельзя:
- менять public сигнатуры при рефакторинге внутренних правил
✅ Нужно:
- фиксировать stable API слой, внутренности менять свободно

### G) WatchOS “как iOS”
❌ Нельзя:
- пытаться повторить inline editing/сложные overlays на watch
✅ Нужно:
- separate edit screens + navigation pickers + large targets (Lite)

### H) Отсутствие Showcase
❌ Нельзя:
- развивать дизайн-систему без каталога
✅ Нужно:
- Showcase как “живые доки” + база для UI тестов

---

## 3) Где именно документировать дополнительно (обязательные файлы)
Рекомендуемый набор документов в репо:
- `ARCHITECTURE.md` — слои, зависимости, почему так
- `THEMING.md` — tokens → theme → override specs + examples
- `CAPABILITIES.md` — iOS/macOS/watchOS таблица, правила деградации `.auto`
- `FORMS.md` — FormRow layouts, validation, focus chain
- `SETTINGS_COOKBOOK.md` — типовые screens (General/Privacy/About)
- `TESTING.md` — стратегия unit/ui/snapshot, запуск, golden updates

---

## 4) Тестирование (добавка: что точно покрыть)
### Unit (минимум)
- ThemeResolver: variants + accessibility + density
- Capabilities mapping per platform
- Spec resolve for Button/Field/FormRowLayout auto

### UI (минимум, по платформам)
- iOS: PickerRow открывает sheet; TextFieldRow next/submit chain
- macOS: hover/focus ring visible; two-column form preset layout
- watchOS: PickerRow pushes navigation list; TextFieldRow opens edit screen
- DestructiveRow confirm flow везде

### Visual regression (optional)
- Golden screenshots для:
  - light/dark
  - dynamic type large
  - high contrast
  - disabled/error states for fields/buttons

---
