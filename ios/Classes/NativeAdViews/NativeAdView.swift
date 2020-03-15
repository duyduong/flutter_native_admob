//
//  NativeAdView.swift
//  flutter_native_admob
//
//  Created by Dao Duy Duong on 3/8/20.
//

import UIKit
import GoogleMobileAds

class NativeAdView: GADUnifiedNativeAdView {
    
    let adLabelLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.text = "Ad"
        return label
    }()
    
    lazy var adLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = .fromHex("FFCC66")
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        view.addSubview(adLabelLbl)
        adLabelLbl.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 1, left: 3, bottom: 1, right: 3))
        
        return view
    }()
    
    let adMediaView = GADMediaView()
    
    let adIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.autoSetDimensions(to: CGSize(width: 40, height: 40))
        return imageView
    }()
    
    let adHeadLineLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()
    
    let adAdvertiserLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()
    
    let adRatingView = StackLayout().spacing(2)
    
    let adBodyLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    
    let adPriceLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    
    let adStoreLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    
    let callToActionBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(.from(color: .fromHex("#4CBE99")), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        button.autoSetDimension(.height, toSize: 30)
        return button
    }()
    
    var starIcon: StarIcon {
        let icon = StarIcon()
        icon.autoSetDimensions(to: CGSize(width: 15, height: 15))
        return icon
    }
    
    var options = NativeAdmobOptions() {
        didSet { updateOptions() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setNativeAd(_ nativeAd: GADUnifiedNativeAd?) {
        guard let nativeAd = nativeAd else { return }
        self.nativeAd = nativeAd
        
        // Set the mediaContent on the GADMediaView to populate it with available
        // video/image asset.
        adMediaView.mediaContent = nativeAd.mediaContent
        
        // Populate the native ad view with the native ad assets.
        // The headline is guaranteed to be present in every native ad.
        adHeadLineLbl.text = nativeAd.headline
        
        // These assets are not guaranteed to be present. Check that they are before
        // showing or hiding them.
        adBodyLbl.text = nativeAd.body
        adBodyLbl.isHidden = nativeAd.body.isNilOrEmpty
        
        callToActionBtn.setTitle(nativeAd.callToAction, for: .normal)
        callToActionBtn.isHidden = nativeAd.callToAction.isNilOrEmpty
        
        adIconView.image = nativeAd.icon?.image
        adIconView.isHidden = nativeAd.icon == nil
        
        adRatingView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
        let numOfStars = Int(truncating: nativeAd.starRating ?? 0)
        adRatingView.children(Array(0..<numOfStars).map { _ in
            let icon = self.starIcon
            icon.color = options.ratingColor
            return icon
        })
        adRatingView.isHidden = nativeAd.starRating == nil
        
        adStoreLbl.text = nativeAd.store
        adStoreLbl.isHidden = nativeAd.store.isNilOrEmpty
        
        adPriceLbl.text = nativeAd.price
        adPriceLbl.isHidden = nativeAd.price.isNilOrEmpty
        
        adAdvertiserLbl.text = nativeAd.advertiser
        adAdvertiserLbl.isHidden = nativeAd.advertiser.isNilOrEmpty
        
        // In order for the SDK to process touch events properly, user interaction
        // should be disabled.
        callToActionBtn.isUserInteractionEnabled = false
    }
}

private extension NativeAdView {
    
    func setupView() {
        self.mediaView = adMediaView
        self.headlineView = adHeadLineLbl
        self.callToActionView = callToActionBtn
        self.iconView = adIconView
        self.bodyView = adBodyLbl
        self.storeView = adStoreLbl
        self.priceView = adPriceLbl
        self.starRatingView = adRatingView
        self.advertiserView = adAdvertiserLbl
        
        let infoLayout = StackLayout().spacing(5).children([
            adIconView,
            StackLayout().direction(.vertical).children([
                adHeadLineLbl,
                StackLayout().children([
                    adAdvertiserLbl,
                    adRatingView,
                    UIView()
                ])
            ]),
        ])
        
        let actionLayout = StackLayout()
            .alignItems(.center)
            .spacing(5)
            .children([
                UIView(),
                StackViewItem(view: adPriceLbl, attribute: .fill(insets: .zero)),
                StackViewItem(view: adStoreLbl, attribute: .fill(insets: .zero)),
                callToActionBtn
            ])
        
        let holderView = UIView()
        holderView.addSubview(adLabelView)
        adLabelView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .trailing)
        
        let mainLayout = StackLayout()
            .direction(.vertical)
            .spacing(5)
            .children([
                holderView,
                adMediaView,
                infoLayout,
                StackViewItem(view: adBodyLbl, attribute: .fill(insets: .zero)),
                actionLayout
            ])
        addSubview(mainLayout)
        mainLayout.autoPinEdgesToSuperviewEdges()
    }
    
    func updateOptions() {
        adMediaView.isHidden = !options.showMediaContent
        
        adLabelLbl.textColor = options.adLabelTextStyle.color
        adLabelLbl.font = UIFont.systemFont(ofSize: options.adLabelTextStyle.fontSize)
        adLabelView.backgroundColor = options.adLabelTextStyle.backgroundColor ?? .fromHex("FFCC66")
        
        adHeadLineLbl.textColor = options.headlineTextStyle.color
        adHeadLineLbl.font = UIFont.systemFont(ofSize: options.headlineTextStyle.fontSize)
        
        adAdvertiserLbl.textColor = options.advertiserTextStyle.color
        adAdvertiserLbl.font = UIFont.systemFont(ofSize: options.advertiserTextStyle.fontSize)
        
        adBodyLbl.textColor = options.bodyTextStyle.color
        adBodyLbl.font = UIFont.systemFont(ofSize: options.bodyTextStyle.fontSize)
        
        adStoreLbl.textColor = options.storeTextStyle.color
        adStoreLbl.font = UIFont.systemFont(ofSize: options.storeTextStyle.fontSize)
        
        adPriceLbl.textColor = options.priceTextStyle.color
        adPriceLbl.font = UIFont.systemFont(ofSize: options.priceTextStyle.fontSize)
        
        callToActionBtn.setTitleColor(options.callToActionStyle.color, for: .normal)
        callToActionBtn.titleLabel?.font = UIFont.systemFont(ofSize: options.callToActionStyle.fontSize)
        if let bgColor = options.callToActionStyle.backgroundColor {
            callToActionBtn.setBackgroundImage(.from(color: bgColor), for: .normal)
        }
        
        starIcon.color = options.ratingColor
    }
}
