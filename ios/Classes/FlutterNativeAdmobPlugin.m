#import "FlutterNativeAdmobPlugin.h"
#import <flutter_native_admob/flutter_native_admob-Swift.h>

@implementation FlutterNativeAdmobPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterNativeAdmobPlugin registerWithRegistrar:registrar];
}
@end
