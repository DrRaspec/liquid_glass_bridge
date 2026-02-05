# liquid_glass_bridge

A cross-platform Flutter package that exposes one API for liquid-glass surfaces and iOS-style controls.

- **iOS**: uses a native UIKit `UIVisualEffectView` (Swift) for system frosted material.
- **Android/Web/Desktop**: renders a matching glass look in pure Flutter (`BackdropFilter` + tint + border + specular highlight + optional noise).
- **Optional lens mode**: tries a fragment-shader overlay and automatically falls back to standard glass if unavailable.

## Included widgets

- `LiquidGlassSurface`
- `LiquidGlassButton`
- `LiquidGlassNavigationBar`
- `LiquidGlassBottomNavigationBar`

All widgets support `mode` and `quality` so the app code stays identical across iOS and Android.

## iOS Native Rendering

On iOS, `LiquidGlassMode.auto` / `iosNative` now uses a platform view backed by Swift + UIKit:

- `UIVisualEffectView` blur material
- Native tint + border + highlight composition
- Flutter `child` is layered on top, so your Dart layout stays unchanged

## Features

- Single rendering engine with platform-adaptive mode selection
- Modes: `auto`, `iosNative`, `flutterGlass`, `flutterLens`
- Quality tiers: `low`, `medium`, `high`
- Tunable blur/tint/border/highlight/noise/elevation
- Graceful fallback when shader support is missing

## Usage

```dart
Scaffold(
  appBar: LiquidGlassNavigationBar(
    title: const Text('Home'),
  ),
  bottomNavigationBar: LiquidGlassBottomNavigationBar(
    items: const <LiquidGlassNavItem>[
      LiquidGlassNavItem(icon: Icons.home_outlined, label: 'Home'),
      LiquidGlassNavItem(icon: Icons.search_outlined, label: 'Search'),
    ],
    currentIndex: 0,
    onTap: (int index) {},
  ),
  body: Center(
    child: LiquidGlassButton(
      onPressed: () {},
      child: const Text('Continue'),
    ),
  ),
)
```

## Performance Tips (especially Android)

- Keep `blurSigma` as low as acceptable (start around 12–18).
- Use `LiquidGlassQuality.low` for large scrolling lists.
- Keep `noiseOpacity` subtle (`0.02`–`0.06`) and avoid very large glass surfaces.
- Prefer fewer overlapping blurred layers.

## Screenshots

- `docs/screenshots/ios.png` (placeholder)
- `docs/screenshots/android.png` (placeholder)
- `docs/screenshots/lens.png` (placeholder)

## Example

Run:

```bash
flutter run -d <device> -t example/lib/main.dart
```

or from `/example`:

```bash
flutter run
```
