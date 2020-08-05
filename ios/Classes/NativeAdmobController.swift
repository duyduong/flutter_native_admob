//
//  NativeAdmobController.swift
//  flutter_native_admob
//
//  Created by Dao Duy Duong on 3/14/20.
//

import GoogleMobileAds

class NativeAdmobController: NSObject {
    
    enum CallMethod: String {
        case setAdUnitID
        case reloadAd
        case setNonPersonalizedAds
    }
    
    enum LoadState: String {
        case loading, loadError, loadCompleted
    }
    
    let id: String
    let channel: FlutterMethodChannel
    
    var nativeAdChanged: ((GADUnifiedNativeAd?) -> Void)?
    var nativeAd: GADUnifiedNativeAd? {
        didSet { invokeLoadCompleted() }
    }
    
    private var adLoader: GADAdLoader?
    private var adUnitID: String?
    private var nonPersonalizedAds: Bool = false
    
    init(id: String, channel: FlutterMethodChannel) {
        self.id = id
        self.channel = channel
        super.init()
        
        channel.setMethodCallHandler(handle)
    }
    
    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let callMethod = CallMethod(rawValue: call.method) else { return result(FlutterMethodNotImplemented) }
        let params = call.arguments as? [String: Any]
        
        switch callMethod {
        case .setAdUnitID:
            guard let adUnitID = params?["adUnitID"] as? String else {
                return result(nil)
            }
            let isChanged = adUnitID != self.adUnitID
            self.adUnitID = adUnitID
            if adLoader == nil || isChanged {
                let numberAds: Int = params?["numberAds"] as? Int ?? 1
                let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
                if numberAds != nil && numberAds > 1 {
                    multipleAdsOptions.numberOfAds = numberAds
                }
                adLoader = GADAdLoader(
                    adUnitID: adUnitID, 
                    rootViewController: nil, 
                    adTypes: [.unifiedNative], 
                    options: [multipleAdsOptions]
                )
                adLoader?.delegate = self
            }
            if nativeAd == nil || isChanged {
                loadAd()
            } else {
                invokeLoadCompleted()
            }
            
        case .reloadAd:
            let forceRefresh = params?["forceRefresh"] as? Bool ?? false
            if forceRefresh || nativeAd == nil {
                loadAd()
            } else {
                invokeLoadCompleted()
            }
            
        case .setNonPersonalizedAds:
            if let nonPersonalizedAds = params?["nonPersonalizedAds"] as? Bool {
                self.nonPersonalizedAds = nonPersonalizedAds
            }
            return result(nil)
        }
        
        result(nil)
    }
    
    private func loadAd() {
        channel.invokeMethod(LoadState.loading.rawValue, arguments: nil)
        let request = GADRequest()
        if self.nonPersonalizedAds {
            let extras = GADExtras()
            extras.additionalParameters = ["npa": "1"]
            request.register(extras)
        }
        adLoader?.load(request)
    }
    
    private func invokeLoadCompleted() {
        nativeAdChanged?(nativeAd)
        channel.invokeMethod(LoadState.loadCompleted.rawValue, arguments: nil)
    }
}

extension NativeAdmobController: GADUnifiedNativeAdLoaderDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("NativeAdmob: failed to load with error: \(error.localizedDescription)")
        channel.invokeMethod(LoadState.loadError.rawValue, arguments: nil)
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        self.nativeAd = nativeAd
    }
}

class NativeAdmobControllerManager {
    
    static let shared = NativeAdmobControllerManager()
    
    private var controllers: [NativeAdmobController] = []
    
    private init() {}
    
    func createController(forID id: String, binaryMessenger: FlutterBinaryMessenger) {
        if getController(forID: id) == nil {
            let methodChannel = FlutterMethodChannel(name: id, binaryMessenger: binaryMessenger)
            let controller = NativeAdmobController(id: id, channel: methodChannel)
            controllers.append(controller)
        }
    }
    
    func getController(forID id: String) -> NativeAdmobController? {
        return controllers.first(where: { $0.id == id })
    }
    
    func removeController(forID id: String) {
        if let index = controllers.firstIndex(where: { $0.id == id }) {
            controllers.remove(at: index)
        }
    }
}
