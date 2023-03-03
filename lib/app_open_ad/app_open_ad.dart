import 'package:ads_helper/utils/ad_config.dart';
import 'package:ads_helper/utils/constants.dart';
import 'package:ads_helper/utils/utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdUtils {
  static final AppOpenAdUtils _interstitialAdUtils = AppOpenAdUtils._init();

  factory AppOpenAdUtils() {
    return _interstitialAdUtils;
  }

  AppOpenAdUtils._init();

  static AppOpenAd? _appOpenAd;
  static int _numAdmobAppOpenLoadAttempts = 0;

  static void loadAppOpenAd() async {
    printLog('-----### Load AppOpen Ads ###------');
    if (AdConfig.isShowAppOpenAd && AdConfig.adMobAppOpenAdUnitId.isNotEmpty) {
      _loadAppOpenAd();
    }
  }

  static _loadAppOpenAd() {
    if (_appOpenAd != null) {
      return;
    }

    printLog('------ AdMob AppOpen Ad LOADING ------');

    AppOpenAd.load(
      adUnitId: AdConfig.adMobAppOpenAdUnitId,
      orientation: AppOpenAd.orientationPortrait,
      request: Constant.request,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          printLog('AdMob AppOpenAd Ad onAdLoaded:');
          _appOpenAd = ad;
          _numAdmobAppOpenLoadAttempts = 0;
          if (_appOpenAd != null) _appOpenAd!.show();
        },
        onAdFailedToLoad: (error) {
          printLog('AdMob AppOpenAd Ad onAdFailedToLoad:');
          _numAdmobAppOpenLoadAttempts++;
          _appOpenAd = null;
          if (_numAdmobAppOpenLoadAttempts < AdConfig.maxFailedLoadAttempts) {
            _loadAppOpenAd();
          }
        },
      ),
    );
  }
}
