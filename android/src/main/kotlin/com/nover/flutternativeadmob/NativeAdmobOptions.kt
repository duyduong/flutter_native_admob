package com.nover.flutternativeadmob

import android.graphics.Color

class NativeTextStyle(
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

class NativeAdmobOptions(
    var showMediaContent: Boolean = true,
    var ratingColor: Int = Color.YELLOW,
    val adLabelTextStyle: NativeTextStyle = NativeTextStyle(12f, Color.WHITE, Color.parseColor("#FFCC66")),
    val headlineTextStyle: NativeTextStyle = NativeTextStyle(16f, Color.BLACK),
    val advertiserTextStyle: NativeTextStyle = NativeTextStyle(14f, Color.BLACK),
    val bodyTextStyle: NativeTextStyle = NativeTextStyle(12f, Color.GRAY),
    val storeTextStyle: NativeTextStyle = NativeTextStyle(12f, Color.BLACK),
    val priceTextStyle: NativeTextStyle = NativeTextStyle(12f, Color.BLACK),
    val callToActionStyle: NativeTextStyle = NativeTextStyle(15f, Color.WHITE, Color.parseColor("#4CBE99"))
) {
  companion object {

    fun parse(data: HashMap<*, *>): NativeAdmobOptions {
      val bannerOptions = NativeAdmobOptions()

      (data["showMediaContent"] as? Boolean)?.let {
        bannerOptions.showMediaContent = it
      }

      (data["ratingColor"] as? String)?.let {
        bannerOptions.ratingColor = Color.parseColor(it)
      }

      (data["adLabelTextStyle"] as? HashMap<*, *>)?.let {
        bannerOptions.adLabelTextStyle.update(it)
      }

      (data["headlineTextStyle"] as? HashMap<*, *>)?.let {
        bannerOptions.headlineTextStyle.update(it)
      }

      (data["advertiserTextStyle"] as? HashMap<*, *>)?.let {
        bannerOptions.advertiserTextStyle.update(it)
      }

      (data["bodyTextStyle"] as? HashMap<*, *>)?.let {
        bannerOptions.bodyTextStyle.update(it)
      }

      (data["storeTextStyle"] as? HashMap<*, *>)?.let {
        bannerOptions.storeTextStyle.update(it)
      }

      (data["priceTextStyle"] as? HashMap<*, *>)?.let {
        bannerOptions.priceTextStyle.update(it)
      }

      (data["callToActionStyle"] as? HashMap<*, *>)?.let {
        bannerOptions.callToActionStyle.update(it)
      }

      return bannerOptions
    }
  }
}