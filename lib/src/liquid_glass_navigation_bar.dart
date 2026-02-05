import 'package:flutter/material.dart';

import 'enums.dart';
import 'liquid_glass_surface.dart';

/// iOS-style top navigation bar rendered with liquid-glass styling.
class LiquidGlassNavigationBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// Creates a liquid-glass navigation bar.
  const LiquidGlassNavigationBar({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.mode = LiquidGlassMode.auto,
    this.quality = LiquidGlassQuality.medium,
    this.enabled = true,
    this.height = 64,
    this.margin = const EdgeInsets.fromLTRB(12, 12, 12, 8),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.elevation = 6,
    this.tintColor = const Color(0xFFFFFFFF),
    this.tintOpacity = 0.2,
    this.blurSigma = 16,
    this.borderColor = const Color(0x99FFFFFF),
    this.borderWidth = 1,
    this.highlightStrength = 0.35,
    this.noiseOpacity = 0.05,
  });

  final Widget title;
  final Widget? leading;
  final Widget? trailing;
  final LiquidGlassMode mode;
  final LiquidGlassQuality quality;
  final bool enabled;
  final double height;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double elevation;
  final Color tintColor;
  final double tintOpacity;
  final double blurSigma;
  final Color borderColor;
  final double borderWidth;
  final double highlightStrength;
  final double noiseOpacity;

  @override
  Size get preferredSize => Size.fromHeight(height + 24);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: LiquidGlassSurface(
        mode: mode,
        quality: quality,
        enabled: enabled,
        margin: margin,
        padding: padding,
        borderRadius: borderRadius,
        elevation: elevation,
        tintColor: tintColor,
        tintOpacity: tintOpacity,
        blurSigma: blurSigma,
        borderColor: borderColor,
        borderWidth: borderWidth,
        highlightStrength: highlightStrength,
        noiseOpacity: noiseOpacity,
        child: SizedBox(
          height: height,
          child: Row(
            children: <Widget>[
              SizedBox(width: 44, child: leading),
              Expanded(
                child: DefaultTextStyle.merge(
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                  child: title,
                ),
              ),
              SizedBox(width: 44, child: trailing),
            ],
          ),
        ),
      ),
    );
  }
}
