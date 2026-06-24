import 'package:flutter/material.dart';

import 'enums.dart';
import 'liquid_glass_surface.dart';
import 'liquid_glass_style.dart';

/// Liquid-glass switch with a compact native-feeling thumb animation.
class LiquidGlassSwitch extends StatelessWidget {
  /// Creates a liquid-glass switch.
  const LiquidGlassSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.mode = LiquidGlassMode.auto,
    this.quality = LiquidGlassQuality.medium,
    this.style,
    this.platformStyle,
    this.width = 56,
    this.height = 34,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor = Colors.white,
    this.enabled = true,
  });

  /// Whether the switch is on.
  final bool value;

  /// Called with the new value when toggled.
  final ValueChanged<bool>? onChanged;

  /// Backend selection mode for the liquid-glass surface.
  final LiquidGlassMode mode;

  /// Render quality preset for the selected backend.
  final LiquidGlassQuality quality;

  /// Shared glass style override.
  final LiquidGlassStyle? style;

  /// Platform-specific glass style override.
  final LiquidGlassPlatformStyle? platformStyle;

  /// Visual width of the switch.
  final double width;

  /// Visual height of the switch.
  final double height;

  /// Track accent when enabled and on.
  final Color? activeColor;

  /// Track tint when off.
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
    final double thumbSize = height - 8;
    final double travel = width - thumbSize - 8;

    return Semantics(
      toggled: value,
      enabled: isEnabled,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: isEnabled ? () => onChanged!(!value) : null,
        child: Opacity(
          opacity: isEnabled ? 1 : 0.5,
          child: LiquidGlassSurface(
            mode: mode,
            quality: quality,
            style: style,
            platformStyle: platformStyle,
            enabled: isEnabled,
            padding: const EdgeInsets.all(4),
            borderRadius: BorderRadius.circular(height / 2),
            elevation: value ? 4 : 1,
            tintColor: value ? resolvedActive : resolvedInactive,
            tintOpacity: value ? 0.45 : 0.22,
            blurSigma: 14,
            noiseOpacity: 0.025,
            child: SizedBox(
              width: width - 8,
              height: height - 8,
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 190),
                    curve: Curves.easeOutCubic,
                    left: value ? travel : 0,
                    top: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 190),
                      curve: Curves.easeOutCubic,
                      width: thumbSize,
                      height: thumbSize,
                      decoration: BoxDecoration(
                        color: thumbColor,
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.22),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
