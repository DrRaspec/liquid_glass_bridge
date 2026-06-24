import 'package:flutter/material.dart';

import 'enums.dart';
import 'liquid_glass_surface.dart';
import 'liquid_glass_style.dart';

/// Liquid-glass slider that keeps Flutter's accessibility and gestures.
class LiquidGlassSlider extends StatelessWidget {
  /// Creates a liquid-glass slider.
  const LiquidGlassSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.label,
    this.mode = LiquidGlassMode.auto,
    this.quality = LiquidGlassQuality.medium,
    this.style,
    this.platformStyle,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor = Colors.white,
    this.enabled = true,
  });

  /// Current slider value.
  final double value;

  /// Called as the user drags the slider.
  final ValueChanged<double>? onChanged;

  /// Minimum selectable value.
  final double min;

  /// Maximum selectable value.
  final double max;

  /// Optional number of discrete divisions.
  final int? divisions;

  /// Optional value label shown by platform slider semantics.
  final String? label;

  /// Backend selection mode for the liquid-glass surface.
  final LiquidGlassMode mode;

  /// Render quality preset for the selected backend.
  final LiquidGlassQuality quality;

  /// Shared glass style override.
  final LiquidGlassStyle? style;

  /// Platform-specific glass style override.
  final LiquidGlassPlatformStyle? platformStyle;

  /// Active track color.
  final Color? activeColor;

  /// Inactive track color.
  final Color? inactiveColor;

  /// Thumb color.
  final Color thumbColor;

  /// Whether interaction is enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = enabled && onChanged != null;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color resolvedActive = activeColor ?? scheme.primary;
    final Color resolvedInactive =
        inactiveColor ?? scheme.onSurface.withValues(alpha: 0.18);

    return Opacity(
      opacity: isEnabled ? 1 : 0.55,
      child: LiquidGlassSurface(
        mode: mode,
        quality: quality,
        style: style,
        platformStyle: platformStyle,
        enabled: isEnabled,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        borderRadius: BorderRadius.circular(22),
        elevation: 2,
        tintOpacity: 0.14,
        blurSigma: 14,
        noiseOpacity: 0.025,
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: resolvedActive,
            inactiveTrackColor: resolvedInactive,
            thumbColor: thumbColor,
            overlayColor: resolvedActive.withValues(alpha: 0.16),
            trackHeight: 8,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 11),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            label: label,
            onChanged: isEnabled ? onChanged : null,
          ),
        ),
      ),
    );
  }
}
