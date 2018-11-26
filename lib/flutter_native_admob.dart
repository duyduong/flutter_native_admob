import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef NativeAdmobBannerViewCreatedCallback = void Function(NativeAdController controller);

enum BannerStyle {
  dark, light
}

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
    this.contentPadding = const EdgeInsets.all(8.0),
    this.onCreate
  }) : assert(adUnitID.isNotEmpty),
        super(key: key);

  @override
  _NativeAdmobBannerViewState createState() => _NativeAdmobBannerViewState();
}

class _NativeAdmobBannerViewState extends State<NativeAdmobBannerView> {

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final style = widget.style == BannerStyle.dark ? "dark" : "light";
      final height = (widget.showMedia ? 330.0 : 140.0) + (widget.contentPadding.top + widget.contentPadding.bottom);

      final contentPadding = "${widget.contentPadding.left},${widget.contentPadding.top},${widget.contentPadding.right},${widget.contentPadding.bottom}";

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
            "contentPadding": contentPadding
          },
        ),
      );
    }

    return Text('$defaultTargetPlatform is not supported PlatformView yet.');
  }

  _onPlatformViewCreated(int id) {
    if (widget.onCreate != null)
      widget.onCreate(NativeAdController._(id));
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

  NativeAdController._(int id) : _channel = new MethodChannel("${NativeAdmobBannerView._viewType}_$id");

  Future<Null> setStyle(BannerStyle style) async {
    await _channel.invokeMethod("setStyle", {"style": style == BannerStyle.dark ? "dark" : "light"});
    return null;
  }
}
