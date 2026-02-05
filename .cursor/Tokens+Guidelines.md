# Design System v0 (SwiftUI) — Tokens & Guidelines (based on provided references)

> Фокус: **Forms / Settings** для iOS + macOS + watchOS.  
> Визуальный язык: **dark glass / soft gradients / elevated cards**, но в тёмной теме **акцентные цвета менее “кислотные”** (сниженный контраст и насыщенность).

---

## 1) Visual direction (коротко)

### Что берём из референсов
- **Elevated cards** (мягкие тени/обводки, иногда “glass”).
- **Мягкие градиентные акценты** на фоне (не в тексте!).
- **Сайдбар + контентные блоки** (macOS) и **список секций/строк** (iOS).
- **Чёткая иерархия**: заголовки, вторичный текст, value-текст, статусы/бейджи.

### Что сознательно смягчаем
- Суперконтрастные неоновые цвета — **только как небольшие акценты** (icons/badges/mini-charts), не как большие заливки.
- Сильные “блики/свечения” — **минимально** и только на фоне/подложках.

---

## 2) Color system

### 2.1 Палитра: базовые нейтрали (Light / Dark)
Нейтрали — основа. Все поверхности/текст/границы строим вокруг них.

#### Light neutrals
- `N0`  #FFFFFF
- `N1`  #F7F8FA
- `N2`  #F1F3F6
- `N3`  #E6E9EF
- `N4`  #D7DCE5
- `N5`  #B9C0CE
- `N6`  #8F98AA
- `N7`  #5D6678
- `N8`  #2D3442
- `N9`  #131824

#### Dark neutrals (слегка “теплее”/глубже для glass)
- `D0`  #0B0E14  (base)
- `D1`  #0F131C  (surface)
- `D2`  #151B26  (surface elevated)
- `D3`  #1B2331  (card)
- `D4`  #243042  (border/sep strong)
- `D5`  #3A465C  (muted border)
- `D6`  #6C7790  (secondary text)
- `D7`  #A7B0C3  (tertiary text / hints)
- `D8`  #E7ECF5  (primary text on dark)
- `D9`  #FFFFFF

---

### 2.2 Акцентная палитра (широкая, но с “dark-safe” версиями)
Правило: **для Dark используем чуть “припылённые” оттенки** (меньше saturation и brightness).

#### Accent — Teal/Cyan (главный акцент, как на референсах)
- `Teal 50`  #E6FFFB
- `Teal 100` #BFF9F0
- `Teal 200` #7FF0E2
- `Teal 300` #2FE3D2
- `Teal 400` #16C7B9
- `Teal 500` #0BAEA3  (Light primary)
- `Teal 600` #079389
- `Teal 700` #057870
- `Teal 800` #045E58
- `Teal 900` #033E3A

**Dark-safe Teal**
- `TealDark A` #17BDB0 (accent primary on dark)
- `TealDark B` #0E8E84 (accent pressed/active)
- `TealDark Glow` #25D8C9 (only small glow / charts)

#### Indigo/Purple (второй бренд-акцент, для мак/дашбордов)
- `Indigo 200` #C7D2FE
- `Indigo 300` #A5B4FC
- `Indigo 400` #818CF8
- `Indigo 500` #6366F1
- `Indigo 600` #4F46E5
- `IndigoDark A` #6D72F7 (на dark немного мягче)
- `IndigoDark B` #4A4FE6

#### Green / Success
- `Green 300` #86EFAC
- `Green 500` #22C55E
- `Green 700` #15803D
- `GreenDark A` #4ADE80 (dark-safe)
- `GreenDark B` #22C55E

#### Yellow / Warning
- `Yellow 300` #FDE68A
- `Yellow 500` #F59E0B
- `Yellow 700` #B45309
- `YellowDark A` #F6C453 (dark-safe)
- `YellowDark B` #D89214

#### Red / Danger
- `Red 300` #FCA5A5
- `Red 500` #EF4444
- `Red 700` #B91C1C
- `RedDark A` #F87171 (dark-safe)
- `RedDark B` #EF4444

#### Blue / Info
- `Blue 300` #93C5FD
- `Blue 500` #3B82F6
- `Blue 700` #1D4ED8
- `BlueDark A` #60A5FA (dark-safe)
- `BlueDark B` #3B82F6

---

### 2.3 Семантические роли (Colors)
Ниже — **именно то, что нужно компонентам**. Компоненты не должны знать токены напрямую.

#### Light theme roles
- `bg.canvas` = `N1`
- `bg.surface` = `N0`
- `bg.surfaceElevated` = `N0` (с мягкой тенью)
- `bg.card` = `N0`
- `fg.primary` = `N9`
- `fg.secondary` = `N7`
- `fg.tertiary` = `N6`
- `fg.disabled` = `N6` (opacity 0.5)
- `border.subtle` = `N3`
- `border.strong` = `N4`
- `separator` = `N3`
- `accent.primary` = `Teal 500`
- `accent.secondary` = `Indigo 600`
- `state.success` = `Green 500`
- `state.warning` = `Yellow 500`
- `state.danger` = `Red 500`
- `state.info` = `Blue 500`
- `focusRing` = `Teal 300` (opacity ~0.7)

#### Dark theme roles (сниженный контраст акцентов)
- `bg.canvas` = `D0`
- `bg.surface` = `D1`
- `bg.surfaceElevated` = `D2`
- `bg.card` = `D3`
- `fg.primary` = `D8`
- `fg.secondary` = `D7`
- `fg.tertiary` = `D6`
- `fg.disabled` = `D6` (opacity 0.55)
- `border.subtle` = `D4` (opacity 0.55)
- `border.strong` = `D4`
- `separator` = `D4` (opacity 0.45)
- `accent.primary` = `TealDark A`
- `accent.secondary` = `IndigoDark A`
- `state.success` = `GreenDark A`
- `state.warning` = `YellowDark A`
- `state.danger` = `RedDark A`
- `state.info` = `BlueDark A`
- `focusRing` = `TealDark Glow` (opacity 0.55)

---

### 2.4 Цвета по компонентам (component color recipes)

#### Buttons
- Primary:
  - bg = `accent.primary`
  - fg = `D0` (на dark) / `N0` (на light) — в зависимости от контраста
  - pressed bg = `TealDark B` / `Teal 600`
- Secondary:
  - bg = `bg.card`
  - border = `border.subtle`
  - fg = `fg.primary`
- Tertiary (ghost):
  - bg = transparent
  - fg = `fg.primary`
  - hover/pressed overlay = `fg.primary` opacity 0.06…0.10
- Destructive:
  - bg = `state.danger` (dark-safe)
  - fg = `D0` / `N0`

#### TextFields / Form Controls
- container bg = `bg.card` (или `bg.surfaceElevated` для watch)
- border default = `border.subtle`
- border focused = `focusRing` (или отдельный `accent.primary`)
- placeholder fg = `fg.tertiary`
- error border = `state.danger`
- helper text = `fg.tertiary`
- error text = `state.danger` (dark-safe)

#### List/Rows (Settings)
- row bg = transparent / `bg.surface`
- row hover (mac) = `fg.primary` opacity 0.05
- row pressed = `fg.primary` opacity 0.08
- chevron/accessory = `fg.tertiary`
- selection highlight (if needed) = `accent.primary` opacity 0.12

#### Cards (dashboard)
- bg = `bg.card`
- stroke = `border.subtle` (часто 1px)
- shadow: мягкая (см. Shadows)
- header fg = `fg.primary`, subtitle = `fg.secondary`

#### Badges / Status pills
- success: bg = `state.success` opacity 0.15, fg = `state.success`
- warning: bg = `state.warning` opacity 0.16, fg = `state.warning`
- danger: bg = `state.danger` opacity 0.14, fg = `state.danger`
- info: bg = `state.info` opacity 0.14, fg = `state.info`

#### Charts (если будут на settings-dashboard)
- series1 teal = `TealDark Glow` / `Teal 400`
- series2 indigo = `Indigo 500`
- series3 yellow = `YellowDark A` / `Yellow 500`
- series4 red = `RedDark A` / `Red 500`
- gridlines = `separator` opacity 0.4

---

## 3) Typography (гайды по шрифтам)

### 3.1 Базовый набор
- **SF Pro** (System) — основной интерфейс.
- **SF Mono** — для идентификаторов/кодовых значений/логов (редко в settings).

### 3.2 Текстовые роли (использовать роли, не размеры напрямую)
> Все роли должны поддерживать Dynamic Type. На macOS можно немного уменьшить scaling.

#### iOS/macOS роли
- `LargeTitle` — 34 / semibold (iOS large nav)
- `Title1` — 28 / semibold
- `Title2` — 22 / semibold
- `Title3` — 20 / semibold
- `Headline` — 17 / semibold
- `Body` — 17 / regular
- `Callout` — 16 / regular
- `Subheadline` — 15 / regular
- `Footnote` — 13 / regular
- `Caption1` — 12 / regular
- `Caption2` — 11 / regular

#### Компонентные роли
- `ButtonLabel` = Headline (iOS) / 14–15 semibold (mac)
- `FieldText` = Body/Callout
- `FieldPlaceholder` = FieldText, но opacity 0.65
- `HelperText` = Footnote
- `RowTitle` = Body/Headline (в зависимости от density)
- `RowValue` = Subheadline (secondary)
- `SectionHeader` = Footnote semibold (uppercase optional)
- `BadgeText` = Caption1 semibold

### 3.3 Line height / tracking
- Default line height: системная (не фиксировать жёстко).
- Для caption/footnote на dark — следить за читабельностью: не опускаться ниже 11–12.
- Tracking не трогать, кроме optional “caps” секций (+2…+4).

---

## 4) Spacing & Layout (гайды по отступам)

### 4.1 Базовая сетка
- Основа: **4pt grid**.
- Предпочтительные шаги: 4, 8, 12, 16, 20, 24, 32, 40, 48.

### 4.2 Tokens (Spacing)
- `space.1` = 4
- `space.2` = 8
- `space.3` = 12
- `space.4` = 16
- `space.5` = 20
- `space.6` = 24
- `space.8` = 32
- `space.10` = 40
- `space.12` = 48

### 4.3 Рекомендации по применению
- Внутри карточек: padding **16–20** (compact: 12–16)
- Между блоками на dashboard: **16–24**
- Row height:
  - iOS: минимум 44
  - macOS: 36–44 (в зависимости от density)
  - watchOS: 44–52 (крупнее)
- Form spacing:
  - между rows: 10–12 (или token 12)
  - между sections: 20–24

### 4.4 Density presets
- `compact`: уменьшить padding на 1 шаг (например 16→12), row height ближе к минимуму
- `regular`: базовые значения
- `spacious`: +1 шаг (16→20), больше воздуха (watch / TV-like)

---

## 5) Corner radius & shapes (скругления)

### 5.1 Radius tokens
- `r.1` = 6   (small controls, badges)
- `r.2` = 10  (fields, small cards)
- `r.3` = 14  (cards default)
- `r.4` = 18  (large panels / modals)
- `r.5` = 24  (hero containers / glass panels)

### 5.2 Применение
- Buttons / fields: `r.2` (10) или `r.3` (14) в зависимости от высоты
- Cards: `r.3` (14)
- Overlays / modal sheets: `r.4` (18)
- Chips/badges: `r.1` (6) или fully rounded (pill)

---

## 6) Borders / Shadows / Elevation (для “glass & depth”)

### 6.1 Borders
- default stroke: 1px (`border.subtle`)
- strong stroke: 1px (`border.strong`)
- separator: 1px с меньшей opacity

### 6.2 Shadows (мягкие, как в референсах)
- `shadow.1` (cards): y=6, blur=18, opacity 0.12 (dark) / 0.08 (light)
- `shadow.2` (overlay): y=14, blur=40, opacity 0.18 (dark) / 0.12 (light)
- `shadow.0` (flat): none + stroke only

### 6.3 Glass (опционально)
Для отдельных панелей:
- background = `bg.card` с opacity 0.75…0.9
- blur = small/medium (если решишь поддерживать)
- stroke = `border.subtle` opacity 0.7

> Важно: на iOS/macOS blur разный; на watch лучше без blur (перф/читабельность).

---

## 7) Component patterns (Forms / Settings)

### 7.1 Settings screen layout
- macOS: sidebar (нав) + контент-dashboard из cards + settings sections
- iOS: grouped sections, row patterns
- watchOS: list sections, редкие inline inputs

### 7.2 Row patterns
- NavigationRow: title + value + chevron
- ToggleRow: title + toggle
- PickerRow: title + selected value → opens picker (sheet/popover/navigation)
- TextFieldRow: inline на iOS/mac, отдельный edit screen на watch (auto)
- ActionRow: row-button
- DestructiveRow: требует confirm

### 7.3 Validation rules
- Ошибка: border + helper text + optional icon
- Warning: желтый тон, меньше “агрессии”
- Success: зелёный тон, subtle

---

## 8) Что задокументировать в репо (минимум)
- `THEMING.md`: как создать свою тему (tokens → roles → specs)
- `TOKENS.md`: список токенов (colors/spacing/radius/typography/motion)
- `FORMS.md`: form row layouts + validation + focus chain
- `SETTINGS_COOKBOOK.md`: примеры экранов настроек
- `CAPABILITIES.md`: деградации на watchOS

---

## 9) Примечания для реализации в SwiftUI (подсказки)
- Семантика и specs — через **Environment** (dependency injection).
- Платформенные различия:
  - минимум `#if os(...)` в основных компонентах
  - вместо этого: `capabilities` + platform glue targets
- Form/configurability:
  - использовать **slots** (ViewBuilder) + optional result builder + type erasure для row items
- Dark theme contrast:
  - акценты “припылённые”, большие заливки — аккуратно, лучше на маленьких элементах (icons/badges).

---