import 'package:flutter/material.dart';

import 'enums.dart';
import 'liquid_glass_surface.dart';

/// Data model for one item inside [LiquidGlassBottomNavigationBar].
class LiquidGlassNavItem {
  /// Creates a navigation item.
  const LiquidGlassNavItem({
    required this.icon,
    required this.label,
    this.activeIcon,
  });

  final IconData icon;
  final String label;
  final IconData? activeIcon;
}

/// iOS-like bottom tab bar rendered with liquid-glass styling.
class LiquidGlassBottomNavigationBar extends StatelessWidget {
  /// Creates a liquid-glass bottom navigation bar.
  const LiquidGlassBottomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.mode = LiquidGlassMode.auto,
    this.quality = LiquidGlassQuality.medium,
    this.enabled = true,
    this.height = 74,
    this.margin = const EdgeInsets.fromLTRB(12, 0, 12, 12),
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.elevation = 8,
    this.tintColor = const Color(0xFFFFFFFF),
    this.tintOpacity = 0.2,
    this.blurSigma = 18,
    this.borderColor = const Color(0x99FFFFFF),
    this.borderWidth = 1,
    this.highlightStrength = 0.35,
    this.noiseOpacity = 0.05,
    this.activeColor,
    this.inactiveColor,
  }) : assert(items.length >= 2, 'Bottom navigation needs at least 2 items.'),
       assert(
         currentIndex >= 0 && currentIndex < items.length,
         'currentIndex must be inside the items range.',
       );

  final List<LiquidGlassNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
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
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color resolvedActive = activeColor ?? scheme.primary;
    final Color resolvedInactive =
        inactiveColor ?? scheme.onSurface.withValues(alpha: 0.7);

    return LiquidGlassSurface(
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
          children: List<Widget>.generate(items.length, (int index) {
            final bool isActive = index == currentIndex;
            final LiquidGlassNavItem item = items[index];
            final Color color = isActive ? resolvedActive : resolvedInactive;
            return Expanded(
              child: GestureDetector(
                onTap: enabled ? () => onTap(index) : null,
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: isActive
                        ? resolvedActive.withValues(alpha: 0.12)
                        : Colors.transparent,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        isActive ? (item.activeIcon ?? item.icon) : item.icon,
                        color: color,
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: color,
                              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
