package com.nover.flutternativeadmob

import android.content.Context
import com.google.android.gms.ads.MobileAds
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

enum class CallMethod {
  initialize, setStyle
}

class FlutterNativeAdmobPlugin(
    private val channel: MethodChannel,
    private val context: Context
): MethodCallHandler {

  companion object {

    const val viewType = "native_admob_banner_view"

    @JvmStatic
    fun registerWith(registrar: Registrar) {
      // channel for the plugin
      val channel = MethodChannel(registrar.messenger(), "flutter_native_admob")
      channel.setMethodCallHandler(FlutterNativeAdmobPlugin(channel, registrar.context()))

      // create platform view
      registrar
          .platformViewRegistry()
          .registerViewFactory(viewType, NativeAdmobBannerViewFactory(registrar.messenger()))
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    val method = CallMethod.valueOf(call.method)
    when (method) {
      CallMethod.initialize -> {
        initialize(call)
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }

  private fun initialize(call: MethodCall) {
    val appId = call.argument<String>("appId")
    MobileAds.initialize(context, appId)
  }
}
