import 'package:ads_helper/utils/ad_config.dart';
import 'package:ads_helper/utils/constants.dart';
import 'package:ads_helper/utils/utils.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdUtils {
  static final RewardedAdUtils _rewardedAdUtils = RewardedAdUtils._init();

  factory RewardedAdUtils() {
    return _rewardedAdUtils;
  }

  RewardedAdUtils._init();

  static RewardedAd? _rewardAd;
  static int _numAdmobRewardedAdLoadAttempts = 0;
  static int _numFacebookRewardedAdLoadAttempts = 0;
  static bool _isFacebookRewardedAdLoaded = false;
  static Function? _adShowSuccess;

  static void loadRewardAd() async {
    printLog('-----### Load Reward Ads ###------');
    if (AdConfig.isShowFacebookRewardAd && AdConfig.facebookRewardedAdUnitId.isNotEmpty) {
      _loadFacebookRewardedAd();
    } else if (AdConfig.isShowAllAdmobAds) {
      _loadAdmobRewardedAd();
    }
  }

  static _loadFacebookRewardedAd() {
    if (!AdConfig.isProFeatureEnable) {
      printLog('Pro Feature is Disable');
      return;
    }

    printLog('----- Facebook Reward Ads Loading ------');
    FacebookRewardedVideoAd.loadRewardedVideoAd(
      placementId: AdConfig.facebookRewardedAdUnitId,
      listener: (result, value) {
        switch (result) {
          case RewardedVideoAdResult.LOADED:
            printLog('Facebook Reward Ad LOADED:');
            _isFacebookRewardedAdLoaded = true;
            _numFacebookRewardedAdLoadAttempts = 0;
            break;
          case RewardedVideoAdResult.VIDEO_COMPLETE:
            printLog('Facebook Reward Ad VIDEO_COMPLETE:');
            break;
          case RewardedVideoAdResult.VIDEO_CLOSED:
            printLog('Facebook Reward Ad VIDEO_CLOSED:');
            _adShowSuccess?.call();
            if ((value == true || value["invalidated"] == true)) {
              _isFacebookRewardedAdLoaded = false;
              _loadFacebookRewardedAd();
            }
            break;
          case RewardedVideoAdResult.CLICKED:
            printLog('Facebook Reward Ad CLICKED:');
            break;
          case RewardedVideoAdResult.ERROR:
            printLog('Facebook Reward Ad ERROR: $value');
            _isFacebookRewardedAdLoaded = false;
            _numFacebookRewardedAdLoadAttempts += 1;
            if (_numFacebookRewardedAdLoadAttempts <= Constant.maxFailedLoadAttempts) {
              _loadFacebookRewardedAd();
            } else if (AdConfig.isShowAllAdmobAds && _numAdmobRewardedAdLoadAttempts <= Constant.maxFailedLoadAttempts) {
              _loadAdmobRewardedAd();
            }
            break;
          default:
        }
      },
    );
  }

  static _loadAdmobRewardedAd() {
    if (!AdConfig.isProFeatureEnable) {
      printLog('Pro Feature is Disable');
      return;
    }

    printLog('----- Admob Rewarded Ads Loading------');
    RewardedAd.load(
      adUnitId: AdConfig.adMobRewardedAdUnitId,
      request: Constant.request,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          printLog('AdMob Rewarded onAdLoaded:');
          _rewardAd = ad;
          _numAdmobRewardedAdLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          printLog('AdMob Rewarded onAdFailedToLoad: $error');
          _numAdmobRewardedAdLoadAttempts += 1;
          _rewardAd = null;
          if (_numAdmobRewardedAdLoadAttempts <= Constant.maxFailedLoadAttempts) {
            _loadAdmobRewardedAd();
          } else if (_numFacebookRewardedAdLoadAttempts <= Constant.maxFailedLoadAttempts) {
            _loadFacebookRewardedAd();
          }
        },
      ),
    );
  }

  static Future<void> showRewardedAd({required Function adShowSuccess}) async {
    _adShowSuccess = adShowSuccess;
    if (!AdConfig.isProFeatureEnable) {
      printLog('Pro Feature is Disable');
      return;
    }
    if (_rewardAd != null) {
      _rewardAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedAd ad) {
          printLog('AdMob Rewarded onAdShowedFullScreenContent:');
        },
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          printLog('AdMob Rewarded onAdDismissedFullScreenContent:');
          ad.dispose();
          _loadAdmobRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) async {
          printLog('AdMob Rewarded onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
          _loadAdmobRewardedAd();
        },
      );

      _rewardAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        _adShowSuccess?.call();
        printLog('AdMob Rewarded onAdDismissedFullScreenContent: $RewardItem(${reward.amount}, ${reward.type}');
      });
      _rewardAd = null;
    } else if (_isFacebookRewardedAdLoaded) {
      FacebookRewardedVideoAd.showRewardedVideoAd();
    } else {
      _adShowSuccess?.call();
      printLog("!!!!!!!!!!!!! Rewarded Ad not yet loaded!");
    }
  }
}
