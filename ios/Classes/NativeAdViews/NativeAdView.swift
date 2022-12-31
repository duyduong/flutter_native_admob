//
//  NativeAdView.swift
//  flutter_native_admob
//
//  Created by Dao Duy Duong on 3/8/20.
//

import UIKit
import GoogleMobileAds

enum NativeAdmobType: String {
    case banner, full
}

class NativeAdView: GADNativeAdView {
    
    let adLabelLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.text = "Ad"
        label.numberOfLines = 1
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
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    let adStoreLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textAlignment = .right
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
    
    let type: NativeAdmobType
    
    init(frame: CGRect, type: NativeAdmobType) {
        self.type = type
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("No support for interface builder")
    }
    
    func setNativeAd(_ nativeAd: GADNativeAd?) {
        guard let nativeAd = nativeAd else { return }
        self.nativeAd = nativeAd
        
        // Set the mediaContent on the GADMediaView to populate it with available
        // video/image asset.
        adMediaView.mediaContent = nativeAd.mediaContent
        
        // Populate the native ad view with the native ad assets.
        // The headline is guaranteed to be present in every native ad.
        adHeadLineLbl.text = nativeAd.headline
        
        adAdvertiserLbl.text = nativeAd.advertiser
        if nativeAd.advertiser.isNilOrEmpty {
            adAdvertiserLbl.isHidden = true
        }
        
        // These assets are not guaranteed to be present. Check that they are before
        // showing or hiding them.
        adBodyLbl.text = nativeAd.body
        if nativeAd.body.isNilOrEmpty {
            adBodyLbl.isHidden = true
        }
        
        callToActionBtn.setTitle(nativeAd.callToAction, for: .normal)
        if nativeAd.callToAction.isNilOrEmpty {
            callToActionBtn.isHidden = true
        }
        
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
        if nativeAd.store.isNilOrEmpty {
            adStoreLbl.isHidden = true
        }
        
        adPriceLbl.text = nativeAd.price
        if nativeAd.price.isNilOrEmpty {
            adPriceLbl.isHidden = true
        }
        
        layoutIfNeeded()
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
        
        switch type {
        case .full: setupFullLayout()
        case .banner: setupBannerLayout()
        }
    }
    
    func setupFullLayout() {
        adBodyLbl.numberOfLines = 2
        
        let infoLayout = StackLayout().spacing(5).children([
            adIconView,
            StackLayout().direction(.vertical).children([
                adHeadLineLbl,
                StackLayout().children([
                    adAdvertiserLbl,
                    adRatingView,
                    UIView()
                ]),
            ]),
        ])
        
        callToActionBtn.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let actionLayout = StackLayout()
            .spacing(5)
            .children([
                UIView(),
                adPriceLbl,
                adStoreLbl,
                callToActionBtn
            ])
        
        adBodyLbl.autoSetDimension(.height, toSize: 20, relation: .greaterThanOrEqual)
        adLabelLbl.autoSetDimension(.height, toSize: 15, relation: .greaterThanOrEqual)
        
        addSubview(adLabelView)
        adLabelView.autoPinEdge(toSuperviewEdge: .top)
        adLabelView.autoPinEdge(toSuperviewEdge: .leading)
        
        let contentView = UIView()
        addSubview(contentView)
        contentView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        contentView.autoPinEdge(.top, to: .bottom, of: adLabelView, withOffset: 5)
        
        let layout = StackLayout()
            .direction(.vertical)
            .spacing(5)
            .children([
                adMediaView,
                infoLayout,
                adBodyLbl,
                actionLayout
            ])
        layout.isUserInteractionEnabled = false
        contentView.addSubview(layout)
        layout.autoAlignAxis(toSuperviewAxis: .horizontal)
        layout.autoPinEdge(toSuperviewEdge: .leading)
        layout.autoPinEdge(toSuperviewEdge: .trailing)
        layout.autoPinEdge(toSuperviewEdge: .top, withInset: 0, relation: .greaterThanOrEqual)
        layout.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0, relation: .greaterThanOrEqual)
    }
    
    func setupBannerLayout() {
        adBodyLbl.numberOfLines = 2
        
        callToActionBtn.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        adLabelLbl.autoSetDimension(.height, toSize: 15, relation: .greaterThanOrEqual)
        
        addSubview(adLabelView)
        adLabelView.autoPinEdge(toSuperviewEdge: .top)
        adLabelView.autoPinEdge(toSuperviewEdge: .leading)
        
        let contentView = UIView()
        addSubview(contentView)
        contentView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        contentView.autoPinEdge(.top, to: .bottom, of: adLabelView, withOffset: 5)
        
        let layout = StackLayout().spacing(5).children([
            adIconView,
            StackLayout().direction(.vertical).children([
                adHeadLineLbl,
                adBodyLbl,
                StackLayout().children([
                    adAdvertiserLbl,
                    adRatingView,
                    UIView()
                ]),
            ]),
            callToActionBtn
        ])
        layout.isUserInteractionEnabled = false
        contentView.addSubview(layout)
        layout.autoAlignAxis(toSuperviewAxis: .horizontal)
        layout.autoPinEdge(toSuperviewEdge: .leading)
        layout.autoPinEdge(toSuperviewEdge: .trailing)
        layout.autoPinEdge(toSuperviewEdge: .top, withInset: 0, relation: .greaterThanOrEqual)
        layout.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0, relation: .greaterThanOrEqual)
    }
    
    func updateOptions() {
        adMediaView.isHidden = !options.showMediaContent

        backgroundColor = options.backgroundColor

        adLabelLbl.textColor = options.adLabelTextStyle.color
        adLabelLbl.font = UIFont.systemFont(ofSize: options.adLabelTextStyle.fontSize)
        adLabelView.backgroundColor = options.adLabelTextStyle.backgroundColor ?? .fromHex("FFCC66")
        adLabelView.isHidden = !options.adLabelTextStyle.isVisible
        
        adHeadLineLbl.textColor = options.headlineTextStyle.color
        adHeadLineLbl.font = UIFont.systemFont(ofSize: options.headlineTextStyle.fontSize)
        adHeadLineLbl.isHidden = !options.headlineTextStyle.isVisible
        
        adAdvertiserLbl.textColor = options.advertiserTextStyle.color
        adAdvertiserLbl.font = UIFont.systemFont(ofSize: options.advertiserTextStyle.fontSize)
        adAdvertiserLbl.isHidden = !options.advertiserTextStyle.isVisible
        
        adBodyLbl.textColor = options.bodyTextStyle.color
        adBodyLbl.font = UIFont.systemFont(ofSize: options.bodyTextStyle.fontSize)
        adBodyLbl.isHidden = !options.bodyTextStyle.isVisible
        
        adStoreLbl.textColor = options.storeTextStyle.color
        adStoreLbl.font = UIFont.systemFont(ofSize: options.storeTextStyle.fontSize)
        adStoreLbl.isHidden = !options.storeTextStyle.isVisible
        
        adPriceLbl.textColor = options.priceTextStyle.color
        adPriceLbl.font = UIFont.systemFont(ofSize: options.priceTextStyle.fontSize)
        adPriceLbl.isHidden = !options.priceTextStyle.isVisible
        
        callToActionBtn.setTitleColor(options.callToActionStyle.color, for: .normal)
        callToActionBtn.titleLabel?.font = UIFont.systemFont(ofSize: options.callToActionStyle.fontSize)
        if let bgColor = options.callToActionStyle.backgroundColor {
            callToActionBtn.setBackgroundImage(.from(color: bgColor), for: .normal)
        }
        callToActionBtn.isHidden = !options.callToActionStyle.isVisible
        
        starIcon.color = options.ratingColor
    }
}
