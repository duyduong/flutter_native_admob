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
        label.font = UIFont.systemFont(ofSize: 9)
        label.textColor = .fromHex("979797")
        label.text = "Sponsored"
        return label
    }()
    
    lazy var adLabelView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.layer.borderWidth = 0.5
        view.layer.opacity = 0.5
        view.layer.borderColor =  UIColor(hexString: "4a4a4a")?.cgColor
        view.addSubview(adLabelLbl)
        view.autoSetDimensions(to: CGSize(width: 78.5, height: 18))
        adLabelLbl.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 3))
        return view
    }()
    
    let adMediaView: GADMediaView = {
        let adMediaView = GADMediaView()
        adMediaView.backgroundColor = UIColor.black
        adMediaView.contentMode = .scaleAspectFill
        adMediaView.layer.cornerRadius = 5
        adMediaView.clipsToBounds = true
        return adMediaView
    }() 
    
    let adHeadLineLbl: UITextView = {
        let label = UITextView()
        label.textContainerInset = UIEdgeInsets.zero
        label.textContainer.lineFragmentPadding = 0
        label.backgroundColor = UIColor.clear
        label.isSelectable = false
        label.isEditable = false
        label.isScrollEnabled = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
        
    let adBodyLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    
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
        adMediaView.contentMode = .scaleAspectFill

        // Populate the native ad view with the native ad assets.
        // The headline is guaranteed to be present in every native ad.
        adHeadLineLbl.text = nativeAd.headline

        // These assets are not guaranteed to be present. Check that they are before
        // showing or hiding them.
        adBodyLbl.text = nativeAd.body
        adBodyLbl.isHidden = nativeAd.body == nil

        // In order for the SDK to process touch events properly, user interaction
        // should be disabled.
        // callToActionBtn.isUserInteractionEnabled = false
    }
}

private extension NativeAdView {
    
    func setupView() {
        self.mediaView = adMediaView
        self.headlineView = adHeadLineLbl
        self.bodyView = adBodyLbl
        
        let holderView = UIView()
        holderView.addSubview(adLabelView)
        adLabelView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .trailing)

        let height = UIScreen.main.bounds.width/3
        adMediaView.autoSetDimensions(to: CGSize(width: height, height: height))

        // adMediaView.setContentHuggingPriority(.defaultLow, for: .vertical)
        let textLayout = StackLayout()
       .direction(.vertical)
       .spacing(10)
       .children([
           adHeadLineLbl,
           holderView,
       ])
        
        let horLayout = StackLayout()
        .direction(.horizontal)
        .spacing(24)
        .children([
            textLayout,
            adMediaView,
        ])
       
        addSubview(horLayout)
        horLayout.autoPinEdgesToSuperviewEdges()
    }
    
    func updateOptions() {
        adMediaView.isHidden = !options.showMediaContent
        
        // adLabelLbl.textColor = options.adLabelTextStyle.color
        adLabelLbl.font = UIFont.systemFont(ofSize: options.adLabelTextStyle.fontSize)
    //    adLabelView.backgroundColor = options.adLabelTextStyle.backgroundColor ?? .fromHex("FFCC66")
        
        adHeadLineLbl.textColor = options.headlineTextStyle.color
        adHeadLineLbl.font = UIFont.systemFont(ofSize: options.headlineTextStyle.fontSize)
                
        adBodyLbl.textColor = options.bodyTextStyle.color
        adBodyLbl.font = UIFont.systemFont(ofSize: options.bodyTextStyle.fontSize)
        
    }
}
