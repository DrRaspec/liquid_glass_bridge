import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'android_glass.dart';
import 'enums.dart';
import 'glass_effects.dart';
import 'native_glass_availability.dart';
import 'noise_overlay.dart';

/// Android-native blur renderer backed by a platform view.
class AndroidNativeGlassSurface extends StatefulWidget {
  const AndroidNativeGlassSurface({
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
  State<AndroidNativeGlassSurface> createState() =>
      _AndroidNativeGlassSurfaceState();
}

class _AndroidNativeGlassSurfaceState extends State<AndroidNativeGlassSurface> {
  bool _nativeRegistered = false;
  bool _checkedNativeRegistration = false;

  @override
  void initState() {
    super.initState();
    _checkNativeRegistration();
  }

  Future<void> _checkNativeRegistration() async {
    if (!_canUseNativeAndroid) {
      return;
    }
    final bool registered = await NativeGlassAvailability.isRegistered();
    if (!mounted) {
      return;
    }
    setState(() {
      _nativeRegistered = registered;
      _checkedNativeRegistration = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_canUseNativeAndroid ||
        !widget.enabled ||
        !_checkedNativeRegistration ||
        !_nativeRegistered) {
      return _buildFlutterFallback();
    }

    final double effectiveBlur =
        widget.blurSigma * widget.quality.blurMultiplier;
    final double effectiveNoise =
        widget.noiseOpacity * widget.quality.noiseMultiplier;
    final double effectiveHighlight =
        widget.highlightStrength * widget.quality.highlightMultiplier;
    final double cornerRadius = widget.borderRadius.topLeft.x;

    final String viewKey =
        '${effectiveBlur.toStringAsFixed(2)}_'
        '${cornerRadius.toStringAsFixed(2)}_${widget.enabled ? 1 : 0}';

    final Widget core = ClipRRect(
      borderRadius: widget.borderRadius,
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          if (effectiveBlur > 0)
            Positioned.fill(
              child: IgnorePointer(
                child: AndroidView(
                  key: ValueKey<String>(viewKey),
                  viewType: AndroidNativeGlassSurface._nativeViewType,
                  creationParams: <String, dynamic>{
                    'enabled': widget.enabled,
                    'blurSigma': effectiveBlur,
                    'borderRadius': cornerRadius,
                  },
                  creationParamsCodec: const StandardMessageCodec(),
                ),
              ),
            ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: applyOpacity(
                widget.tintColor,
                (widget.enabled
                        ? widget.tintOpacity
                        : widget.tintOpacity * 0.85)
                    .toDouble(),
              ),
              borderRadius: widget.borderRadius,
              border: Border.all(
                color: applyOpacity(
                  widget.borderColor,
                  (widget.enabled ? 1 : 0.75).toDouble(),
                ),
                width: widget.borderWidth,
              ),
            ),
            child: Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                Padding(padding: widget.padding, child: widget.child),
                Positioned.fill(
                  child: SpecularHighlight(
                    borderRadius: widget.borderRadius,
                    strength: effectiveHighlight,
                  ),
                ),
                if (effectiveNoise > 0)
                  Positioned.fill(
                    child: NoiseOverlay(
                      opacity: effectiveNoise.clamp(0.0, 1.0).toDouble(),
                      borderRadius: widget.borderRadius,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    return RepaintBoundary(
      child: Container(
        margin: widget.margin,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          boxShadow: widget.elevation <= 0
              ? null
              : <BoxShadow>[
                  BoxShadow(
                    color: applyOpacity(Colors.black, 0.18),
                    blurRadius: widget.elevation * 3.0,
                    spreadRadius: widget.elevation * 0.2,
                    offset: Offset(0, widget.elevation * 0.8),
                  ),
                ],
        ),
        child: Semantics(label: widget.debugLabel, child: core),
      ),
    );
  }

  Widget _buildFlutterFallback() {
    return AndroidGlassSurface(
      borderRadius: widget.borderRadius,
      padding: widget.padding,
      margin: widget.margin,
      elevation: widget.elevation,
      tintColor: widget.tintColor,
      tintOpacity: widget.tintOpacity,
      blurSigma: widget.blurSigma,
      borderColor: widget.borderColor,
      borderWidth: widget.borderWidth,
      highlightStrength: widget.highlightStrength,
      noiseOpacity: widget.noiseOpacity,
      quality: widget.quality,
      enabled: widget.enabled,
      debugLabel: widget.debugLabel,
      child: widget.child,
    );
  }

  bool get _canUseNativeAndroid {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  }
}
