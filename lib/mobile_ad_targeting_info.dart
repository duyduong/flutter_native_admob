// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: deprecated_member_use_from_same_package

// These are temporary ignores to allow us to land a new set of linter rules in
// a series of manageable patches instead of one gigantic PR. It disables some
// of the new lints that are already failing on this plugin, for this plugin. It
// should be deleted and the failing lints addressed as soon as possible.
//
// ignore_for_file: public_member_api_docs
// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

/// [MobileAd] status changes reported to [MobileAdListener]s.
///
/// Applications can wait until an ad is [MobileAdEvent.loaded] before showing
/// it, to ensure that the ad is displayed promptly.
enum MobileAdEvent {
  loaded,
  failedToLoad,
  clicked,
  impression,
  opened,
  leftApplication,
  closed,
}

/// Signature for a [MobileAd] status change callback.
typedef void MobileAdListener(MobileAdEvent event);

/// Targeting info per the native AdMob API.
///
/// This class's properties mirror the native AdRequest API. See for example:
/// [AdRequest.Builder for Android](https://firebase.google.com/docs/reference/android/com/google/android/gms/ads/AdRequest.Builder).
class MobileAdTargetingInfo {
  const MobileAdTargetingInfo(
      {this.keywords,
      this.contentUrl,
      this.childDirected,
      this.testDevices,
      this.nonPersonalizedAds});

  final List<String> keywords;
  final String contentUrl;
  final bool childDirected;
  final List<String> testDevices;
  final bool nonPersonalizedAds;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{
      'requestAgent': 'flutter-alpha',
    };

    if (keywords != null && keywords.isNotEmpty) {
      assert(keywords.every((String s) => s != null && s.isNotEmpty));
      json['keywords'] = keywords;
    }
    if (nonPersonalizedAds != null)
      json['nonPersonalizedAds'] = nonPersonalizedAds;
    if (contentUrl != null && contentUrl.isNotEmpty)
      json['contentUrl'] = contentUrl;
    if (childDirected != null) json['childDirected'] = childDirected;
    if (testDevices != null && testDevices.isNotEmpty) {
      assert(testDevices.every((String s) => s != null && s.isNotEmpty));
      json['testDevices'] = testDevices;
    }

    return json;
  }
}

enum AnchorType { bottom, top }

// The types of ad sizes supported for banners. The names of the values are used
// in MethodChannel calls to iOS and Android, and should not be changed.
enum AdSizeType {
  WidthAndHeight,
  SmartBanner,
}

/// [AdSize] represents the size of a banner ad. There are six sizes available,
/// which are the same for both iOS and Android. See the guides for banners on
/// [Android](https://developers.google.com/admob/android/banner#banner_sizes)
/// and [iOS](https://developers.google.com/admob/ios/banner#banner_sizes) for
/// additional details.
class AdSize {
  // Private constructor. Apps should use the static constants rather than
  // create their own instances of [AdSize].
  const AdSize._({
    @required this.width,
    @required this.height,
    @required this.adSizeType,
  });

  final int height;
  final int width;
  final AdSizeType adSizeType;

  /// The standard banner (320x50) size.
  static const AdSize banner = AdSize._(
    width: 320,
    height: 50,
    adSizeType: AdSizeType.WidthAndHeight,
  );

  /// The large banner (320x100) size.
  static const AdSize largeBanner = AdSize._(
    width: 320,
    height: 100,
    adSizeType: AdSizeType.WidthAndHeight,
  );

  /// The medium rectangle (300x250) size.
  static const AdSize mediumRectangle = AdSize._(
    width: 300,
    height: 250,
    adSizeType: AdSizeType.WidthAndHeight,
  );

  /// The full banner (468x60) size.
  static const AdSize fullBanner = AdSize._(
    width: 468,
    height: 60,
    adSizeType: AdSizeType.WidthAndHeight,
  );

  /// The leaderboard (728x90) size.
  static const AdSize leaderboard = AdSize._(
    width: 728,
    height: 90,
    adSizeType: AdSizeType.WidthAndHeight,
  );

  /// The smart banner size. Smart banners are unique in that the width and
  /// height values declared here aren't used. At runtime, the Mobile Ads SDK
  /// will automatically adjust the banner's width to match the width of the
  /// displaying device's screen. It will also set the banner's height using a
  /// calculation based on the displaying device's height. For more info see the
  /// [Android](https://developers.google.com/admob/android/banner) and
  /// [iOS](https://developers.google.com/admob/ios/banner) banner ad guides.
  static const AdSize smartBanner = AdSize._(
    width: 0,
    height: 0,
    adSizeType: AdSizeType.SmartBanner,
  );
}
