# liquid_glass_bridge

A cross-platform Flutter package that gives you one API for liquid-glass UI.

- **iOS**: native Swift/UIKit renderer (`UIVisualEffectView`) for system-like frosted material.
- **Android/Web/Desktop**: Flutter renderer (`BackdropFilter` + tint + border + highlight + optional noise).
- **Lens mode**: shader overlay with automatic fallback.

## Install

```bash
flutter pub add liquid_glass_bridge
```

## Included Widgets

- `LiquidGlassSurface`
- `LiquidGlassButton`
- `LiquidGlassNavigationBar`
- `LiquidGlassBottomNavigationBar`

## Modes and Quality

### `LiquidGlassMode`

- `auto`: iOS -> native UIKit, others -> Flutter glass
- `iosNative`: iOS native, others fallback to Flutter glass
- `flutterGlass`: force Flutter glass everywhere
- `flutterLens`: force lens shader (falls back to glass when unavailable)

### `LiquidGlassQuality`

- `low`: better performance
- `medium`: balanced (default)
- `high`: stronger effect, higher cost

## Main Surface API

`LiquidGlassSurface` parameters:

- `child`
- `borderRadius`
- `padding`, `margin`
- `elevation`
- `tintColor`, `tintOpacity`
- `blurSigma`
- `borderColor`, `borderWidth`
- `highlightStrength`
- `noiseOpacity`
- `mode`
- `quality`
- `enabled`
- `debugLabel`

## Usage

### Surface

```dart
LiquidGlassSurface(
  mode: LiquidGlassMode.auto,
  quality: LiquidGlassQuality.medium,
  borderRadius: BorderRadius.circular(24),
  blurSigma: 18,
  noiseOpacity: 0.05,
  child: const Text('Liquid glass'),
)
```

### Button + Navigation

```dart
Scaffold(
  appBar: const LiquidGlassNavigationBar(
    title: Text('Home'),
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

## iOS Native Rendering Notes

On iOS, `auto` and `iosNative` use a platform view backed by Swift/UIKit:

- native blur material (`UIVisualEffectView`)
- native tint/border/highlight composition
- Flutter `child` content remains in Dart above the native layer

## Performance Tips (Android/Flutter renderer)

- Keep `blurSigma` moderate (`12-18` is a good start).
- Use `LiquidGlassQuality.low` for long scrolling lists.
- Keep `noiseOpacity` subtle (`0.02-0.06`).
- Avoid many overlapping large blurred surfaces.

## Example App

Run from package root:

```bash
flutter run -d <device> -t example/lib/main.dart
```

or from `example/`:

```bash
flutter run
```

## License

MIT
