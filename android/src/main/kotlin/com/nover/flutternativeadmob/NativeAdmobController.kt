package com.nover.flutternativeadmob

import android.content.Context
import android.util.Log
import com.google.android.gms.ads.AdListener
import com.google.android.gms.ads.AdLoader
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.formats.UnifiedNativeAd
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class NativeAdmobController(
    val id: String,
    private val channel: MethodChannel,
    private val context: Context
) : MethodChannel.MethodCallHandler {

  enum class CallMethod {
    initAd, reloadAd
  }

  enum class LoadState {
    loading, loadError, loadCompleted
  }

  var nativeAdChanged: ((UnifiedNativeAd?) -> Unit)? = null
  var nativeAd: UnifiedNativeAd? = null
    set(value) {
      field = value
      invokeLoadCompleted()
    }

  private var adLoader: AdLoader? = null
  private var adUnitID: String? = null

  init {
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (CallMethod.valueOf(call.method)) {
      CallMethod.initAd -> {
        call.argument<String>("adUnitID")?.let {
          val isChanged = adUnitID != it
          adUnitID = it

          if (adLoader == null || isChanged) {
            val builder = AdLoader.Builder(context, it)
            adLoader = builder.forUnifiedNativeAd { nativeAd ->
              this.nativeAd = nativeAd
            }.withAdListener(object : AdListener() {
              override fun onAdFailedToLoad(errorCode: Int) {
                println("onAdFailedToLoad errorCode = $errorCode")
                channel.invokeMethod(LoadState.loadError.toString(), null)
              }
            }).build()
          }

          if (nativeAd == null || isChanged) loadAd() else invokeLoadCompleted()
        } ?: result.success(null)
      }

      CallMethod.reloadAd -> {
        call.argument<Boolean>("forceRefresh")?.let {
          if (it || nativeAd == null) loadAd() else invokeLoadCompleted()
        }
      }
    }
  }

  private fun loadAd() {
    channel.invokeMethod(LoadState.loading.toString(), null)
    adLoader?.loadAd(AdRequest.Builder().build())
  }

  private fun invokeLoadCompleted() {
    nativeAdChanged?.let { it(nativeAd) }
    channel.invokeMethod(LoadState.loadCompleted.toString(), null)
  }
}

object NativeAdmobControllerManager {
  private val controllers: ArrayList<NativeAdmobController> = arrayListOf()

  fun createController(id: String, binaryMessenger: BinaryMessenger, context: Context) {
    if (getController(id) == null) {
      val methodChannel = MethodChannel(binaryMessenger, id)
      val controller = NativeAdmobController(id, methodChannel, context)
      controllers.add(controller)
    }
  }

  fun getController(id: String): NativeAdmobController? {
    return controllers.firstOrNull { it.id == id }
  }

  fun removeController(id: String) {
    val index = controllers.indexOfFirst { it.id == id }
    if (index >= 0) controllers.removeAt(index)
  }
}