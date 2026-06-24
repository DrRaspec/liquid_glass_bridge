## 0.3.0

- Add iOS 26, future iOS 28, Android, and adaptive platform style presets.
- Add `LiquidGlassSegmentedControl`, `LiquidGlassSwitch`, and `LiquidGlassSlider`.
- Add a README preview image that shows iOS 26, future iOS, and Android styling.
- Fix Android native blur setup when Flutter provides a wrapped platform-view context.
- Update the example to preview adaptive iOS/Android UI styles.

## 0.2.1

- Increase public API dartdoc coverage to improve pub points.
- Add package-level library documentation.
- Remove an unnecessary Flutter import reported by static analysis.
- Expand README with explicit iOS and Android setup/configuration steps.

## 0.2.0

- Added Android native blur backend and `LiquidGlassMode.androidNative`.
- Added app-wide `LiquidGlassTheme` defaults.
- Added reusable `LiquidGlassStyle`, platform overrides, presets, and lerp/merge helpers.
- Added iOS native blur style override via `iosBlurStyle`.
- Improved Flutter renderer: proper `enabled` handling, noise caching, and lens animation gating.
- Fix Android native view hit-testing by wrapping the platform view with `IgnorePointer`.
- Documentation updates for styles, theming, and native backends.

## 0.1.2

- Added Dartdoc comments across public API for improved documentation quality.
- Expanded README with install, modes, API parameters, and usage examples.

## 0.1.1

- Republished with package metadata updates (GitHub homepage/repository).
- Added native iOS UIKit rendering path integration for glass effect.

## 0.1.0

- Initial release of `liquid_glass_bridge`.
- Added `LiquidGlassSurface` with adaptive mode selection.
- Added iOS-styled rendering and Flutter glass fallback.
- Added optional shader lens mode with automatic fallback.
- Added noise asset, shader asset, tests, and interactive example app.
- Added iOS plugin integration with native Swift/UIKit glass rendering (`UIVisualEffectView`).
