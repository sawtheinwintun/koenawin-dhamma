# Design Tokens

KoeNaWin + Dhamma app (Android only, light mode only).
Figma style names map 1:1 to Flutter `ThemeData` names.

## Typography

Font: **Pyidaungsu** (Regular 400, Bold 700). Letter spacing 0. Line height in px.
Figma name `Category/Size` → Flutter `textTheme.categorySize` (e.g. `Body/Medium` → `bodyMedium`).
Flutter `height` = line height ÷ size.

| Figma style | Flutter | Size | Line height | Weight | Usage |
|---|---|---|---|---|---|
| `Display/Large` | `displayLarge` | 52 | 84 | Regular | (rarely used) |
| `Display/Medium` | `displayMedium` | 44 | 72 | Regular | |
| `Display/Small` | `displaySmall` | 36 | 60 | Regular | Splash app name |
| `Headline/Large` | `headlineLarge` | 30 | 52 | Bold | |
| `Headline/Medium` | `headlineMedium` | 26 | 44 | Bold | Screen title |
| `Headline/Small` | `headlineSmall` | 22 | 38 | Bold | Section title |
| `Title/Large` | `titleLarge` | 20 | 34 | Bold | App bar title |
| `Title/Medium` | `titleMedium` | 17 | 30 | Bold | Card title, dhamma talk name |
| `Title/Small` | `titleSmall` | 15 | 26 | Bold | List item title |
| `Body/Large` | `bodyLarge` | 17 | 30 | Regular | Long reading text |
| `Body/Medium` | `bodyMedium` | 15 | 26 | Regular | Default body text |
| `Body/Small` | `bodySmall` | 13 | 22 | Regular | Monk name, time |
| `Label/Large` | `labelLarge` | 15 | 24 | Bold | Button text |
| `Label/Medium` | `labelMedium` | 13 | 20 | Regular | Tab, chip |
| `Label/Small` | `labelSmall` | 11 | 18 | Regular | Bottom nav, badge |

App-specific (Flutter `ThemeExtension`):

| Figma style | Size | Line height | Weight | Usage |
|---|---|---|---|---|
| `App/Gatha` | 20 | 40 | Regular | Chanting / gatha text |
| `App/Counter` | 64 | 76 | Bold | KoeNaWin day / count number |

## Colors

Figma color style name = Flutter `colorScheme.<name>`.

| Role | Hex | Usage |
|---|---|---|
| `primary` | `#7A4123` | Main button, active icon |
| `onPrimary` | `#FFFFFF` | Content on primary |
| `primaryContainer` | `#F3DCCB` | Selected item background |
| `onPrimaryContainer` | `#3A1A08` | |
| `secondary` | `#8C6A24` | Secondary button, highlight |
| `onSecondary` | `#FFFFFF` | |
| `secondaryContainer` | `#F5E3B5` | Chip, tag, tonal button |
| `onSecondaryContainer` | `#3B2A06` | |
| `surface` | `#FFF8F1` | Screen background |
| `onSurface` | `#2B1E16` | Default text |
| `onSurfaceVariant` | `#5C4A3E` | Secondary / muted text |
| `surfaceContainerLowest` | `#FFFFFF` | |
| `surfaceContainerLow` | `#FCF1E7` | |
| `surfaceContainer` | `#F7EADF` | Card background |
| `surfaceContainerHigh` | `#F1E3D6` | Dialog, bottom sheet |
| `surfaceContainerHighest` | `#EBDCCE` | Text field background |
| `outline` | `#8A7466` | Border |
| `outlineVariant` | `#DCC8B8` | Divider |
| `error` | `#BA1A1A` | Error |
| `onError` | `#FFFFFF` | |
| `errorContainer` | `#FFDAD6` | |
| `onErrorContainer` | `#410002` | |

App-specific (Flutter `ThemeExtension`):

| Figma style | Hex | Usage |
|---|---|---|
| `App/gold` | `#C29A45` | Dhamma wheel, decorative icons |
| `App/goldLight` | `#E6CB7E` | Gradient highlight |
| `App/yogiDark` | `#5A2E16` | Logo background, splash |

## Effects

### Elevation

Two-layer shadows, color `#3A1A08` (warm yogi dark). Values: X, Y, Blur, Spread, Opacity.
Flutter computes shadows from `elevation`, so results are close to Figma but not pixel-identical.

| Figma style | Flutter `elevation` | Layer 1 | Layer 2 | Usage |
|---|---|---|---|---|
| `Elevation/Level1` | 1 | 0, 1, 2, 0, 30% | 0, 1, 3, 1, 15% | Card |
| `Elevation/Level2` | 3 | 0, 1, 2, 0, 30% | 0, 2, 6, 2, 15% | Bottom nav, menu |
| `Elevation/Level3` | 6 | 0, 1, 3, 0, 30% | 0, 4, 8, 3, 15% | FAB, dialog, mini player |
| `Elevation/Level4` | 8 | 0, 2, 3, 0, 30% | 0, 6, 10, 4, 15% | Pressed / dragged |
| `Elevation/Level5` | 12 | 0, 4, 4, 0, 30% | 0, 8, 12, 6, 15% | (rarely used) |

Level 0 = no shadow (no style needed).

### App-specific

| Figma style | Type | Value | Flutter | Usage |
|---|---|---|---|---|
| `App/GoldGlow` | Drop shadow | X 0, Y 0, Blur 24, Spread 4, `#C29A45` 45% | `BoxShadow` | KoeNaWin counter, dhamma wheel |
| `App/BackgroundBlur` | Background blur | Blur 20, over `surface` at 60% | `BackdropFilter` | Audio mini player, bars over images |

Use shadows sparingly (prefer `surfaceContainer` on `surface` to separate cards). Limit blur to 1–2 places for performance on older Android phones.

## Layout

Figma frame: Android Compact **412 × 917**. 1 Figma px = 1 Flutter logical pixel.

### Grid

| Setting | Value |
|---|---|
| Type | Columns, Stretch |
| Count | 4 |
| Margin | 16 |
| Gutter | 16 |

### Spacing

Multiples of 4 only. Flutter `AppSpacing.<name>`.

| Name | px | Usage |
|---|---|---|
| `xs` | 4 | Icon–text gap, between text lines |
| `sm` | 8 | Tightly related elements |
| `md` | 12 | Elements inside a card |
| `lg` | 16 | Screen margin, card padding, between cards (default) |
| `xl` | 24 | Between sections |
| `xxl` | 32 | Between large groups |
| `xxxl` | 48 | Splash, empty states |

### Corner radius

Flutter `AppRadius.<name>`.

| Name | px | Usage |
|---|---|---|
| `xs` | 4 | Badge, progress bar |
| `sm` | 8 | Chip, tag, text field |
| `md` | 12 | Thumbnail |
| `lg` | 16 | Card, mini player |
| `xl` | 28 | Bottom sheet top corners, dialog |
| `full` | 999 | Button, circles (avatar, play button) |

### Component sizes

| Component | Height | Notes |
|---|---|---|
| Status bar | 52 | Figma value that covers the punch-hole camera; fill with the screen/app bar color. Real height varies per device. Flutter reads it from `MediaQuery.padding.top` and draws edge-to-edge behind it. No content here |
| App bar | 64 | |
| Button | 48 | Larger than M3's 40, easier for older users |
| Text field | 56 | |
| List item (2 lines) | 72 | Thumbnail 48 × 48 |
| Mini player | 64 | Sits above bottom nav |
| Bottom navigation | 80 | 3–5 tabs |
| Icon | 24 | Primary actions (play) 32–48 |
| Min touch target | 48 × 48 | Even for small icons |
| Gesture bar (bottom) | 24 | Below bottom nav; fill with the bottom nav color. Real height varies (Flutter `MediaQuery.padding.bottom`). No content here |

Edge-to-edge: backgrounds extend under the status bar and gesture bar; content stays inside `SafeArea`. Status bar icons are dark (light background).

## Motion

Calm and gentle: no bounce, no fast spins, no flashy loops.
Rule: entering → Decelerate, exiting → Accelerate, changing in place → standard.

### Durations

Figma `Duration/<name>` → Flutter `Durations.<name>`.

| Figma | Flutter | ms | Usage |
|---|---|---|---|
| `Duration/short2` | `Durations.short2` | 100 | Color change, hover |
| `Duration/short4` | `Durations.short4` | 200 | Button press, icon swap |
| `Duration/medium2` | `Durations.medium2` | 300 | Fade in, list item |
| `Duration/medium4` | `Durations.medium4` | 400 | Page transition, bottom sheet |
| `Duration/long2` | `Durations.long2` | 500 | Counter increment |
| `Duration/long4` | `Durations.long4` | 600 | Gatha line reveal |
| `Duration/extralong4` | `Durations.extralong4` | 1000 | Splash |

### Easing

Figma `Easing/<name>` → Flutter `Easing.<name>`.

| Figma | Flutter | Cubic bezier | Usage |
|---|---|---|---|
| `Easing/standard` | `Easing.standard` | 0.2, 0, 0, 1 | Default, in-place changes |
| `Easing/standardDecelerate` | `Easing.standardDecelerate` | 0, 0, 0, 1 | Small elements entering |
| `Easing/standardAccelerate` | `Easing.standardAccelerate` | 0.3, 0, 1, 1 | Small elements exiting |
| `Easing/emphasizedDecelerate` | `Easing.emphasizedDecelerate` | 0.05, 0.7, 0.1, 1 | Screens / sheets entering |
| `Easing/emphasizedAccelerate` | `Easing.emphasizedAccelerate` | 0.3, 0, 0.8, 0.15 | Screens / sheets exiting |

### App animations

| Name | Behavior | Duration | Easing |
|---|---|---|---|
| `App/SplashWheel` | Dhamma wheel rotates from -90°, fades in, scales 0.8 → 1 | extralong4 | emphasizedDecelerate |
| `App/PageEnter` | Slides in from 30px right, fades in | medium4 | emphasizedDecelerate |
| `App/ListStagger` | Rises 12px and fades in, 50ms between items | medium2 | emphasizedDecelerate |
| `App/CounterPop` | Number scales to 1.08 and back, GoldGlow fades in | long2 | standard |
| `App/ButtonPress` | Scales to 0.95 and back | short4 | standard |
| `App/GathaReveal` | Lines fade in one by one, 400ms apart | long4 | standard |
| `App/SheetUp` | Bottom sheet slides up from below | medium4 | emphasizedDecelerate |
| `App/PlayPause` | Play ↔ pause icon cross-fade | short4 | standard |

## Icons

Source: **Phosphor Icons** (Figma library/plugin; Flutter `phosphor_flutter`).

- Weights: `Regular` default, `Fill` for selected/active state. No Thin, Light, Bold or Duotone.
- Size 24 default; primary actions (play) 32–48.
- Color from color styles, not baked in: `onSurface`, muted `onSurfaceVariant`, active `primary`.
- Layer name `ic_` + Phosphor name in snake_case: `DownloadSimple` → `ic_download_simple` → `PhosphorIcons.downloadSimple()`.
- Keep library instances; don't detach, flatten or outline (the name is lost).
- Icons Phosphor lacks (e.g. dhamma wheel): custom SVG, layer `ic_custom_<name>`, Flutter `flutter_svg`.

## Naming

### Frames: `Feature / Screen / State`

English, PascalCase, separated by ` / `. Omit State for the default. One Figma Section per feature, frames in flow order left to right, state frames below their screen.

| Figma frame | Flutter file | Class |
|---|---|---|
| `KoeNaWin / Counter` | `lib/features/koenawin/screens/counter_screen.dart` | `CounterScreen` |
| `KoeNaWin / Counter / Completed` | same file (a state, not a new screen) | `CounterScreen` |

States: `Loading`, `Empty`, `Error`, `Playing`, `Paused`, `Completed`. Overlays: `… / Sheet <Name>`, `… / Dialog <Name>`.

### Layers: `prefix_meaning` (snake_case)

Name by meaning, not by style. Repeated list items share one name.

| Prefix | Type | Flutter |
|---|---|---|
| `btn_` | Button | FilledButton, IconButton |
| `ic_` | Icon | Icon |
| `img_` | Image | Image |
| `txt_` | Text | Text |
| `input_` | Text field | TextField |
| `card_` | Card | Card |
| `list_` / `item_` | List / list item | ListView / item widget |
| `sec_` | Auto Layout group | Column / Row |
| `nav_` | Navigation | NavigationBar, AppBar |
| `tab_` | Tab | Tab |
| `chip_` | Chip, tag | Chip |
| `bar_` | Progress, slider | LinearProgressIndicator, Slider |
| `toggle_` | Switch, checkbox | Switch |
| `bg_` | Background shape | Container decoration |
| `divider` | Divider | Divider |

### Nested frames

`Feature / Screen / State` is for the outermost screen frame only (one screen = one Flutter file). Frames inside it use layer naming (`sec_header`, `card_today`, `nav_app_bar`), never `KoeNaWin / Counter / Header`. A nested frame reused across screens becomes a component (PascalCase).

### Components: PascalCase

Component name = Flutter widget class (`DhammaItem`, `MiniPlayer`, `PrimaryButton`, `CounterRing`). Variants via Figma variant properties (`State=Playing`).

## Assets

- `assets/branding/logo.svg`: logo (yogi background, antique-gold dhamma wheel)
- `assets/branding/app_icon.svg`: full-bleed launcher icon, wheel inside the adaptive-icon safe zone
