import 'package:flutter/material.dart';

class NativeTextStyle {
  final double? fontSize;
  final Color? color;
  final Color? backgroundColor;
  final bool isVisible;

  const NativeTextStyle({
    this.fontSize,
    this.color,
    this.backgroundColor,
    this.isVisible = true,
  });

  Map<String, dynamic> toJson() => {
        "backgroundColor": backgroundColor != null ? "#${backgroundColor!.value.toRadixString(16)}" : null,
        "fontSize": fontSize,
        "color": color != null ? "#${color!.value.toRadixString(16)}" : null,
        "isVisible": isVisible,
      };
}

class NativeAdmobOptions {
  final bool showMediaContent;
  final Color ratingColor;
  final Color? backgroundColor;
  final NativeTextStyle adLabelTextStyle;
  final NativeTextStyle headlineTextStyle;
  final NativeTextStyle advertiserTextStyle;
  final NativeTextStyle bodyTextStyle;
  final NativeTextStyle storeTextStyle;
  final NativeTextStyle priceTextStyle;
  final NativeTextStyle callToActionStyle;

  const NativeAdmobOptions({
    this.showMediaContent = true,
    this.ratingColor = Colors.yellow,
    this.backgroundColor,
    this.adLabelTextStyle = const NativeTextStyle(
      fontSize: 12,
      color: Colors.white,
      backgroundColor: Color(0xFFFFCC66),
    ),
    this.headlineTextStyle = const NativeTextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
    this.advertiserTextStyle = const NativeTextStyle(
      fontSize: 14,
      color: Colors.black,
    ),
    this.bodyTextStyle = const NativeTextStyle(
      fontSize: 12,
      color: Colors.grey,
    ),
    this.storeTextStyle = const NativeTextStyle(
      fontSize: 12,
      color: Colors.black,
    ),
    this.priceTextStyle = const NativeTextStyle(
      fontSize: 12,
      color: Colors.black,
    ),
    this.callToActionStyle = const NativeTextStyle(
      fontSize: 15,
      color: Colors.white,
      backgroundColor: Color(0xFF4CBE99),
    ),
  });

  Map<String, dynamic> toJson() => {
        "showMediaContent": this.showMediaContent,
        "ratingColor": "#${ratingColor.value.toRadixString(16)}",
        "backgroundColor": backgroundColor != null ? "#${backgroundColor!.value.toRadixString(16)}" : null,
        "adLabelTextStyle": adLabelTextStyle.toJson(),
        "headlineTextStyle": headlineTextStyle.toJson(),
        "advertiserTextStyle": advertiserTextStyle.toJson(),
        "bodyTextStyle": bodyTextStyle.toJson(),
        "storeTextStyle": storeTextStyle.toJson(),
        "priceTextStyle": priceTextStyle.toJson(),
        "callToActionStyle": callToActionStyle.toJson(),
      };
}
