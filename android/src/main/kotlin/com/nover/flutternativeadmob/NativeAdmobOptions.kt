package com.nover.flutternativeadmob

import android.graphics.Color

data class NativeTextStyle(
    var fontSize: Float,
    var color: Int,
    var backgroundColor: Int? = null
) {
  fun update(data: HashMap<*, *>) {
    (data["fontSize"] as? Float)?.let {
      fontSize = it
    }

    (data["color"] as? String)?.let {
      color = Color.parseColor(it)
    }

    (data["backgroundColor"] as? String)?.let {
      backgroundColor = Color.parseColor(it)
    }
  }
}

data class NativeAdmobOptions(
    var showMediaContent: Boolean = true,
    var ratingColor: Int = Color.YELLOW,
    val adLabelOptions: NativeTextStyle = NativeTextStyle(12f, Color.WHITE, Color.parseColor("#FFCC66")),
    val headlineTextOptions: NativeTextStyle = NativeTextStyle(16f, Color.BLACK),
    val advertiserTextOptions: NativeTextStyle = NativeTextStyle(14f, Color.BLACK),
    val bodyTextOptions: NativeTextStyle = NativeTextStyle(12f, Color.GRAY),
    val storeTextOptions: NativeTextStyle = NativeTextStyle(12f, Color.BLACK),
    val priceTextOptions: NativeTextStyle = NativeTextStyle(12f, Color.BLACK),
    val callToActionOptions: NativeTextStyle = NativeTextStyle(15f, Color.WHITE, Color.parseColor("#4CBE99"))
) {
  companion object {

    fun parse(data: HashMap<*, *>): NativeAdmobOptions {
      val bannerOptions = NativeAdmobOptions()

      (data["ratingColor"] as? String)?.let {
        bannerOptions.ratingColor = Color.parseColor(it)
      }

      (data["adLabelOptions"] as? HashMap<*, *>)?.let {
        bannerOptions.adLabelOptions.update(it)
      }

      (data["headlineTextOptions"] as? HashMap<*, *>)?.let {
        bannerOptions.headlineTextOptions.update(it)
      }

      (data["advertiserTextOptions"] as? HashMap<*, *>)?.let {
        bannerOptions.advertiserTextOptions.update(it)
      }

      (data["bodyTextOptions"] as? HashMap<*, *>)?.let {
        bannerOptions.bodyTextOptions.update(it)
      }

      (data["storeTextOptions"] as? HashMap<*, *>)?.let {
        bannerOptions.storeTextOptions.update(it)
      }

      (data["priceTextOptions"] as? HashMap<*, *>)?.let {
        bannerOptions.priceTextOptions.update(it)
      }

      (data["callToActionOptions"] as? HashMap<*, *>)?.let {
        bannerOptions.callToActionOptions.update(it)
      }

      return bannerOptions
    }
  }
}