import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef NativeAdmobBannerViewCreatedCallback = void Function(
  NativeAdController controller,
);

enum BannerStyle { dark, light }

class NativeAdmobBannerView extends StatefulWidget {
  static const String _viewType = "native_admob_banner_view";

  final String adUnitID;
  final BannerStyle style;
  final bool showMedia;

  /// Content padding in format "left, top, right, bottom"
  final EdgeInsets contentPadding;

  final NativeAdmobBannerViewCreatedCallback onCreate;

  NativeAdmobBannerView({
    Key key,
    @required this.adUnitID,
    this.style = BannerStyle.dark,
    this.showMedia = true,
    this.contentPadding,
    this.onCreate,
  })  : assert(adUnitID.isNotEmpty),
        super(key: key);

  @override
  _NativeAdmobBannerViewState createState() => _NativeAdmobBannerViewState();
}

class _NativeAdmobBannerViewState extends State<NativeAdmobBannerView> {
  EdgeInsets get _padding => widget.contentPadding ?? EdgeInsets.all(8);
  NativeAdmobBannerViewCreatedCallback get _onCreate => widget.onCreate;

  @override
  Widget build(BuildContext context) {
    final padding = this._padding;
    final style = widget.style == BannerStyle.dark ? "dark" : "light";
    final height =
        (widget.showMedia ? 330.0 : 140.0) + (padding.top + padding.bottom);

    final contentPadding = "${padding.left}," +
        "${padding.top}," +
        "${padding.right}," +
        "${padding.bottom}";

    if (defaultTargetPlatform == TargetPlatform.android) {
      return Container(
        height: height,
        child: AndroidView(
          viewType: NativeAdmobBannerView._viewType,
          onPlatformViewCreated: _onPlatformViewCreated,
          creationParamsCodec: StandardMessageCodec(),
          creationParams: {
            "adUnitID": widget.adUnitID,
            "style": style,
            "showMedia": widget.showMedia,
            "contentPadding": contentPadding,
          },
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return Container(
        height: height,
        child: UiKitView(
          viewType: NativeAdmobBannerView._viewType,
          onPlatformViewCreated: _onPlatformViewCreated,
          creationParamsCodec: StandardMessageCodec(),
          creationParams: {
            "adUnitID": widget.adUnitID,
            "style": style,
            "showMedia": widget.showMedia,
            "contentPadding": contentPadding,
          },
        ),
      );
    }

    return Text('$defaultTargetPlatform is not supported PlatformView yet.');
  }

  _onPlatformViewCreated(int id) {
    if (_onCreate != null) _onCreate(NativeAdController._(id));
  }
}

class NativeAdmob {
  static NativeAdmob _instance;

  factory NativeAdmob() => _instance ??= NativeAdmob._();

  NativeAdmob._();

  final _channel = MethodChannel("flutter_native_admob");

  Future<Null> initialize({String appID}) async {
    await _channel.invokeMethod("initialize", {"appID": appID});
    return null;
  }
}

class NativeAdController {
  final MethodChannel _channel;

  NativeAdController._(int id)
      : _channel = new MethodChannel("${NativeAdmobBannerView._viewType}_$id");

  Future<Null> setStyle(BannerStyle style) async {
    await _channel.invokeMethod("setStyle", {
      "style": style == BannerStyle.dark ? "dark" : "light",
    });
    return null;
  }
}
