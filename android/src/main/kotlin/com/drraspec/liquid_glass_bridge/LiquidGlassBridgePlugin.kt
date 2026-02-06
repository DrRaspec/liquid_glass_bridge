package com.drraspec.liquid_glass_bridge

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin

class LiquidGlassBridgePlugin : FlutterPlugin {
  override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    val factory = LiquidGlassNativeViewFactory()
    binding.platformViewRegistry.registerViewFactory(
      "liquid_glass_bridge/native_glass_view",
      factory
    )
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    // No-op
  }
}
