library ads_helper;

import 'package:ads_helper/rewarded_ad/rewarded_ad.dart';
import 'package:ads_helper/utils/ad_config.dart';
import 'package:ads_helper/utils/utils.dart';

import 'interstitial_ad/interstitial_ad.dart';

export 'banner_ad/banner_ad.dart';
export 'utils/ad_config.dart';

class AdsHelper {
  void showInterstitialAds() {
    if (AdConfig.isAdFeatureEnable) {
      InterstitialAdUtils.showInterstitialAds();
    } else {
      printLog("Warning: Ads Feature is Disable");
    }
  }

  Future<void> showRewardedAd(Function adShowSuccess) async {
    if (AdConfig.isAdFeatureEnable) {
      await RewardedAdUtils.showRewardedAd(adShowSuccess: adShowSuccess);
    } else {
      printLog("Warning: Ads Feature is Disable");
      adShowSuccess.call();
    }
  }
}
