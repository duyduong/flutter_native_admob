[![pub package](https://img.shields.io/pub/v/flutter_native_admob.svg)](https://pub.dartlang.org/packages/flutter_native_admob)

# flutter_native_admob

Plugin to integrate Firebase Native Admob to Flutter application
Platform supported: **iOS**, **Android**

# Getting Started

For help getting started with Flutter, view our online [documentation](http://flutter.io/).

## Setup Android project

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

## Setup iOS project

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

## How it works

`NativeAdmob` is a Flutter widget, so you can add it anywhere in Flutter application.

| Property   | Description                                       | Type                  |
| :--------- | :------------------------------------------------ | :-------------------- |
| adUnitID   | Your ad unit ID to load                           | String                |
| loading    | A widget to show when the ad is loading           | Widget                |
| error      | A widget to show when the ad got error            | Widget                |
| options    | Native ad styling options                         | NativeAdmobOptions    |
| controller | Controller for controlling the NativeAdmob widget | NativeAdmobController |

#### `NativeAdmobOptions`

| Property            | Description                                                                                    | Type            | Default value                                                           |
| ------------------- | ---------------------------------------------------------------------------------------------- | --------------- | ----------------------------------------------------------------------- |
| showMediaContent    | Whether to show the media content or not                                                       | bool            | true                                                                    |
| ratingColor         | Rating star color                                                                              | Color           | Colors.yellow                                                           |
| adLabelTextStyle    | The ad label on the top left corner                                                            | NativeTextStyle | `fontSize: 12, color: Colors.white, backgroundColor: Color(0xFFFFCC66)` |
| headlineTextStyle   | The ad headline title                                                                          | NativeTextStyle | `fontSize: 16, color: Colors.black`                                     |
| advertiserTextStyle | Identifies the advertiser. For example, the advertiser’s name or visible URL. (below headline) | NativeTextStyle | `fontSize: 14, color: Colors.black`                                     |
| bodyTextStyle       | The ad description                                                                             | NativeTextStyle | `fontSize: 12, color: Colors.grey`                                      |
| storeTextStyle      | The app store name. For example, "App Store".                                                  | NativeTextStyle | `fontSize: 12, color: Colors.black`                                     |
| priceTextStyle      | String representation of the app's price.                                                      | NativeTextStyle | `fontSize: 12, color: Colors.black`                                     |
| callToActionStyle   | Text that encourages user to take some action with the ad. For example "Install".              | NativeTextStyle | `fontSize: 15, color: Colors.white, backgroundColor: Color(0xFF4CBE99)` |

#### `NativeTextStyle`

| Property        | Description      | Type   |
| :-------------- | :--------------- | :----- |
| fontSize        | Text font size   | double |
| color           | Text color       | Color  |
| backgroundColor | Background color | Color  |

#### `NativeAdmobController`

| Property/Function                          | Description                                                                         | Type                |
| :----------------------------------------- | :---------------------------------------------------------------------------------- | :------------------ |
| stateChanged                               | Stream that notify each time the loading state changed                              | Stream<AdLoadState> |
| void setAdUnitID(String adUnitID)          | Change the ad unit ID, it will load the ad again if the id is changed from previous |                     |
| void reloadAd({bool forceRefresh = false}) | Reload the ad                                                                       |                     |

## Examples

### Default

```dart
NativeAdmob(
  adUnitID: "<Your ad unit ID>"
)
```

### Using controller, loading, error widget and options

```dart
final _controller = NativeAdmobController();

NativeAdmob(
  adUnitID: "<Your ad unit ID>",
  loading: Center(child: CircularProgressIndicator()),
  error: Text("Failed to load the ad"),
  controller: _controller,
  options: NativeAdmobOptions(
    ratingColor: Colors.red,
    // Others ...
  ),
)
```

### Hide the ad until it load completed

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const _adUnitID = "<Your ad unit ID>";

  final _nativeAdController = NativeAdmobController();
  double _height = 0;

  StreamSubscription _subscription;

  @override
  void initState() {
    _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _nativeAdController.dispose();
    super.dispose();
  }

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          _height = 0;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          _height = 330;
        });
        break;

      default:
        break;
    }
  }

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
            Container(
              height: _height,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 20.0),
              child: NativeAdmob(
                // Your ad unit id
                adUnitID: _adUnitID,
                controller: _nativeAdController,

                // Don't show loading widget when in loading state
                loading: Container(),
              ),
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
}
```

### Prevent ad from reloading on ListView/GridView

When putting `NativeAdmob` in ListView/GridView, it will keep reloading as the `PlatformView` init again when scrolling to the item. To prevent from reloading and take full control of the `NativeAdmob`, we can create `NativeAdmobController` and keep it

```dart
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const _adUnitID = "<Your ad unit ID>";

  final _controller = NativeAdmobController();

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
            Container(
              height: 330,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 20.0),
              child: NativeAdmob(
                adUnitID: _adUnitID,
                controller: _controller,
              ),
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
            Container(
              height: 330,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 20.0),
              child: NativeAdmob(
                adUnitID: _adUnitID,
                controller: _controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```
