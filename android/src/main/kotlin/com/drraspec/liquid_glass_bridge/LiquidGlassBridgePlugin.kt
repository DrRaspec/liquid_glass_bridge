package com.drraspec.liquid_glass_bridge

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class LiquidGlassBridgePlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
  private var channel: MethodChannel? = null

  override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    val factory = LiquidGlassNativeViewFactory()
    binding.platformViewRegistry.registerViewFactory(
      "liquid_glass_bridge/native_glass_view",
      factory
    )
    channel = MethodChannel(binding.binaryMessenger, "liquid_glass_bridge/native_glass")
    channel?.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel?.setMethodCallHandler(null)
    channel = null
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "isRegistered" -> result.success(true)
      else -> result.notImplemented()
    }
  }
}
