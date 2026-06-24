import 'package:flutter/services.dart';

/// Checks whether the native platform-view factory is registered.
class NativeGlassAvailability {
  const NativeGlassAvailability._();

  static const MethodChannel _channel = MethodChannel(
    'liquid_glass_bridge/native_glass',
  );

  /// Returns true when the host app registered this package's native plugin.
  static Future<bool> isRegistered() async {
    try {
      return await _channel.invokeMethod<bool>('isRegistered') ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }
}
