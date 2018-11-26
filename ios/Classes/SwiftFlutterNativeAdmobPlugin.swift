import Flutter
import UIKit

public class SwiftFlutterNativeAdmobPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_native_admob", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterNativeAdmobPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
