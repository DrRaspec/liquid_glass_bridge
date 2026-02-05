import Flutter
import UIKit

public class LiquidGlassBridgePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let factory = LiquidGlassNativeViewFactory(messenger: registrar.messenger())
    registrar.register(factory, withId: "liquid_glass_bridge/native_glass_view")
  }
}
