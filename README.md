<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Add in ymla file

```dart
  ads_helper:
    git:
      url: https://github.com/RajDonga09/ads_helper_package.git
      ref: master
```

TODO: Add in AndroidManifest file for google AD

```dart
  <meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="<YOUR-APPLICATION-ID>" />
```

TODO: Add in main.dart

```dart
  Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await AdConfig().init(
      adMobAdOpenId: '',
      adMobBannerId: '',
      adMobInterstitialAdId: '',
      adMobRewardAdId: '',
      faceBookBannerId: '',
      faceBookInterstitialAdId: '',
      facebookRewardAdId: '',
      isShowFaceBookBannerAd: false,
      showFacebookInterstitialAd: false,
      showFacebookRewardedAd: false,
      showFacebookTestAd: false,
      coolDownsTap: 2,
      proFutureEnable: false,
      adFeatureEnable: true,
      showButtonAd: false,
      showAllAdmobAds: true, 
      showAppOpenAd: true, 
      showAppOpenAdDelay: 2000,
    );
  } catch (e) {
    print('!!!!!!!!! Error AdConfig $e');
  }
}  
```

TODO: The app will show open ads when the add open ad ID and showAppOpenAd flag is enabled

```dart
  adMobAdOpenId: '',
  showAppOpenAd: true,
}  
```

TODO: Show Interstitial Ads

```dart
  AdsHelper.showInterstitialAds(adCloseEvent: () {
    print('Close ad event);
  });
```

TODO: Show Rewarded Ads

```dart
  AdsHelper.showRewardedAd(adShowSuccess: () {
    print("Show Success Ad");
  });
```
## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
