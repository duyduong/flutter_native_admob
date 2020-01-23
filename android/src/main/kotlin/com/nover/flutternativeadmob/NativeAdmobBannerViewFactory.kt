package com.nover.flutternativeadmob

import android.content.Context
import android.content.res.Resources
import android.graphics.Color
import android.graphics.drawable.Drawable
import android.graphics.drawable.GradientDrawable
import android.util.AttributeSet
import android.view.LayoutInflater
import android.view.View
import android.widget.*
import com.google.android.gms.ads.AdListener
import com.google.android.gms.ads.AdLoader
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.formats.MediaView
import com.google.android.gms.ads.formats.UnifiedNativeAd
import com.google.android.gms.ads.formats.UnifiedNativeAdView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

enum class BannerStyle {
  dark, light
}

class NativeAdmobBannerViewFactory(
    private val messenger: BinaryMessenger
): PlatformViewFactory(StandardMessageCodec.INSTANCE) {

  override fun create(context: Context, id: Int, params: Any?): PlatformView {
    return NativeAdmobBannerView(context, messenger, id, params)
  }
}

class NativeAdmobBannerView(
    context: Context,
    messenger: BinaryMessenger,
    id: Int,
    params: Any?
) : PlatformView, MethodChannel.MethodCallHandler {

  private val view = NativeAdmobBannerViewHoder(context)
  private val methodChannel: MethodChannel = MethodChannel(messenger, "${FlutterNativeAdmobPlugin.viewType}_$id")

  private val adLoader: AdLoader

  init {
    methodChannel.setMethodCallHandler(this)

    val map = params as HashMap<*,*>

    // set view style
    val style = BannerStyle.valueOf(map["style"] as String)
    view.style = style

    // set media visibility
    val showMedia = map["showMedia"] as Boolean
    view.showMedia = showMedia

    // set content padding
    val paddingString = map["contentPadding"] as String
    view.contentPadding = Padding.parse(paddingString)

    // load ad
    val adUnitID = map["adUnitID"] as String
    val builder = AdLoader.Builder(context, adUnitID)
    adLoader = builder.forUnifiedNativeAd {
      view.populateNativeAdView(it)
    }.withAdListener(object: AdListener() {
      override fun onAdFailedToLoad(errorCode: Int) {
        println("onAdFailedToLoad errorCode = $errorCode")
      }
    }).build()

    adLoader.loadAd(AdRequest.Builder().build())
  }

  override fun getView(): View = view

  override fun dispose() { }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    val method = CallMethod.valueOf(call.method)
    when (method) {
      CallMethod.setStyle -> {
        val style = BannerStyle.valueOf(call.argument("style")!!)
        view.style = style
      }
    }
  }
}

class NativeAdmobBannerViewHoder @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null, defStyleAttr: Int = 0
) : RelativeLayout(context, attrs, defStyleAttr) {

  var style = BannerStyle.dark
    set(value) {
      field = value
      updateStyle()
    }

  var showMedia = true
    set(value) {
      field = value
      updateMediaView()
    }

  var contentPadding: Padding = Padding(0,0,0,0)
    set(value) {
      field = value
      updateContentPadding()
    }

  private val adContainer: LinearLayout
  private val adView: UnifiedNativeAdView

  private val adMedia: MediaView

  private val adHeadline: TextView
  private val adAdvertiser: TextView
  private val adBody: TextView
  private val adPrice: TextView
  private val adStore: TextView
  private val adAttribution: TextView

  init {
    val inflater = LayoutInflater.from(context)
    inflater.inflate(R.layout.native_admob_banner_view, this, true)

    // Show indicator
    val loadingIndicator = findViewById<ProgressBar>(R.id.loading_indicator)
    loadingIndicator.visibility = View.VISIBLE

    adContainer = findViewById(R.id.ad_container)
    adContainer.visibility = View.GONE

    adView = findViewById(R.id.ad_view)

    adMedia = adView.findViewById(R.id.ad_media)

    adHeadline = adView.findViewById(R.id.ad_headline)
    adAdvertiser = adView.findViewById(R.id.ad_advertiser)
    adBody = adView.findViewById(R.id.ad_body)
    adPrice = adView.findViewById(R.id.ad_price)
    adStore = adView.findViewById(R.id.ad_store)
    adAttribution = adView.findViewById(R.id.ad_attribution)

    adAttribution.background = Color.parseColor("#FFCC66").toRoundedColor(3f)

    updateStyle()
    updateMediaView()
    updateContentPadding()

    initialize()
  }

  private fun initialize() {
    // The MediaView will display a video asset if one is present in the ad, and the
    // first image asset otherwise.
    adView.mediaView = adMedia

    // Register the view used for each individual asset.
    adView.headlineView = adHeadline
    adView.bodyView = adBody
    adView.callToActionView = adView.findViewById(R.id.ad_call_to_action)
    adView.iconView = adView.findViewById(R.id.ad_icon)
    adView.priceView = adPrice
    adView.starRatingView = adView.findViewById(R.id.ad_stars)
    adView.storeView = adStore
    adView.advertiserView = adAdvertiser
  }

  fun populateNativeAdView(nativeAd: UnifiedNativeAd) {
    // hide indicator
    val loadingIndicator = findViewById<ProgressBar>(R.id.loading_indicator)
    loadingIndicator.visibility = View.GONE

    // show ad container
    adContainer.visibility = View.VISIBLE

    // Some assets are guaranteed to be in every UnifiedNativeAd.
    adHeadline.text = nativeAd.headline
    adBody.text = nativeAd.body
    (adView.callToActionView as Button).setText(nativeAd.callToAction)

    // These assets aren't guaranteed to be in every UnifiedNativeAd, so it's important to
    // check before trying to display them.
    val icon = nativeAd.icon

    if (icon == null) {
      adView.iconView.visibility = View.INVISIBLE
    } else {
      (adView.iconView as ImageView).setImageDrawable(icon.drawable)
      adView.iconView.visibility = View.VISIBLE
    }

    if (nativeAd.price == null) {
      adPrice.visibility = View.INVISIBLE
    } else {
      adPrice.visibility = View.VISIBLE
      adPrice.text = nativeAd.price
    }

    if (nativeAd.store == null) {
      adStore.visibility = View.INVISIBLE
    } else {
      adStore.visibility = View.VISIBLE
      adStore.text = nativeAd.store
    }

    if (nativeAd.starRating == null) {
      adView.starRatingView.visibility = View.INVISIBLE
    } else {
      (adView.starRatingView as RatingBar).rating = nativeAd.starRating!!.toFloat()
      adView.starRatingView.visibility = View.VISIBLE
    }

    if (nativeAd.advertiser == null) {
      adAdvertiser.visibility = View.INVISIBLE
    } else {
      adAdvertiser.visibility = View.VISIBLE
      adAdvertiser.text = nativeAd.advertiser
    }

    // Assign native ad object to the native view.
    adView.setNativeAd(nativeAd)
  }

  private fun updateStyle() {
    val bgColor: Int
    when (style) {
      BannerStyle.dark -> {
        setBackgroundColor(Color.BLACK)

        adHeadline.setTextColor(Color.WHITE)
        adAdvertiser.setTextColor(Color.WHITE)
        adBody.setTextColor(Color.LTGRAY)
        adStore.setTextColor(Color.WHITE)
        adPrice.setTextColor(Color.WHITE)
      }
      BannerStyle.light -> {
        setBackgroundColor(Color.WHITE)

        adHeadline.setTextColor(Color.BLACK)
        adAdvertiser.setTextColor(Color.BLACK)
        adBody.setTextColor(Color.GRAY)
        adStore.setTextColor(Color.BLACK)
        adPrice.setTextColor(Color.BLACK)
      }
    }
  }

  private fun updateMediaView() {
    adMedia.visibility = if (showMedia) View.VISIBLE else View.GONE
  }

  private fun updateContentPadding() {
    adContainer.setPadding(contentPadding.left, contentPadding.top, contentPadding.right, contentPadding.bottom)
  }
}

data class Padding(
    val left: Int,
    val top: Int,
    val right: Int,
    val bottom: Int
) {

  companion object {

    fun parse(paddingString: String): Padding {
      val parts = paddingString.split(",")
          .map { it.trim().toFloat().toInt() }

      val len = parts.count()

      val left: Int
      val top: Int
      val right: Int
      val bottom: Int

      if (len == 1) {
        val p = parts.first()
        left = p
        top = p
        right = p
        bottom = p
      } else if (len == 2) {
        val hp = parts.first()
        left = hp
        right = hp

        val vp = parts.last()
        top = vp
        bottom = vp
      } else if (len == 3) {
        left = parts[0]
        top = parts[1]
        right = parts[2]
        bottom = 0
      } else {
        left = parts[0]
        top = parts[1]
        right = parts[2]
        bottom = parts[3]
      }

      return Padding(left.dp(), top.dp(), right.dp(), bottom.dp())
    }
  }
}

fun Int.toRoundedColor(radius: Float): Drawable {
  val drawable = GradientDrawable()
  drawable.shape = GradientDrawable.RECTANGLE
  drawable.cornerRadius = radius * Resources.getSystem().displayMetrics.density
  drawable.setColor(this)
  return drawable
}

fun Int.dp(): Int {
  val density = Resources.getSystem().displayMetrics.density
  return (this * density).toInt()
}




