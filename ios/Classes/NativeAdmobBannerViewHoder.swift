//
//  NativeAdmobBannerViewHoder.swift
//  flutter_native_admob
//
//  Created by Dao Duy Duong on 1/22/20.
//

import UIKit
import GoogleMobileAds

struct BannerOptions {
    
    struct TextOptions {
        var fontSize: CGFloat
        var color: UIColor
        var backgroundColor: UIColor? = nil
        
        mutating func update(JSON: [String: Any]) {
            if let fontSize = JSON["fontSize"] as? CGFloat {
                self.fontSize = fontSize
            }
            
            if let colorString = JSON["color"] as? String {
                self.color = .fromHex(colorString)
            }
            
            if let backgroundColorString = JSON["backgroundColor"] as? String {
                self.backgroundColor = .fromHex(backgroundColorString)
            }
        }
    }
    
    var backgroundColor: UIColor = .white
    var indicatorColor: UIColor = .black
    var ratingColor: UIColor = .yellow
    
    var adLabelOptions = TextOptions(fontSize: 12, color: .white, backgroundColor: .fromHex("FFCC66"))
    var headlineTextOptions = TextOptions(fontSize: 16, color: .black)
    var advertiserTextOptions = TextOptions(fontSize: 14, color: .black)
    var bodyTextOptions = TextOptions(fontSize: 12, color: .gray)
    var storeTextOptions = TextOptions(fontSize: 12, color: .black)
    var priceTextOptions = TextOptions(fontSize: 12, color: .black)
    var callToActionOptions = TextOptions(fontSize: 15, color: .white, backgroundColor: .fromHex("#4CBE99"))
}

// MARK: - Native ad holder view

class NativeAdmobBannerViewHoder: UIView {
    
    var isLoading = true {
        didSet { updateIsLoading() }
    }
    
    var bannerOptions = BannerOptions() {
        didSet { updateOptions() }
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
        updateOptions()
        updateShowMedia()
        updateContentPadding()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateIsLoading()
        updateOptions()
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
    
    func updateOptions() {
        backgroundColor = bannerOptions.backgroundColor
        indicatorView.color = bannerOptions.indicatorColor
        nativeAdView.updateOptions(bannerOptions)
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
    
    var paddingConstraints: [NSLayoutConstraint] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
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
    
    fileprivate func setNativeAd(_ nativeAd: GADUnifiedNativeAd) {
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
    
    fileprivate func updateOptions(_ bannerOptions: BannerOptions) {
        adLabelLbl.textColor = bannerOptions.adLabelOptions.color
        adLabelLbl.font = UIFont.systemFont(ofSize: bannerOptions.adLabelOptions.fontSize)
        adLabelView.backgroundColor = bannerOptions.adLabelOptions.backgroundColor ?? .fromHex("FFCC66")
        
        adHeadLineLbl.textColor = bannerOptions.headlineTextOptions.color
        adHeadLineLbl.font = UIFont.systemFont(ofSize: bannerOptions.headlineTextOptions.fontSize)
        
        adAdvertiserLbl.textColor = bannerOptions.advertiserTextOptions.color
        adAdvertiserLbl.font = UIFont.systemFont(ofSize: bannerOptions.advertiserTextOptions.fontSize)
        
        adBodyLbl.textColor = bannerOptions.bodyTextOptions.color
        adBodyLbl.font = UIFont.systemFont(ofSize: bannerOptions.bodyTextOptions.fontSize)
        
        adStoreLbl.textColor = bannerOptions.storeTextOptions.color
        adStoreLbl.font = UIFont.systemFont(ofSize: bannerOptions.storeTextOptions.fontSize)
        
        adPriceLbl.textColor = bannerOptions.priceTextOptions.color
        adPriceLbl.font = UIFont.systemFont(ofSize: bannerOptions.priceTextOptions.fontSize)
        
        callToActionBtn.setTitleColor(bannerOptions.callToActionOptions.color, for: .normal)
        callToActionBtn.titleLabel?.font = UIFont.systemFont(ofSize: bannerOptions.callToActionOptions.fontSize)
        if let bgColor = bannerOptions.callToActionOptions.backgroundColor {
            callToActionBtn.setBackgroundImage(.from(color: bgColor), for: .normal)
        }
        
        starIcon.color = bannerOptions.ratingColor
    }
}
