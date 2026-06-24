import Flutter
import UIKit

public class LiquidGlassBridgePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let factory = LiquidGlassNativeViewFactory(messenger: registrar.messenger())
    registrar.register(factory, withId: "liquid_glass_bridge/native_glass_view")

    let channel = FlutterMethodChannel(
      name: "liquid_glass_bridge/native_glass",
      binaryMessenger: registrar.messenger()
    )
    let instance = LiquidGlassBridgePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isRegistered":
      result(true)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
