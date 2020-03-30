import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'native_admob_controller.dart';
import 'native_admob_options.dart';

const _viewType = "native_admob";

enum NativeAdmobTemplateSize { small, medium }

class NativeAdmob extends StatefulWidget {
  final String adUnitID;
  final NativeAdmobOptions options;
  final NativeAdmobTemplateSize templateSize;

  final Widget loading;
  final Widget error;

  final NativeAdmobController controller;

  NativeAdmob({
    Key key,
    @required this.adUnitID,
    this.options,
    this.loading,
    this.error,
    this.controller,
    this.templateSize = NativeAdmobTemplateSize.medium,
  })  : assert(adUnitID.isNotEmpty),
        super(key: key);

  @override
  _NativeAdmobState createState() => _NativeAdmobState();
}

class _NativeAdmobState extends State<NativeAdmob> {
  static final isAndroid = defaultTargetPlatform == TargetPlatform.android;
  static final isiOS = defaultTargetPlatform == TargetPlatform.iOS;

  NativeAdmobController _nativeAdController;

  NativeAdmobOptions get _options => widget.options ?? NativeAdmobOptions();
  NativeAdmobTemplateSize get _templateSize =>
      widget.templateSize ?? NativeAdmobTemplateSize.medium;

  Widget get _loading =>
      widget.loading ?? Center(child: CircularProgressIndicator());

  Widget get _error => widget.error ?? Container();

  var _loadState = AdLoadState.loading;
  StreamSubscription _subscription;

  @override
  void initState() {
    _nativeAdController = widget.controller ?? NativeAdmobController();
    _nativeAdController.setAdUnitID(widget.adUnitID);

    _subscription = _nativeAdController.stateChanged.listen((state) {
      setState(() {
        _loadState = state;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();

    // We only dispose internal controller, external controller will be kept
    if (widget.controller == null) _nativeAdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isAndroid || isiOS) {
      return Container(
        child: _loadState == AdLoadState.loading
            ? _loading
            : _loadState == AdLoadState.loadError
                ? _error
                : _createPlatformView(),
      );
    }

    return Text('$defaultTargetPlatform is not supported PlatformView yet.');
  }

  Widget _createPlatformView() {
    final creationParams = {
      "options": _options.toJson(),
      "controllerID": _nativeAdController.id,
      "templateSize":
          _templateSize.toString().replaceAll("NativeAdmobTemplateSize.", ""),
    };

    return isAndroid
        ? AndroidView(
            viewType: _viewType,
            creationParamsCodec: StandardMessageCodec(),
            creationParams: creationParams,
          )
        : UiKitView(
            viewType: _viewType,
            creationParamsCodec: StandardMessageCodec(),
            creationParams: creationParams,
          );
  }
}
