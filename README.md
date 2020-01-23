[![pub package](https://img.shields.io/pub/v/flutter_native_admob.svg)](https://pub.dartlang.org/packages/flutter_native_admob)

# flutter_native_admob

Plugin to integrate Firebase Native Admob to Flutter application
Platform supported: **iOS**, **Android**

## Getting Started

For help getting started with Flutter, view our online [documentation](http://flutter.io/).

## How it works

The plugin provides:

- `NativeAdmob`: a singleton class that let you to initialize Admob app ID
- `NativeAdmobBannerView`: a Flutter widget

### Setup Android project

1. Add the classpath to the [project]/android/build.gradle file.

```s
dependencies {
  // Example existing classpath
  classpath 'com.android.tools.build:gradle:3.2.1'
  // Add the google services classpath
  classpath 'com.google.gms:google-services:4.3.0'
}
```

2. Add the apply plugin to the [project]/android/app/build.gradle file.

```s
// ADD THIS AT THE BOTTOM
apply plugin: 'com.google.gms.google-services'
```

3. Add your Admob App ID.
   **_Important_**: This step is required as of Google Mobile Ads SDK version 17.0.0. Failure to add this <meta-data> tag results in a crash with the message: The Google Mobile Ads SDK was initialized incorrectly.

```xml
<manifest>
    <application>
        <!-- Sample AdMob App ID: ca-app-pub-3940256099942544~3347511713 -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
    </application>
</manifest>
```

### Setup iOS project

1. Add Admob App ID:
   **_Important_**: This step is required as of Google Mobile Ads SDK version 7.42.0. Failure to add add this Info.plist entry results in a crash with the message: The Google Mobile Ads SDK was initialized incorrectly.
   In your app's Info.plist file, add a GADApplicationIdentifier key with a string value of your AdMob app ID. You can find your App ID in the AdMob UI.
   You can make this change programmatically:

```xml
<key>GADApplicationIdentifier</key>
<string>Your_Admob_App_ID</string>
```

2. Add embeded view support:
   In your app's Info.plist file, add this

```xml
<key>io.flutter.embedded_views_preview</key>
<true/>
```

### Integrate banner view widget

`NativeAdmobBannerView` is a Flutter widget, so you can add it anywhere in Flutter application. For example:

```dart
@override
Widget build(BuildContext context) {
return MaterialApp(
  home: Scaffold(
    appBar: AppBar(
      title: const Text('Plugin example app'),
    ),
    body: ListView(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 20.0),
          height: 200.0,
          color: Colors.green,
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20.0),
          height: 200.0,
          color: Colors.green,
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20.0),
          height: 200.0,
          color: Colors.green,
        ),
        NativeAdmobBannerView(
          adUnitID: "<Your ad unit ID>",
          style: BannerStyle.dark, // enum dark or light
          showMedia: true, // whether to show media view or not
          contentPadding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0), // content padding
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20.0),
          height: 200.0,
          color: Colors.green,
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20.0),
          height: 200.0,
          color: Colors.green,
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20.0),
          height: 200.0,
          color: Colors.green,
        ),
      ],
    ),
  ),
);
}
```

**_Warning:_**
`NativeAdmobBannerView` has a fixed height. Its height is based on content height, content padding (`contentPadding` parameter) and media view (`showMedia` parameter). So you don't need to worry about the widget height.

## Example

To run example project, please follow this link: [Flutter Firebase](https://firebase.google.com/docs/flutter/setup) to integrate you google services
