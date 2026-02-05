import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'android_glass.dart';
import 'enums.dart';

/// iOS renderer that uses a native UIKit platform view when available.
class IosNativeGlassSurface extends StatelessWidget {
  /// Creates the iOS-native renderer.
  const IosNativeGlassSurface({
    super.key,
    required this.child,
    required this.borderRadius,
    required this.padding,
    required this.margin,
    required this.elevation,
    required this.tintColor,
    required this.tintOpacity,
    required this.blurSigma,
    required this.borderColor,
    required this.borderWidth,
    required this.highlightStrength,
    required this.noiseOpacity,
    required this.quality,
    required this.enabled,
    this.debugLabel,
  });

  static const String _nativeViewType = 'liquid_glass_bridge/native_glass_view';

  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double elevation;
  final Color tintColor;
  final double tintOpacity;
  final double blurSigma;
  final Color borderColor;
  final double borderWidth;
  final double highlightStrength;
  final double noiseOpacity;
  final LiquidGlassQuality quality;
  final bool enabled;
  final String? debugLabel;

  @override
  Widget build(BuildContext context) {
    if (!_canUseNativeUIKit || !enabled) {
      return AndroidGlassSurface(
        borderRadius: borderRadius,
        padding: padding,
        margin: margin,
        elevation: elevation,
        tintColor: tintColor,
        tintOpacity: tintOpacity,
        blurSigma: blurSigma,
        borderColor: borderColor,
        borderWidth: borderWidth,
        highlightStrength: highlightStrength,
        noiseOpacity: noiseOpacity,
        quality: quality,
        enabled: enabled,
        debugLabel: debugLabel,
        child: child,
      );
    }

    final double cornerRadius = borderRadius.topLeft.x;

    return RepaintBoundary(
      child: Container(
        margin: margin,
        child: Semantics(
          label: debugLabel,
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                UiKitView(
                  viewType: _nativeViewType,
                  layoutDirection: Directionality.of(context),
                  creationParams: <String, dynamic>{
                    'enabled': enabled,
                    'quality': quality.name,
                    'borderRadius': cornerRadius,
                    'elevation': elevation,
                    'tintColor': tintColor.toARGB32(),
                    'tintOpacity': tintOpacity,
                    'blurSigma': blurSigma,
                    'borderColor': borderColor.toARGB32(),
                    'borderWidth': borderWidth,
                    'highlightStrength': highlightStrength,
                    'noiseOpacity': noiseOpacity,
                  },
                  creationParamsCodec: const StandardMessageCodec(),
                ),
                Padding(
                  padding: padding,
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool get _canUseNativeUIKit {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  }
}
