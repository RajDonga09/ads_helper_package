import 'dart:developer';

import 'package:ads_helper/interstitial_ad/interstitial_ad.dart';
import 'package:ads_helper/rewarded_ad/rewarded_ad.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdConfig {
  static final AdConfig _adConfig = AdConfig._internal();

  factory AdConfig() {
    return _adConfig;
  }

  AdConfig._internal();

  static String adMobBannerAdUnitId = ''; // admob_banner_ad_unitId
  static String facebookBannerAdUnitId = ''; // facebook_banner_ad_unitId
  static String adMobInterstitialAdUnitId = ''; // admob_interstitial_ad_unitId
  static String facebookInterstitialAdAdUnitId = ''; // facebook_interstitial_ad_unitId
  static String adMobRewardedAdUnitId = ''; // admob_rewarded_ad_unitId
  static String facebookRewardedAdUnitId = ''; // facebook_rewarded_ad_unitId
  static bool isShowFacebookBannerAds = false; // isShow_facebook_banner_ads
  static bool isShowFacebookInterstitialAd = false; // isShow_facebook_interstitial_ad
  static bool isProFeatureEnable = false; // isPro_feature_enable
  static int coolDownsTaps = 3; // cool_downs_taps
  static bool isAdFeatureEnable = false; // isAd_feature_enable

  // static int firstCoolDowns = 30;
  // static int secondCoolDowns = 60;

  Future<void> init({
    required String adMobBannerId,
    required String faceBookBannerId,
    required String adMobInterstitialAdId,
    required String faceBookInterstitialAdId,
    required String adMobRewardAdId,
    required String facebookRewardAdId,
    required bool proFutureEnable,
    bool isShowFaceBookBannerAd = false,
    bool showFacebookInterstitialAd = false,
    bool adFeatureEnable = true,
    int coolDownsTap = 3,
    // int? firstCoolDown,
    // int? secondCoolDown,
  }) async {
    adMobBannerAdUnitId = adMobBannerId;
    facebookBannerAdUnitId = faceBookBannerId;
    adMobInterstitialAdUnitId = adMobInterstitialAdId;
    facebookInterstitialAdAdUnitId = faceBookInterstitialAdId;
    adMobRewardedAdUnitId = adMobRewardAdId;
    facebookRewardedAdUnitId = facebookRewardAdId;
    isShowFacebookBannerAds = isShowFaceBookBannerAd;
    isShowFacebookInterstitialAd = showFacebookInterstitialAd;
    isProFeatureEnable = proFutureEnable;
    isProFeatureEnable = proFutureEnable;
    isAdFeatureEnable = adFeatureEnable;
    coolDownsTaps = coolDownsTap;
    // if (firstCoolDown != null) firstCoolDowns = firstCoolDown;
    // if (firstCoolDown != null) secondCoolDowns = firstCoolDown;

    log("AdDetails adMobBannerAdUnitId: $adMobBannerAdUnitId facebookBannerAdUnitId: $facebookBannerAdUnitId");
    MobileAds.instance.initialize();

    /// Load Ads
    if (isAdFeatureEnable) {
      loadAds();
    }
  }

  void loadAds() {
    InterstitialAdUtils.loadInterstitialAd();
    RewardedAdUtils.loadRewardedAd();
  }
}
