package com.nover.flutternativeadmob

import android.content.Context
import android.graphics.Color
import android.graphics.PorterDuff
import android.graphics.Typeface
import android.util.AttributeSet
import android.view.LayoutInflater
import android.view.View
import android.widget.*
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView

enum class NativeAdmobType {
  full, banner
}

class NativeAdView @JvmOverloads constructor(
    context: Context,
    type: NativeAdmobType,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0
) : LinearLayout(context, attrs, defStyleAttr) {

  var options = NativeAdmobOptions()
    set(value) {
      field = value
      updateOptions()
    }

  private val adView: NativeAdView

  private val ratingBar: RatingBar

  private var adMedia: com.google.android.gms.ads.nativead.MediaView?

  private val adHeadline: TextView
  private val adAdvertiser: TextView
  private val adBody: TextView?
  private val adPrice: TextView?
  private val adStore: TextView?
  private val adAttribution: TextView
  private val callToAction: Button

  init {
    val inflater = LayoutInflater.from(context)
    val layout = when (type) {
      NativeAdmobType.full -> R.layout.native_admob_full_view
      NativeAdmobType.banner -> R.layout.native_admob_banner_view
    }
    inflater.inflate(layout, this, true)

    setBackgroundColor(Color.TRANSPARENT)

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

  fun setNativeAd(nativeAd: NativeAd?) {
    if (nativeAd == null) return

    // Some assets are guaranteed to be in every UnifiedNativeAd.
    adMedia?.setMediaContent(nativeAd.mediaContent)
    adMedia?.setImageScaleType(ImageView.ScaleType.FIT_CENTER)

    adHeadline.text = nativeAd.headline
    adBody?.text = nativeAd.body
    (adView.callToActionView as Button).text = nativeAd.callToAction

    // These assets aren't guaranteed to be in every UnifiedNativeAd, so it's important to
    // check before trying to display them.
    val icon = nativeAd.icon

    if (icon == null) {
      adView.iconView?.visibility = View.GONE
    } else {
      (adView.iconView as ImageView).setImageDrawable(icon.drawable)
      adView.iconView?.visibility = View.VISIBLE
    }

    if (nativeAd.price == null) {
      adPrice?.visibility = View.INVISIBLE
    } else {
      adPrice?.visibility = View.VISIBLE
      adPrice?.text = nativeAd.price
    }

    if (nativeAd.store == null) {
      adStore?.visibility = View.INVISIBLE
    } else {
      adStore?.text = nativeAd.store
    }

    if (nativeAd.starRating == null) {
      adView.starRatingView?.visibility = View.INVISIBLE
    } else {
      (adView.starRatingView as RatingBar).rating = nativeAd.starRating!!.toFloat()
      adView.starRatingView?.visibility = View.VISIBLE
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
    adView.setBackgroundColor(options.backgroundColor)

    adMedia?.visibility = if (options.showMediaContent) View.VISIBLE else View.GONE

    ratingBar.progressDrawable
        .setColorFilter(options.ratingColor, PorterDuff.Mode.SRC_ATOP)

    options.adLabelTextStyle.backgroundColor?.let {
      adAttribution.background = it.toRoundedColor(3f)
    }
    adAttribution.textSize = options.adLabelTextStyle.fontSize
    adAttribution.setTextColor(options.adLabelTextStyle.color)
    adAdvertiser.visibility = options.adLabelTextStyle.visibility
    options.adLabelTextStyle.androidTypeface?.let { t ->
      adAttribution.typeface = Typeface.createFromAsset(
              context.assets, t
      )
    }

    adHeadline.setTextColor(options.headlineTextStyle.color)
    adHeadline.textSize = options.headlineTextStyle.fontSize
    adHeadline.visibility = options.headlineTextStyle.visibility
    options.headlineTextStyle.androidTypeface?.let { t ->
      adHeadline.typeface = Typeface.createFromAsset(
              context.assets, t
      )
    }

    adAdvertiser.setTextColor(options.advertiserTextStyle.color)
    adAdvertiser.textSize = options.advertiserTextStyle.fontSize
    adAdvertiser.visibility = options.advertiserTextStyle.visibility
    options.advertiserTextStyle.androidTypeface?.let { t ->
      adAdvertiser.typeface = Typeface.createFromAsset(
              context.assets, t
      )
    }


    adBody?.setTextColor(options.bodyTextStyle.color)
    adBody?.textSize = options.bodyTextStyle.fontSize
    adBody?.visibility = options.bodyTextStyle.visibility
    options.bodyTextStyle.androidTypeface?.let { t ->
      adBody?.typeface = Typeface.createFromAsset(
              context.assets, t
      )
    }

    adStore?.setTextColor(options.storeTextStyle.color)
    adStore?.textSize = options.storeTextStyle.fontSize
    adStore?.visibility = options.storeTextStyle.visibility
    options.storeTextStyle.androidTypeface?.let { t ->
      adStore?.typeface = Typeface.createFromAsset(
              context.assets, t
      )
    }

    adPrice?.setTextColor(options.priceTextStyle.color)
    adPrice?.textSize = options.priceTextStyle.fontSize
    adPrice?.visibility = options.priceTextStyle.visibility
    options.priceTextStyle.androidTypeface?.let { t ->
      adPrice?.typeface = Typeface.createFromAsset(
              context.assets, t
      )
    }

    callToAction.setTextColor(options.callToActionStyle.color)
    callToAction.textSize = options.callToActionStyle.fontSize
    options.callToActionStyle.backgroundColor?.let {
      callToAction.setBackgroundColor(it)
    }
    options.callToActionStyle.androidTypeface?.let { t ->
      callToAction.typeface = Typeface.createFromAsset(
              context.assets, t
      )
    }
  }
}