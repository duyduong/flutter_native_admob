import Flutter
import UIKit
import GoogleMobileAds
import PureLayout

let viewType = "native_admob"
let controllerManager = NativeAdmobControllerManager.shared

public class SwiftFlutterNativeAdmobPlugin: NSObject, FlutterPlugin {
    
    enum CallMethod: String {
        case initController
        case disposeController
        case setTestDeviceIds
    }
    
    let messenger: FlutterBinaryMessenger
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger = registrar.messenger()
        
        let channel = FlutterMethodChannel(name: "flutter_native_admob", binaryMessenger: messenger)
        
        let instance = SwiftFlutterNativeAdmobPlugin(messenger: messenger)
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let viewFactory = PlatformViewFactory()
        registrar.register(viewFactory, withId: viewType)
    }
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let callMethod = CallMethod(rawValue: call.method) else { return result(FlutterMethodNotImplemented) }
        let params = call.arguments as? [String: Any]
        
        switch callMethod {
        case .initController:
            if let controllerID = params?["controllerID"] as? String {
                controllerManager.createController(forID: controllerID, binaryMessenger: messenger)
            }
            
        case .disposeController:
            if let controllerID = params?["controllerID"] as? String {
                controllerManager.removeController(forID: controllerID)
            }

        case .setTestDeviceIds:
            if let testDeviceIds = params?["testDeviceIds"] as? [String] {
                GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = testDeviceIds
            }
        }
        
        result(nil)
    }
}

class PlatformViewFactory: NSObject, FlutterPlatformViewFactory {
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return PlatformView(frame, viewId: viewId, args: args)
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

class PlatformView: NSObject, FlutterPlatformView {
    
    private var controller: NativeAdmobController?
    
    private let nativeAdView: NativeAdView
    private let params: [String: Any]
    
    init(_ frame: CGRect, viewId: Int64, args: Any?) {
        var type: NativeAdmobType?
        if let typeValue = (args as? [String: Any])?["type"] as? String {
            type = NativeAdmobType(rawValue: typeValue)
        }
        
        nativeAdView = NativeAdView(frame: frame, type: type ?? .full)
        params = args as? [String: Any] ?? [:]
        
        super.init()
        
        if let controllerID = params["controllerID"] as? String,
            let controller = controllerManager.getController(forID: controllerID) {
            self.controller = controller
            
            // Update native ad view when ad changed
            controller.nativeAdChanged = nativeAdView.setNativeAd
        }
        
        // Set options
        if let data = params["options"] as? [String: Any] {
            nativeAdView.options = NativeAdmobOptions(data)
        }
        
        // Set native ad
        if let nativeAd = controller?.nativeAd {
            nativeAdView.setNativeAd(nativeAd)
        }
    }
    
    func view() -> UIView {
        return nativeAdView
    }
}
