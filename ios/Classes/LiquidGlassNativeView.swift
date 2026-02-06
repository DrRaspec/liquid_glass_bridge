import Flutter
import UIKit

final class LiquidGlassNativeViewFactory: NSObject, FlutterPlatformViewFactory {
  init(messenger: FlutterBinaryMessenger) {
    super.init()
  }

  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    FlutterStandardMessageCodec.sharedInstance()
  }

  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    let params = args as? [String: Any] ?? [:]
    return LiquidGlassNativeView(frame: frame, viewId: viewId, args: params)
  }
}

private final class GlassContentView: UIView {
  let highlightLayer = CAGradientLayer()

  override init(frame: CGRect) {
    super.init(frame: frame)
    clipsToBounds = true
    highlightLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
    highlightLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
    layer.addSublayer(highlightLayer)
  }

  required init?(coder: NSCoder) {
    nil
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    highlightLayer.frame = bounds
  }
}

final class LiquidGlassNativeView: NSObject, FlutterPlatformView {
  private let rootView = UIView()
  private let glassView = GlassContentView()
  private let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
  private let tintView = UIView()

  init(frame: CGRect, viewId: Int64, args: [String: Any]) {
    super.init()

    rootView.backgroundColor = .clear
    rootView.frame = frame
    rootView.addSubview(glassView)

    glassView.frame = rootView.bounds
    glassView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    effectView.frame = glassView.bounds
    effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    tintView.frame = glassView.bounds
    tintView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    glassView.addSubview(effectView)
    glassView.addSubview(tintView)

    applyAppearance(args)
  }

  func view() -> UIView {
    rootView
  }

  private func applyAppearance(_ args: [String: Any]) {
    let enabled = boolArg(args, "enabled", defaultValue: true)
    let borderRadius = CGFloat(doubleArg(args, "borderRadius", defaultValue: 24.0))
    let borderWidth = CGFloat(doubleArg(args, "borderWidth", defaultValue: 1.0))
    let tintOpacity = CGFloat(doubleArg(args, "tintOpacity", defaultValue: 0.2))
    let elevation = CGFloat(doubleArg(args, "elevation", defaultValue: 6.0))
    let rawHighlightStrength = CGFloat(doubleArg(args, "highlightStrength", defaultValue: 0.35))
    let highlightStrength = enabled ? rawHighlightStrength : 0.0

    let tintColor = colorFromARGB(intArg(args, "tintColor", defaultValue: 0xFFFFFFFF))
    let borderColor = colorFromARGB(intArg(args, "borderColor", defaultValue: 0x99FFFFFF))

    let blurStyleName = stringArg(args, "iosBlurStyle", defaultValue: "")
    let blurStyle = blurStyleName.isEmpty
      ? blurStyleFromQuality(stringArg(args, "quality", defaultValue: "medium"))
      : blurStyleFromName(blurStyleName)
    effectView.effect = enabled ? UIBlurEffect(style: blurStyle) : nil

    glassView.layer.cornerRadius = borderRadius
    glassView.layer.borderWidth = borderWidth
    glassView.layer.borderColor = borderColor.withAlphaComponent(enabled ? 0.78 : 0.65).cgColor

    tintView.backgroundColor = tintColor.withAlphaComponent(enabled ? tintOpacity : tintOpacity * 0.85)

    rootView.layer.shadowColor = UIColor.black.cgColor
    rootView.layer.shadowOpacity = enabled ? Float(min(0.22, 0.08 + (elevation * 0.012))) : 0
    rootView.layer.shadowRadius = max(0, elevation * 2.2)
    rootView.layer.shadowOffset = CGSize(width: 0, height: elevation * 0.7)

    let topAlpha = min(0.58, max(0.0, 0.36 * highlightStrength))
    let midAlpha = min(0.30, max(0.0, 0.12 * highlightStrength))
    glassView.highlightLayer.colors = [
      UIColor.white.withAlphaComponent(topAlpha).cgColor,
      UIColor.white.withAlphaComponent(midAlpha).cgColor,
      UIColor.white.withAlphaComponent(0.0).cgColor,
    ]
    glassView.highlightLayer.locations = [0.0, 0.28, 0.75]
  }

  private func blurStyleFromQuality(_ quality: String) -> UIBlurEffect.Style {
    switch quality {
    case "low":
      return .systemThinMaterial
    case "high":
      return .systemThickMaterial
    default:
      return .systemMaterial
    }
  }

  private func blurStyleFromName(_ style: String) -> UIBlurEffect.Style {
    switch style {
    case "systemUltraThinMaterial":
      return .systemUltraThinMaterial
    case "systemThinMaterial":
      return .systemThinMaterial
    case "systemThickMaterial":
      return .systemThickMaterial
    case "systemChromeMaterial":
      return .systemChromeMaterial
    default:
      return .systemMaterial
    }
  }

  private func stringArg(_ args: [String: Any], _ key: String, defaultValue: String) -> String {
    args[key] as? String ?? defaultValue
  }

  private func boolArg(_ args: [String: Any], _ key: String, defaultValue: Bool) -> Bool {
    args[key] as? Bool ?? defaultValue
  }

  private func doubleArg(_ args: [String: Any], _ key: String, defaultValue: Double) -> Double {
    if let value = args[key] as? NSNumber {
      return value.doubleValue
    }
    return defaultValue
  }

  private func intArg(_ args: [String: Any], _ key: String, defaultValue: UInt32) -> UInt32 {
    if let value = args[key] as? NSNumber {
      return value.uint32Value
    }
    return defaultValue
  }

  private func colorFromARGB(_ argb: UInt32) -> UIColor {
    let alpha = CGFloat((argb >> 24) & 0xFF) / 255.0
    let red = CGFloat((argb >> 16) & 0xFF) / 255.0
    let green = CGFloat((argb >> 8) & 0xFF) / 255.0
    let blue = CGFloat(argb & 0xFF) / 255.0
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
  }
}
