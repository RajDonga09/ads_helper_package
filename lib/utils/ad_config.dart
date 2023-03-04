import 'dart:developer';

import 'package:ads_helper/app_open_ad/app_open_ad.dart';
import 'package:ads_helper/interstitial_ad/interstitial_ad.dart';
import 'package:ads_helper/rewarded_ad/rewarded_ad.dart';
import 'package:ads_helper/utils/utils.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdConfig {
  static final AdConfig _adConfig = AdConfig._internal();

  factory AdConfig() {
    return _adConfig;
  }

  AdConfig._internal();

  static String adMobAppOpenAdUnitId = ''; // admob_app_open_ad_unitId
  static String adMobBannerAdUnitId = ''; // admob_banner_ad_unitId
  static String facebookBannerAdUnitId = ''; // facebook_banner_ad_unitId
  static String adMobInterstitialAdUnitId = ''; // admob_interstitial_ad_unitId
  static String facebookInterstitialAdAdUnitId = ''; // facebook_interstitial_ad_unitId
  static String adMobRewardedAdUnitId = ''; // admob_rewarded_ad_unitId
  static String facebookRewardedAdUnitId = ''; // facebook_rewarded_ad_unitId
  static bool isShowFacebookBannerAds = false; // isShow_facebook_banner_ads
  static bool isShowFacebookInterstitialAd = false; // isShow_facebook_interstitial_ad
  static bool isShowFacebookRewardAd = false; // isShow_facebook_reward_ad
  static bool isProFeatureEnable = false; // isPro_feature_enable
  static int coolDownsTaps = 3; // cool_downs_taps
  static bool isAdFeatureEnable = false; // isAd_feature_enable
  static bool isShowFacebookTestAd = false; // isShow_facebook_test_ad
  static bool isShowButtonAd = false; // isShow_button_ad
  static bool isShowAllAdmobAds = false; // isShow_all_admob_ad
  static int maxFailedLoadAttempts = 1; // max_failed_load_attempts
  static bool isShowAppOpenAd = false; // isShow_app_open_ad
  static int appOpenAdShowDelay = 1500; // app_open_ad_show_delay

  // static int firstCoolDowns = 30;
  // static int secondCoolDowns = 60;

  Future<void> init({
    required String adMobAdOpenId,
    required String adMobBannerId,
    required String faceBookBannerId,
    required String adMobInterstitialAdId,
    required String faceBookInterstitialAdId,
    required String adMobRewardAdId,
    required String facebookRewardAdId,
    required bool proFutureEnable,
    bool isShowFaceBookBannerAd = true,
    bool showFacebookInterstitialAd = true,
    bool showFacebookRewardedAd = true,
    bool adFeatureEnable = true,
    int coolDownsTap = 3,
    bool showFacebookTestAd = false,
    bool showButtonAd = false,
    bool showAllAdmobAds = false,
    int maxFailedLoad = 1,
    bool showAppOpenAd = false,
    int showAppOpenAdDelay = 1500,
    // int? firstCoolDown,
    // int? secondCoolDown,
  }) async {
    adMobAppOpenAdUnitId = adMobAdOpenId;
    adMobBannerAdUnitId = adMobBannerId;
    facebookBannerAdUnitId = faceBookBannerId;
    adMobInterstitialAdUnitId = adMobInterstitialAdId;
    facebookInterstitialAdAdUnitId = faceBookInterstitialAdId;
    adMobRewardedAdUnitId = adMobRewardAdId;
    facebookRewardedAdUnitId = facebookRewardAdId;
    isShowFacebookBannerAds = isShowFaceBookBannerAd;
    isShowFacebookInterstitialAd = showFacebookInterstitialAd;
    isShowFacebookRewardAd = showFacebookRewardedAd;
    isProFeatureEnable = proFutureEnable;
    isProFeatureEnable = proFutureEnable;
    isAdFeatureEnable = adFeatureEnable;
    coolDownsTaps = coolDownsTap;
    isShowFacebookTestAd = showFacebookTestAd;
    isShowButtonAd = showButtonAd;
    isShowAllAdmobAds = showAllAdmobAds;
    maxFailedLoadAttempts = maxFailedLoad;
    isShowAppOpenAd = showAppOpenAd;
    appOpenAdShowDelay = showAppOpenAdDelay;
    // if (firstCoolDown != null) firstCoolDowns = firstCoolDown;
    // if (firstCoolDown != null) secondCoolDowns = firstCoolDown;

    log("AdDetails adMobBannerAdUnitId: $adMobBannerAdUnitId facebookBannerAdUnitId: $facebookBannerAdUnitId");
    MobileAds.instance.initialize();

    /// Test ADS
    if (isShowFacebookTestAd) {
      printLog('!!!!!!!!!!! LOAD TESTING ADS !!!!!!!!!!!!!');
      FacebookAudienceNetwork.init(
        // testingId: "194d0629-c335-4a12-b1b8-95b4a09efa85", // One Plush Nord (Raj) ID
        iOSAdvertiserTrackingEnabled: true,
      );
    }

    /// Load Ads
    if (isAdFeatureEnable) {
      /// App Open Ad
      AppOpenAdUtils.loadAppOpenAd();

      /// Interstitial Ad
      InterstitialAdUtils.loadInterstitialAd();

      /// Rewarded Ad
      if (isProFeatureEnable) {
        RewardedAdUtils.loadRewardAd();
      }
    }
  }
}
