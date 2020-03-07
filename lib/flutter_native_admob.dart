import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef NativeAdmobBannerViewCreatedCallback = void Function(
  NativeAdController controller,
);

class TextOptions {
  final double fontSize;
  final Color color;
  final Color backgroundColor;

  const TextOptions({
    this.fontSize,
    this.color,
    this.backgroundColor,
  });

  Map<String, dynamic> toJson() => {
        "backgroundColor": backgroundColor != null
            ? "#${backgroundColor.value.toRadixString(16)}"
            : null,
        "fontSize": fontSize,
        "color": "#${color.value.toRadixString(16)}",
      };
}

class BannerOptions {
  final Color backgroundColor;
  final Color indicatorColor;
  final Color ratingColor;
  final TextOptions adLabelOptions;
  final TextOptions headlineTextOptions;
  final TextOptions advertiserTextOptions;
  final TextOptions bodyTextOptions;
  final TextOptions storeTextOptions;
  final TextOptions priceTextOptions;
  final TextOptions callToActionOptions;

  const BannerOptions({
    this.backgroundColor = Colors.white,
    this.indicatorColor = Colors.black,
    this.ratingColor = Colors.yellow,
    this.adLabelOptions = const TextOptions(
      fontSize: 12,
      color: Colors.white,
      backgroundColor: Color(0xFFFFCC66),
    ),
    this.headlineTextOptions = const TextOptions(
      fontSize: 16,
      color: Colors.black,
    ),
    this.advertiserTextOptions = const TextOptions(
      fontSize: 14,
      color: Colors.black,
    ),
    this.bodyTextOptions = const TextOptions(
      fontSize: 12,
      color: Colors.grey,
    ),
    this.storeTextOptions = const TextOptions(
      fontSize: 12,
      color: Colors.black,
    ),
    this.priceTextOptions = const TextOptions(
      fontSize: 12,
      color: Colors.black,
    ),
    this.callToActionOptions = const TextOptions(
      fontSize: 15,
      color: Colors.white,
      backgroundColor: Color(0xFF4CBE99),
    ),
  });

  Map<String, dynamic> toJson() => {
        "backgroundColor": "#${backgroundColor.value.toRadixString(16)}",
        "indicatorColor": "#${indicatorColor.value.toRadixString(16)}",
        "ratingColor": "#${ratingColor.value.toRadixString(16)}",
        "adLabelOptions": adLabelOptions.toJson(),
        "headlineTextOptions": headlineTextOptions.toJson(),
        "advertiserTextOptions": advertiserTextOptions.toJson(),
        "bodyTextOptions": bodyTextOptions.toJson(),
        "storeTextOptions": storeTextOptions.toJson(),
        "priceTextOptions": priceTextOptions.toJson(),
        "callToActionOptions": callToActionOptions.toJson(),
      };
}

class NativeAdmobBannerView extends StatefulWidget {
  static const String _viewType = "native_admob_banner_view";

  final String adUnitID;
  final BannerOptions options;
  final bool showMedia;

  /// Content padding in format "left, top, right, bottom"
  final EdgeInsets contentPadding;

  final NativeAdmobBannerViewCreatedCallback onCreate;

  NativeAdmobBannerView({
    Key key,
    @required this.adUnitID,
    this.options,
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
  BannerOptions get _options => widget.options ?? BannerOptions();

  NativeAdmobBannerViewCreatedCallback get _onCreate => widget.onCreate;

  @override
  Widget build(BuildContext context) {
    final padding = this._padding;
    final options = this._options.toJson();
    final height =
        (widget.showMedia ? 330.0 : 140.0) + (padding.top + padding.bottom);

    final contentPadding = "${padding.left}," +
        "${padding.top}," +
        "${padding.right}," +
        "${padding.bottom}";

    final creationParams = {
      "adUnitID": widget.adUnitID,
      "options": options,
      "showMedia": widget.showMedia,
      "contentPadding": contentPadding,
    };

    if (defaultTargetPlatform == TargetPlatform.android) {
      return Container(
        height: height,
        child: AndroidView(
          viewType: NativeAdmobBannerView._viewType,
          onPlatformViewCreated: _onPlatformViewCreated,
          creationParamsCodec: StandardMessageCodec(),
          creationParams: creationParams,
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return Container(
        height: height,
        child: UiKitView(
          viewType: NativeAdmobBannerView._viewType,
          onPlatformViewCreated: _onPlatformViewCreated,
          creationParamsCodec: StandardMessageCodec(),
          creationParams: creationParams,
        ),
      );
    }

    return Text('$defaultTargetPlatform is not supported PlatformView yet.');
  }

  _onPlatformViewCreated(int id) {
    if (_onCreate != null) _onCreate(NativeAdController._(id));
  }
}

class NativeAdController {
  final MethodChannel _channel;

  NativeAdController._(int id)
      : _channel = new MethodChannel("${NativeAdmobBannerView._viewType}_$id");

  Future<Null> setOptions(BannerOptions options) async {
    await _channel.invokeMethod("setOptions", {
      "options": options.toJson(),
    });
    return null;
  }
}
