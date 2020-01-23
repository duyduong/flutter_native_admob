//
//  NativeAdmobBannerViewHoder.swift
//  flutter_native_admob
//
//  Created by Dao Duy Duong on 1/22/20.
//

import UIKit
import GoogleMobileAds

enum BannerStyle: String {
    case dark, light
}

// MARK: - Native ad holder view

class NativeAdmobBannerViewHoder: UIView {
    
    var isLoading = true {
        didSet { updateIsLoading() }
    }
    
    var style: BannerStyle = .dark {
        didSet { updateStyle() }
    }
    
    var showMedia: Bool = true {
        didSet { updateShowMedia() }
    }
    
    var contentPadding: UIEdgeInsets = .zero {
        didSet { updateContentPadding() }
    }
    
    let indicatorView = UIActivityIndicatorView(style: .whiteLarge)
    let nativeAdView = UnifiedNativeAdView()
    
    var paddingConstraints: [NSLayoutConstraint] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        addSubview(indicatorView)
        indicatorView.autoCenterInSuperview()
        
        addSubview(nativeAdView)
        
        updateIsLoading()
        updateStyle()
        updateShowMedia()
        updateContentPadding()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateIsLoading()
        updateStyle()
        updateShowMedia()
        updateContentPadding()
    }
    
    func setNativeAd(_ nativeAd: GADUnifiedNativeAd) {
        nativeAdView.setNativeAd(nativeAd)
        
        isLoading = false
    }
}

// MARK: - Properties update

extension NativeAdmobBannerViewHoder {
    
    func updateIsLoading() {
        if isLoading {
            nativeAdView.isHidden = true
            indicatorView.isHidden = false
            indicatorView.startAnimating()
        } else {
            nativeAdView.isHidden = false
            indicatorView.isHidden = true
            indicatorView.stopAnimating()
        }
    }
    
    func updateStyle() {
        let primaryColor: UIColor = style == .dark ? .white : .black
        
        backgroundColor = style == .dark ? .black : .white
        indicatorView.color = primaryColor
        nativeAdView.adHeadLineLbl.textColor = primaryColor
        nativeAdView.adAdvertiserLbl.textColor = primaryColor
        nativeAdView.adBodyLbl.textColor = style == .dark ? .fromHex("#d3d3d3") : .gray
        nativeAdView.adStoreLbl.textColor = primaryColor
        nativeAdView.adPriceLbl.textColor = primaryColor
    }
    
    func updateShowMedia() {
        nativeAdView.adMediaView.isHidden = !showMedia
    }
    
    func updateContentPadding() {
        paddingConstraints.forEach { $0.autoRemove() }
        paddingConstraints = []
        
        paddingConstraints.append(contentsOf: nativeAdView.autoPinEdgesToSuperviewEdges(with: contentPadding))
    }
}

// MARK: - Native ad view

class UnifiedNativeAdView: GADUnifiedNativeAdView {
    
    let adLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = .fromHex("FFCC66")
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.text = "Ad"
        view.addSubview(label)
        label.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 1, left: 3, bottom: 1, right: 3))
        
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
        button.contentEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        return button
    }()
    
    var starIcon: StarIcon {
        let icon = StarIcon()
        icon.autoSetDimensions(to: CGSize(width: 15, height: 15))
        return icon
    }
    
    var paddingConstraints: [NSLayoutConstraint] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
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
        
        let actionLayout = StackLayout().spacing(5).children([
            UIView(),
            adPriceLbl,
            adStoreLbl,
            callToActionBtn
        ])
        
        adMediaView.autoSetDimension(.height, toSize: 100, relation: .greaterThanOrEqual)
        
        let mainLayout = StackLayout()
            .direction(.vertical)
            .spacing(5)
            .children([
                StackLayout().children([
                    adLabelView,
                    UIView()
                ]),
                adMediaView,
                infoLayout,
                adBodyLbl,
                actionLayout
            ])
        addSubview(mainLayout)
        mainLayout.autoPinEdgesToSuperviewEdges()
    }
    
    func setNativeAd(_ nativeAd: GADUnifiedNativeAd) {
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
        adBodyLbl.isHidden = nativeAd.body == nil

        callToActionBtn.setTitle(nativeAd.callToAction, for: .normal)
        callToActionBtn.isHidden = nativeAd.callToAction == nil

        adIconView.image = nativeAd.icon?.image
        adIconView.isHidden = nativeAd.icon == nil

        adRatingView.arrangedSubviews.forEach { view in
            adRatingView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        let numOfStars = Int(truncating: nativeAd.starRating ?? 0)
        for _ in 0..<numOfStars {
            adRatingView.children([starIcon])
        }
        adRatingView.isHidden = nativeAd.starRating == nil

        adStoreLbl.text = nativeAd.store
        adStoreLbl.isHidden = nativeAd.store == nil

        adPriceLbl.text = nativeAd.price
        adPriceLbl.isHidden = nativeAd.price == nil

        adAdvertiserLbl.text = nativeAd.advertiser
        adAdvertiserLbl.isHidden = nativeAd.advertiser == nil

        // In order for the SDK to process touch events properly, user interaction
        // should be disabled.
        callToActionBtn.isUserInteractionEnabled = false
    }
}
