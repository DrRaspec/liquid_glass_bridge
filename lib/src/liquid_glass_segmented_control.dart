import 'package:flutter/material.dart';

import 'enums.dart';
import 'liquid_glass_surface.dart';
import 'liquid_glass_style.dart';

/// Liquid-glass segmented control for small mutually exclusive choices.
class LiquidGlassSegmentedControl<T extends Object> extends StatelessWidget {
  /// Creates a segmented control from an ordered map of values to labels/icons.
  const LiquidGlassSegmentedControl({
    super.key,
    required this.children,
    required this.groupValue,
    required this.onValueChanged,
    this.mode = LiquidGlassMode.auto,
    this.quality = LiquidGlassQuality.medium,
    this.style,
    this.platformStyle,
    this.height = 44,
    this.padding = const EdgeInsets.all(4),
    this.selectedColor,
    this.unselectedColor,
    this.selectedForegroundColor,
    this.unselectedForegroundColor,
    this.enabled = true,
  }) : assert(children.length >= 2, 'At least two segments are required.');

  /// Segment values and their visible widgets, in display order.
  final Map<T, Widget> children;

  /// Currently selected value.
  final T groupValue;

  /// Called when the user selects a different segment.
  final ValueChanged<T> onValueChanged;

  /// Backend selection mode for the liquid-glass surface.
  final LiquidGlassMode mode;

  /// Render quality preset for the selected backend.
  final LiquidGlassQuality quality;

  /// Shared glass style override.
  final LiquidGlassStyle? style;

  /// Platform-specific glass style override.
  final LiquidGlassPlatformStyle? platformStyle;

  /// Height of the complete control.
  final double height;

  /// Padding between the glass shell and segment pills.
  final EdgeInsetsGeometry padding;

  /// Background color for the selected pill.
  final Color? selectedColor;

  /// Background color for unselected pills.
  final Color? unselectedColor;

  /// Foreground color for selected segment content.
  final Color? selectedForegroundColor;

  /// Foreground color for unselected segment content.
  final Color? unselectedForegroundColor;

  /// Whether interaction is enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color resolvedSelectedColor =
        selectedColor ?? Colors.white.withValues(alpha: 0.72);
    final Color resolvedUnselectedColor = unselectedColor ?? Colors.transparent;
    final Color resolvedSelectedForeground =
        selectedForegroundColor ?? scheme.onSurface;
    final Color resolvedUnselectedForeground =
        unselectedForegroundColor ?? scheme.onSurface.withValues(alpha: 0.68);

    return Semantics(
      enabled: enabled,
      inMutuallyExclusiveGroup: true,
      child: LiquidGlassSurface(
        mode: mode,
        quality: quality,
        style: style,
        platformStyle: platformStyle,
        enabled: enabled,
        padding: padding,
        borderRadius: BorderRadius.circular(height / 2),
        elevation: 2,
        tintOpacity: 0.16,
        blurSigma: 16,
        noiseOpacity: 0.035,
        child: SizedBox(
          height: height - 8,
          child: Row(
            children: children.entries.map((MapEntry<T, Widget> entry) {
              final bool selected = entry.key == groupValue;
              return Expanded(
                child: _Segment(
                  selected: selected,
                  enabled: enabled,
                  selectedColor: resolvedSelectedColor,
                  unselectedColor: resolvedUnselectedColor,
                  selectedForegroundColor: resolvedSelectedForeground,
                  unselectedForegroundColor: resolvedUnselectedForeground,
                  onTap: () => onValueChanged(entry.key),
                  child: entry.value,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.selected,
    required this.enabled,
    required this.selectedColor,
    required this.unselectedColor,
    required this.selectedForegroundColor,
    required this.unselectedForegroundColor,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final bool enabled;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedForegroundColor;
  final Color unselectedForegroundColor;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Color foreground = selected
        ? selectedForegroundColor
        : unselectedForegroundColor;

    return Semantics(
      selected: selected,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled && !selected ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? selectedColor : unselectedColor,
            borderRadius: BorderRadius.circular(999),
            boxShadow: selected
                ? <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: DefaultTextStyle.merge(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: foreground.withValues(alpha: enabled ? 1 : 0.48),
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
            child: IconTheme.merge(
              data: IconThemeData(
                color: foreground.withValues(alpha: enabled ? 1 : 0.48),
                size: 18,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
