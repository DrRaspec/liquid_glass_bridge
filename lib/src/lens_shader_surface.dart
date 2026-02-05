import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'android_glass.dart';
import 'enums.dart';

/// Shader-based lens renderer with automatic fallback to Flutter glass.
class LensShaderSurface extends StatefulWidget {
  /// Creates the lens shader renderer.
  const LensShaderSurface({
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

  /// Returns true when lens mode should fallback to standard glass.
  static bool shouldFallbackToGlass({
    required bool shaderSupported,
    required bool shaderLoaded,
  }) {
    return !shaderSupported || !shaderLoaded;
  }

  @override
  State<LensShaderSurface> createState() => _LensShaderSurfaceState();
}

class _LensShaderSurfaceState extends State<LensShaderSurface>
    with SingleTickerProviderStateMixin {
  FragmentProgram? _program;
  late final AnimationController _controller;
  bool _shaderLoadAttempted = false;

  bool get _shaderSupported {
    return !kIsWeb;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _loadShader();
  }

  Future<void> _loadShader() async {
    if (!_shaderSupported || _shaderLoadAttempted) {
      setState(() {
        _shaderLoadAttempted = true;
      });
      return;
    }

    try {
      final FragmentProgram program = await FragmentProgram.fromAsset(
        'packages/liquid_glass_bridge/shaders/liquid_lens.frag',
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _program = program;
        _shaderLoadAttempted = true;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _shaderLoadAttempted = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool shaderLoaded = _program != null;
    final bool fallback = LensShaderSurface.shouldFallbackToGlass(
      shaderSupported: _shaderSupported,
      shaderLoaded: shaderLoaded,
    );

    if (fallback) {
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

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? _) {
        final double wobble = (math.sin(_controller.value * math.pi * 2.0) * 0.5 + 0.5);
        return RepaintBoundary(
          child: Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              AndroidGlassSurface(
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
              ),
              IgnorePointer(
                child: Container(
                  margin: widget.margin,
                  child: ClipRRect(
                    borderRadius: widget.borderRadius,
                    child: CustomPaint(
                      painter: _LensOverlayPainter(
                        program: _program!,
                        time: _controller.value,
                        strength: (widget.highlightStrength * 0.6 + wobble * 0.35)
                            .clamp(0.0, 1.0)
                            .toDouble(),
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LensOverlayPainter extends CustomPainter {
  _LensOverlayPainter({
    required this.program,
    required this.time,
    required this.strength,
  });

  final FragmentProgram program;
  final double time;
  final double strength;

  @override
  void paint(Canvas canvas, Size size) {
    final FragmentShader shader = program.fragmentShader();
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, time)
      ..setFloat(3, strength)
      ..setFloat(4, PlatformDispatcher.instance.views.first.devicePixelRatio);

    final Paint paint = Paint()
      ..blendMode = BlendMode.plus
      ..shader = shader;

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _LensOverlayPainter oldDelegate) {
    return oldDelegate.program != program ||
        oldDelegate.time != time ||
        oldDelegate.strength != strength;
  }
}
