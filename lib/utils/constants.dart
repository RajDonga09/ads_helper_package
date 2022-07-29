import 'package:google_mobile_ads/google_mobile_ads.dart';

class Constant {

  static const double bannerAdHeight = 50;
  // static const int maxFailedLoadAttempts = 2;
  static bool isFailedAdMobBannerAd = false;
  // static bool isFailedAdMobInterstitialAd = false;

  static const AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );
}