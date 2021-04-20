import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AdLoadState { loading, loadError, loadCompleted }

class NativeAdmobController {
  final _key = UniqueKey();
  String get id => _key.toString();

  final _stateChanged = StreamController<AdLoadState>.broadcast();
  Stream<AdLoadState> get stateChanged => _stateChanged.stream;

  /// Channel to communicate with plugin
  final _pluginChannel = const MethodChannel("flutter_native_admob");

  /// Channel to communicate with controller
  late MethodChannel _channel;
  String? _adUnitID;

  NativeAdmobController() {
    _channel = MethodChannel(id);
    _channel.setMethodCallHandler(_handleMessages);

    // Let the plugin know there is a new controller
    _pluginChannel.invokeMethod("initController", {
      "controllerID": id,
    });
  }

  void dispose() {
    _pluginChannel.invokeMethod("disposeController", {
      "controllerID": id,
    });
  }

  Future<Null> _handleMessages(MethodCall call) async {
    switch (call.method) {
      case "loading":
        _stateChanged.add(AdLoadState.loading);
        break;

      case "loadError":
        _stateChanged.add(AdLoadState.loadError);
        break;

      case "loadCompleted":
        _stateChanged.add(AdLoadState.loadCompleted);
        break;
    }
  }

  /// Change the ad unit ID
  void setAdUnitID(String adUnitID, {int numberAds = 1}) {
    _adUnitID = adUnitID;
    _channel.invokeMethod("setAdUnitID", {
      "adUnitID": adUnitID,
      "numberAds": numberAds,
    });
  }

  /// Set the option to disable the personalized Ads
  void setNonPersonalizedAds(bool nonPersonalizedAds) {
    _channel.invokeMethod("setNonPersonalizedAds", {
      "nonPersonalizedAds": nonPersonalizedAds,
    });
  }

  /// Reload new ad with specific native ad id
  ///
  ///  * [forceRefresh], force reload a new ad or using cache ad
  void reloadAd({bool forceRefresh = false, int numberAds = 1}) {
    if (_adUnitID == null) return;

    _channel.invokeMethod("reloadAd", {
      "forceRefresh": forceRefresh,
      "numberAds": numberAds,
    });
  }

  void setTestDeviceIds(List<String>? ids) {
    if (ids == null || ids.isEmpty) return;

    _pluginChannel.invokeMethod("setTestDeviceIds", {
      "testDeviceIds": ids,
    });
  }
}
