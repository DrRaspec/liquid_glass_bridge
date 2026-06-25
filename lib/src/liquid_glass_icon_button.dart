import 'package:flutter/material.dart';

import 'enums.dart';
import 'liquid_glass_button.dart';
import 'liquid_glass_style.dart';

/// Circular liquid-glass icon button tuned for toolbar-style actions.
class LiquidGlassIconButton extends StatelessWidget {
  /// Creates a circular liquid-glass icon button.
  const LiquidGlassIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.mode = LiquidGlassMode.auto,
    this.quality = LiquidGlassQuality.medium,
    this.style = LiquidGlassPresets.ios26Icon,
    this.platformStyle,
    this.size = 68,
    this.borderRadius,
    this.padding = EdgeInsets.zero,
    this.iconSize = 28,
    this.iconColor = Colors.white,
    this.enabled = true,
    this.debugLabel,
  });

  /// Icon rendered in the center of the button.
  final IconData icon;

  /// Called when the button is tapped.
  final VoidCallback? onPressed;

  /// Backend selection mode for the liquid-glass renderer.
  final LiquidGlassMode mode;

  /// Render quality preset for the selected backend.
  final LiquidGlassQuality quality;

  /// Glass style for the circular shell.
  final LiquidGlassStyle style;

  /// Platform-specific style override.
  final LiquidGlassPlatformStyle? platformStyle;

  /// Width and height of the button.
  final double size;

  /// Corner radius for the glass shell.
  ///
  /// Defaults to a circle based on [size].
  final BorderRadius? borderRadius;

  /// Padding inside the glass shell.
  final EdgeInsetsGeometry padding;

  /// Icon size.
  final double iconSize;

  /// Icon color.
  final Color iconColor;

  /// Whether the button is enabled.
  final bool enabled;

  /// Optional semantics label.
  final String? debugLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: LiquidGlassButton(
        mode: mode,
        quality: quality,
        enabled: enabled,
        onPressed: onPressed,
        style: style,
        platformStyle: platformStyle,
        borderRadius: borderRadius ?? BorderRadius.circular(size / 2),
        padding: padding,
        debugLabel: debugLabel,
        child: Icon(icon, size: iconSize, color: iconColor),
      ),
    );
  }
}
