package com.drraspec.liquid_glass_bridge

import android.app.Activity
import android.content.Context
import android.graphics.Color
import android.graphics.Outline
import android.view.View
import android.view.ViewGroup
import android.view.ViewOutlineProvider
import android.widget.FrameLayout
import eightbitlab.com.blurview.BlurView
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class LiquidGlassNativeViewFactory :
  PlatformViewFactory(StandardMessageCodec.INSTANCE) {
  override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
    val params = args as? Map<String, Any?> ?: emptyMap()
    return LiquidGlassNativeView(context, params)
  }
}

class LiquidGlassNativeView(
  private val context: Context,
  private val params: Map<String, Any?>
) : PlatformView {
  private val rootView = FrameLayout(context)
  private val blurView = BlurView(context)

  init {
    rootView.setBackgroundColor(Color.TRANSPARENT)
    rootView.addView(
      blurView,
      FrameLayout.LayoutParams(
        FrameLayout.LayoutParams.MATCH_PARENT,
        FrameLayout.LayoutParams.MATCH_PARENT
      )
    )
    blurView.setOverlayColor(Color.TRANSPARENT)

    applyAppearance()
  }

  override fun getView(): View {
    return rootView
  }

  override fun dispose() {
    // No-op
  }

  private fun applyAppearance() {
    val enabled = boolArg("enabled", true)
    val blurSigma = doubleArg("blurSigma", 18.0).toFloat()
    val borderRadius = doubleArg("borderRadius", 24.0).toFloat()

    applyOutline(borderRadius)
    setupBlur(enabled, blurSigma)
  }

  private fun applyOutline(borderRadius: Float) {
    rootView.clipToOutline = true
    rootView.outlineProvider = object : ViewOutlineProvider() {
      override fun getOutline(view: View, outline: Outline) {
        outline.setRoundRect(0, 0, view.width, view.height, borderRadius)
      }
    }
    rootView.addOnLayoutChangeListener { _, _, _, _, _, _, _, _, _ ->
      rootView.invalidateOutline()
    }
  }

  private fun setupBlur(enabled: Boolean, blurRadius: Float) {
    val activity = context as? Activity
    val decorView = activity?.window?.decorView
    val root = decorView?.findViewById<ViewGroup>(android.R.id.content)

    if (root == null || decorView == null) {
      blurView.setBlurRadius(0f)
      return
    }

    blurView.setupWith(root)
      .setFrameClearDrawable(decorView.background)
      .setBlurRadius(if (enabled) blurRadius else 0f)
      .setBlurAutoUpdate(true)
  }

  private fun boolArg(key: String, defaultValue: Boolean): Boolean {
    return params[key] as? Boolean ?: defaultValue
  }

  private fun doubleArg(key: String, defaultValue: Double): Double {
    val value = params[key]
    if (value is Number) {
      return value.toDouble()
    }
    return defaultValue
  }
}
