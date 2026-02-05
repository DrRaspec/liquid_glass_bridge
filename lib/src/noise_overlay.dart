import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoiseOverlay extends StatefulWidget {
  const NoiseOverlay({
    super.key,
    required this.opacity,
    required this.borderRadius,
  });

  static const String assetPath =
      'packages/liquid_glass_bridge/assets/noise_64.png';

  final double opacity;
  final BorderRadius borderRadius;

  @override
  State<NoiseOverlay> createState() => _NoiseOverlayState();
}

class _NoiseOverlayState extends State<NoiseOverlay> {
  ui.Image? _noiseImage;

  @override
  void initState() {
    super.initState();
    _loadNoise();
  }

  Future<void> _loadNoise() async {
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
      if (!mounted) {
        return;
      }
      setState(() {
        _noiseImage = frame.image;
      });
    } catch (_) {
      // Asset is optional; silently skip if unavailable.
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
