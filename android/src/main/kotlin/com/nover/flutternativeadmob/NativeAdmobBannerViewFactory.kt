package com.nover.flutternativeadmob

import android.content.Context
import android.content.res.Resources
import android.graphics.Color
import android.graphics.PorterDuff
import android.graphics.drawable.Drawable
import android.graphics.drawable.GradientDrawable
import android.util.AttributeSet
import android.util.Log
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

data class TextOptions(
        var fontSize: Float,
        var color: Int,
        var backgroundColor: Int? = null
) {
  fun update(data: HashMap<*,*>) {
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

data class BannerOptions(
        var backgroundColor: Int = Color.WHITE,
        var indicatorColor: Int = Color.BLACK,
        var ratingColor: Int = Color.YELLOW,
        val adLabelOptions: TextOptions = TextOptions(12f, Color.WHITE, Color.parseColor("#FFCC66")),
        val headlineTextOptions: TextOptions = TextOptions(16f, Color.BLACK),
        val advertiserTextOptions: TextOptions = TextOptions(14f, Color.BLACK),
        val bodyTextOptions: TextOptions = TextOptions(12f, Color.GRAY),
        val storeTextOptions: TextOptions = TextOptions(12f, Color.BLACK),
        val priceTextOptions: TextOptions = TextOptions(12f, Color.BLACK),
        val callToActionOptions: TextOptions = TextOptions(15f, Color.WHITE, Color.parseColor("#4CBE99"))
) {
  companion object {

    fun parse(data: HashMap<*,*>): BannerOptions {
      val bannerOptions = BannerOptions()

      (data["backgroundColor"] as? String)?.let {
        bannerOptions.backgroundColor = Color.parseColor(it)
      }

      (data["indicatorColor"] as? String)?.let {
        bannerOptions.indicatorColor = Color.parseColor(it)
      }

      (data["ratingColor"] as? String)?.let {
        bannerOptions.ratingColor = Color.parseColor(it)
      }

      (data["adLabelOptions"] as? HashMap<*,*>)?.let {
        bannerOptions.adLabelOptions.update(it)
      }

      (data["headlineTextOptions"] as? HashMap<*,*>)?.let {
        bannerOptions.headlineTextOptions.update(it)
      }

      (data["advertiserTextOptions"] as? HashMap<*,*>)?.let {
        bannerOptions.advertiserTextOptions.update(it)
      }

      (data["bodyTextOptions"] as? HashMap<*,*>)?.let {
        bannerOptions.bodyTextOptions.update(it)
      }

      (data["storeTextOptions"] as? HashMap<*,*>)?.let {
        bannerOptions.storeTextOptions.update(it)
      }

      (data["priceTextOptions"] as? HashMap<*,*>)?.let {
        bannerOptions.priceTextOptions.update(it)
      }

      (data["callToActionOptions"] as? HashMap<*,*>)?.let {
        bannerOptions.callToActionOptions.update(it)
      }

      return bannerOptions
    }
  }
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

    // set view options
    view.options = (map["options"] as? HashMap<*,*>)?.let {
      BannerOptions.parse(it)
    } ?: BannerOptions()

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
    when (CallMethod.valueOf(call.method)) {
      CallMethod.setOptions -> {
        view.options = (call.arguments() as? HashMap<*,*>)?.let {
          BannerOptions.parse(it)
        } ?: BannerOptions()
      }
    }
  }
}

class NativeAdmobBannerViewHoder @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null, defStyleAttr: Int = 0
) : RelativeLayout(context, attrs, defStyleAttr) {

  var options = BannerOptions()
    set(value) {
      field = value
      updateOptions()
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

  private val loadingIndicator: ProgressBar

  private val ratingBar: RatingBar

  private val adMedia: MediaView

  private val adHeadline: TextView
  private val adAdvertiser: TextView
  private val adBody: TextView
  private val adPrice: TextView
  private val adStore: TextView
  private val adAttribution: TextView
  private val callToAction: Button

  init {
    val inflater = LayoutInflater.from(context)
    inflater.inflate(R.layout.native_admob_banner_view, this, true)

    // Show indicator
    loadingIndicator = findViewById<ProgressBar>(R.id.loading_indicator)
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

    ratingBar = adView.findViewById(R.id.ad_stars)

    adAttribution.background = Color.parseColor("#FFCC66").toRoundedColor(3f)
    callToAction = adView.findViewById(R.id.ad_call_to_action)

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
    adView.callToActionView = callToAction
    adView.iconView = adView.findViewById(R.id.ad_icon)
    adView.priceView = adPrice
    adView.starRatingView = ratingBar
    adView.storeView = adStore
    adView.advertiserView = adAdvertiser
  }

  fun populateNativeAdView(nativeAd: UnifiedNativeAd) {
    // hide indicator
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

  private fun updateOptions() {
    setBackgroundColor(options.backgroundColor)

    loadingIndicator.indeterminateDrawable
            .setColorFilter(options.indicatorColor, PorterDuff.Mode.SRC_IN)
    ratingBar.progressDrawable
            .setColorFilter(options.ratingColor, PorterDuff.Mode.SRC_ATOP)

    options.adLabelOptions.backgroundColor?.let {
      adAttribution.background = it.toRoundedColor(3f)
    }
    adAttribution.setTextColor(options.adLabelOptions.color)

    adHeadline.setTextColor(options.headlineTextOptions.color)
    adHeadline.textSize = options.headlineTextOptions.fontSize

    adAdvertiser.setTextColor(options.advertiserTextOptions.color)
    adAdvertiser.textSize = options.advertiserTextOptions.fontSize

    adBody.setTextColor(options.bodyTextOptions.color)
    adBody.textSize = options.bodyTextOptions.fontSize

    adStore.setTextColor(options.storeTextOptions.color)
    adStore.textSize = options.storeTextOptions.fontSize

    adPrice.setTextColor(options.priceTextOptions.color)
    adPrice.textSize = options.priceTextOptions.fontSize

    callToAction.setTextColor(options.callToActionOptions.color)
    callToAction.textSize = options.callToActionOptions.fontSize
    options.callToActionOptions.backgroundColor?.let {
      callToAction.setBackgroundColor(it)
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




