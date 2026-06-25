import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'android_glass.dart';
import 'enums.dart';
import 'liquid_glass_style.dart';
import 'native_glass_availability.dart';

/// iOS renderer that uses a native UIKit platform view when available.
class IosNativeGlassSurface extends StatefulWidget {
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
    this.iosBlurStyle,
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
  final LiquidGlassIosBlurStyle? iosBlurStyle;
  final String? debugLabel;

  @override
  State<IosNativeGlassSurface> createState() => _IosNativeGlassSurfaceState();
}

class _IosNativeGlassSurfaceState extends State<IosNativeGlassSurface> {
  bool _nativeRegistered = false;
  bool _checkedNativeRegistration = false;

  @override
  void initState() {
    super.initState();
    _checkNativeRegistration();
  }

  Future<void> _checkNativeRegistration() async {
    if (!_canUseNativeUIKit) {
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
    if (!_canUseNativeUIKit ||
        !widget.enabled ||
        !_checkedNativeRegistration ||
        !_nativeRegistered) {
      return _buildFlutterFallback();
    }

    final double cornerRadius = widget.borderRadius.topLeft.x;

    final Map<String, dynamic> params = <String, dynamic>{
      'enabled': widget.enabled,
      'quality': widget.quality.name,
      'borderRadius': cornerRadius,
      'elevation': widget.elevation,
      'tintColor': widget.tintColor.toARGB32(),
      'tintOpacity': widget.tintOpacity,
      'blurSigma': widget.blurSigma,
      'borderColor': widget.borderColor.toARGB32(),
      'borderWidth': widget.borderWidth,
      'highlightStrength': widget.highlightStrength,
      'noiseOpacity': widget.noiseOpacity,
    };

    if (widget.iosBlurStyle != null) {
      params['iosBlurStyle'] = widget.iosBlurStyle!.name;
    }

    return RepaintBoundary(
      child: Container(
        margin: widget.margin,
        child: Semantics(
          label: widget.debugLabel,
          child: ClipRRect(
            borderRadius: widget.borderRadius,
            child: Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                Positioned.fill(
                  // The native blur view is visual only; Flutter handles taps.
                  child: IgnorePointer(
                    child: UiKitView(
                      viewType: IosNativeGlassSurface._nativeViewType,
                      layoutDirection: Directionality.of(context),
                      creationParams: params,
                      creationParamsCodec: const StandardMessageCodec(),
                    ),
                  ),
                ),
                Padding(padding: widget.padding, child: widget.child),
              ],
            ),
          ),
        ),
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

  bool get _canUseNativeUIKit {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  }
}
