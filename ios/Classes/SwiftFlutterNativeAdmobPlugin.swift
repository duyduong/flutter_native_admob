import Flutter
import UIKit
import GoogleMobileAds
import PureLayout

enum CallMethod: String {
    case setStyle
}

let viewType = "native_admob_banner_view"

public class SwiftFlutterNativeAdmobPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_native_admob", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterNativeAdmobPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let viewFactory = NativeAdmobBannerViewFactory(withMessenger: registrar.messenger())
        registrar.register(viewFactory, withId: viewType)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        return result(FlutterMethodNotImplemented)
    }
}

extension UIColor {
    
    convenience init(hex: Int) {
        self.init(hex: hex, a: 1.0)
    }
    
    convenience init(hex: Int, a: CGFloat) {
        self.init(r: (hex >> 16) & 0xff, g: (hex >> 8) & 0xff, b: hex & 0xff, a: a)
    }
    
    convenience init(r: Int, g: Int, b: Int) {
        self.init(r: r, g: g, b: b, a: 1.0)
    }
    
    convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    convenience init?(hexString: String) {
        var hexString = hexString.replacingOccurrences(of: "#", with: "")
        if hexString.count == 3 {
            hexString += hexString
        }
        guard let hex = Int(hexString, radix: 16) else { return nil }
        self.init(hex: hex)
    }
    
    static func fromHex(_ hexString: String) -> UIColor {
        return UIColor(hexString: hexString) ?? .clear
    }
}

extension UIEdgeInsets {
    
    static func parse(_ value: String) -> UIEdgeInsets {
        let parts = value.components(separatedBy: ",").map { val -> CGFloat in
            let trimmedVal = val.trimmingCharacters(in: .whitespacesAndNewlines)
            return CGFloat((trimmedVal as NSString).doubleValue)
        }
        
        if parts.count < 4 {
            return .zero
        }
        
        return UIEdgeInsets(top: parts[1], left: parts[0], bottom: parts[3], right: parts[2])
    }
}

extension UIImage {
    
    /// Create image from mono color
    static func from(color: UIColor) -> UIImage {
        let size = CGSize(width: 1, height: 1)
        return from(color: color, withSize: size)
    }
    
    /// Create image from mono color with specific size and corner radius
    static func from(color: UIColor, withSize size: CGSize, cornerRadius: CGFloat = 0) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: cornerRadius)
        path.addClip()
        color.setFill()
        path.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
