import 'package:ads_helper/utils/ad_config.dart';
import 'package:ads_helper/utils/constants.dart';
import 'package:ads_helper/utils/utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdUtils {
  static final RewardedAdUtils _rewardedAdUtils = RewardedAdUtils._init();

  factory RewardedAdUtils() {
    return _rewardedAdUtils;
  }

  RewardedAdUtils._init();

  static late RewardedAd? _rewardAd;
  static int _numRewardedAdLoadAttempts = 0;

  static loadRewardedAd() {
    if (!AdConfig.isProFeatureEnable) {
      printLog('AdMob Rewarded Pro Feature is Disable');
      return;
    }
    printLog('-----### Load Rewarded Ads ###------');
    RewardedAd.load(
      adUnitId: AdConfig.adMobRewardedAdUnitId,
      // adUnitId: RewardedAd.testAdUnitId,
      request: Constant.request,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          printLog('AdMob Rewarded onAdLoaded:');
          _rewardAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          printLog('AdMob Rewarded onAdFailedToLoad: $error');
          _numRewardedAdLoadAttempts += 1;
          _rewardAd = null;
          if (_numRewardedAdLoadAttempts <= Constant.maxFailedLoadAttempts) {
            loadRewardedAd();
          }
        },
      ),
    );
  }

  static Future<void> showRewardedAd({required Function adShowSuccess}) async {
    if (!AdConfig.isProFeatureEnable) {
      printLog('AdMob Rewarded Pro Feature is Disable');
      return;
    }

    if (_rewardAd == null) {
      printLog('AdMob Rewarded Warning: attempt to show rewarded before loaded.');
      return;
    }

    _rewardAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        printLog('AdMob Rewarded onAdShowedFullScreenContent:');
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        printLog('AdMob Rewarded onAdDismissedFullScreenContent:');
        ad.dispose();
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) async {
        printLog('AdMob Rewarded onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        loadRewardedAd();
      },
    );

    _rewardAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      adShowSuccess.call();
      printLog('AdMob Rewarded onAdDismissedFullScreenContent: $RewardItem(${reward.amount}, ${reward.type}');
    });
    _rewardAd = null;
  }
}
