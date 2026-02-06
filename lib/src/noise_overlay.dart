import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Subtle tiled-noise overlay used to enhance glass realism.
class NoiseOverlay extends StatefulWidget {
  /// Creates a noise overlay.
  const NoiseOverlay({
    super.key,
    required this.opacity,
    required this.borderRadius,
  });

  /// Bundled noise asset path.
  static const String assetPath =
      'packages/liquid_glass_bridge/assets/noise_64.png';

  final double opacity;
  final BorderRadius borderRadius;

  @override
  State<NoiseOverlay> createState() => _NoiseOverlayState();
}

class _NoiseOverlayState extends State<NoiseOverlay> {
  static ui.Image? _sharedImage;
  static Future<ui.Image?>? _sharedLoader;

  ui.Image? _noiseImage;

  @override
  void initState() {
    super.initState();
    _loadNoise();
  }

  Future<void> _loadNoise() async {
    if (_sharedImage != null) {
      if (mounted) {
        setState(() {
          _noiseImage = _sharedImage;
        });
      }
      return;
    }

    _sharedLoader ??= _decodeNoise();
    final ui.Image? image = await _sharedLoader;
    if (!mounted) {
      return;
    }
    setState(() {
      _noiseImage = image;
    });
  }

  static Future<ui.Image?> _decodeNoise() async {
    try {
      final ByteData data = await rootBundle.load(NoiseOverlay.assetPath);
      final Uint8List bytes = data.buffer.asUint8List();
      final ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(
        bytes,
      );
      final ui.ImageDescriptor descriptor = await ui.ImageDescriptor.encoded(
        buffer,
      );
      final ui.Codec codec = await descriptor.instantiateCodec();
      final ui.FrameInfo frame = await codec.getNextFrame();
      _sharedImage = frame.image;
      return _sharedImage;
    } catch (_) {
      // Asset is optional; silently skip if unavailable.
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_noiseImage == null || widget.opacity <= 0) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: CustomPaint(
          painter: _NoisePainter(
            image: _noiseImage!,
            opacity: widget.opacity,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _NoisePainter extends CustomPainter {
  _NoisePainter({
    required this.image,
    required this.opacity,
  });

  final ui.Image image;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..blendMode = BlendMode.overlay
      ..color = Colors.white.withValues(alpha: opacity)
      ..shader = ImageShader(
        image,
        TileMode.repeated,
        TileMode.repeated,
        Matrix4.identity().storage,
      );

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _NoisePainter oldDelegate) {
    return oldDelegate.image != image || oldDelegate.opacity != opacity;
  }
}
