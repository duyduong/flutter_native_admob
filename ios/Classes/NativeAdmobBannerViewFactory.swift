//
//  NativeAdmobBannerViewFactory.swift
//  flutter_native_admob
//
//  Created by Dao Duy Duong on 1/22/20.
//

import UIKit
import GoogleMobileAds

class NativeAdmobBannerViewFactory: NSObject, FlutterPlatformViewFactory {
    
    private let messenger: FlutterBinaryMessenger
    
    init(withMessenger messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return NativeAdmobBannerView(frame, messenger: messenger , viewId: viewId, args: args)
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}

class NativeAdmobBannerView: NSObject, FlutterPlatformView {
    
    private let methodChannel: FlutterMethodChannel
    private let bannerView: NativeAdmobBannerViewHoder
    private var adLoader: GADAdLoader?
    
    private let params: [String: Any]
    
    init(_ frame: CGRect, messenger: FlutterBinaryMessenger, viewId: Int64, args: Any?) {
        bannerView = NativeAdmobBannerViewHoder(frame: frame)
        methodChannel = FlutterMethodChannel(name: "\(viewType)_\(viewId)", binaryMessenger: messenger)
        params = args as? [String: Any] ?? [:]
        
        super.init()
        
        if let adUnitID = params["adUnitID"] as? String {
            adLoader = GADAdLoader(adUnitID: adUnitID, rootViewController: nil, adTypes: [.unifiedNative], options: nil)
            adLoader?.load(GADRequest())
            adLoader?.delegate = self
            
            bannerView.isLoading = true
        }
        
        methodChannel.setMethodCallHandler(handle)
    }
    
    func view() -> UIView {
        if let styleValue = params["style"] as? String, let style = BannerStyle(rawValue: styleValue) {
            bannerView.style = style
        }
        
        if let paddingValue = params["contentPadding"] as? String {
            let insets = UIEdgeInsets.parse(paddingValue)
            bannerView.contentPadding = insets
        }
        
        return bannerView
    }
    
    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let callMethod = CallMethod(rawValue: call.method) else { return result(FlutterMethodNotImplemented) }
        switch callMethod {
        case .setStyle:
            guard let value = params["style"] as? String, let style = BannerStyle(rawValue: value) else {
                return result(nil)
            }
            
            bannerView.style = style
        }
    }
}

extension NativeAdmobBannerView: GADUnifiedNativeAdLoaderDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("NativeAdmobBannerView: ad loaded failed with error: \(error.localizedDescription)")
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        bannerView.setNativeAd(nativeAd)
    }
}
