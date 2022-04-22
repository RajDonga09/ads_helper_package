import 'package:ads_helper/utils/ad_config.dart';
import 'package:ads_helper/utils/constants.dart';
import 'package:ads_helper/utils/utils.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdUtils {
  static final InterstitialAdUtils _interstitialAdUtils = InterstitialAdUtils._init();

  factory InterstitialAdUtils() {
    return _interstitialAdUtils;
  }

  InterstitialAdUtils._init();

  static InterstitialAd? _adMobInterstitialAd;
  static bool _isFacebookInterstitialAdLoaded = false;
  static int _numAdmobInterstitialLoadAttempts = 0;
  static int _numFacebookInterstitialLoadAttempts = 0;
  static int _currentCoolDownsTap = 0;
  static Function()? adClose;

  static void loadInterstitialAd() async {
    printLog('-----### Load Interstitial Ads ###------');
    if (AdConfig.isShowFacebookInterstitialAd && AdConfig.facebookInterstitialAdAdUnitId.isNotEmpty) {
      _loadFacebookAd();
    } else if (AdConfig.isShowAllAdmobAds) {
      _loadAdMobAd();
    }
  }

  static _loadFacebookAd() {
    if (_isFacebookInterstitialAdLoaded) {
      return;
    }

    printLog('------ Facebook InterstitialAd Ad LOADING ------');

    FacebookInterstitialAd.loadInterstitialAd(
      placementId: AdConfig.facebookInterstitialAdAdUnitId,
      listener: (result, value) {
        switch (result) {
          case InterstitialAdResult.LOADED:
            printLog('Facebook InterstitialAd Ad LOADED:');
            _isFacebookInterstitialAdLoaded = true;
            break;
          case InterstitialAdResult.DISPLAYED:
            printLog('Facebook InterstitialAd Ad DISPLAYED:');
            break;
          case InterstitialAdResult.DISMISSED:
            printLog('Facebook InterstitialAd Ad DISMISSED:');
            if (adClose != null) {
              adClose!.call();
            }
            _isFacebookInterstitialAdLoaded = false;
            _loadFacebookAd();
            break;
          case InterstitialAdResult.CLICKED:
            printLog('Facebook InterstitialAd Ad CLICKED:');
            break;
          case InterstitialAdResult.ERROR:
            printLog('Facebook InterstitialAd Ad ERROR: $value');
            if (adClose != null) {
              adClose!.call();
            }
            _isFacebookInterstitialAdLoaded = false;
            _numFacebookInterstitialLoadAttempts += 1;
            if (_numFacebookInterstitialLoadAttempts <= Constant.maxFailedLoadAttempts) {
              _loadFacebookAd();
            } else if (AdConfig.isShowAllAdmobAds && _numAdmobInterstitialLoadAttempts <= Constant.maxFailedLoadAttempts) {
              _loadAdMobAd();
            }
            break;
          default:
        }
      },
    );
  }

  static _loadAdMobAd() {
    if (_adMobInterstitialAd != null) {
      return;
    }

    printLog('------ AdMob InterstitialAd Ad LOADING ------');

    InterstitialAd.load(
      adUnitId: AdConfig.adMobInterstitialAdUnitId,
      request: Constant.request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          printLog('AdMob InterstitialAd Ad onAdLoaded:');
          _adMobInterstitialAd = ad;
          _numAdmobInterstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          printLog('AdMob InterstitialAd Ad onAdFailedToLoad:');
          _numAdmobInterstitialLoadAttempts += 1;
          _adMobInterstitialAd = null;
          if (_numAdmobInterstitialLoadAttempts <= Constant.maxFailedLoadAttempts) {
            _loadAdMobAd();
          } else if (_numFacebookInterstitialLoadAttempts <= Constant.maxFailedLoadAttempts) {
            _loadFacebookAd();
          }
        },
      ),
    );
  }

  static showInterstitialAds({Function()? adCloseEvent}) {
    adClose = adCloseEvent;
    if (_currentCoolDownsTap <= 0 || adClose != null) {
      if (_adMobInterstitialAd != null) {
        _adMobInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (InterstitialAd ad) {
            printLog('AdMob InterstitialAd Ad onAdShowedFullScreenContent:');
          },
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
            printLog('AdMob InterstitialAd Ad onAdDismissedFullScreenContent:');
            if (adClose != null) {
              adClose!.call();
            }
            ad.dispose();
            _loadAdMobAd();
          },
          onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
            printLog('AdMob InterstitialAd Ad onAdFailedToShowFullScreenContent: $error');
            if (adClose != null) {
              adClose!.call();
            }
            ad.dispose();
            _loadAdMobAd();
          },
        );
        _adMobInterstitialAd!.show();
        _adMobInterstitialAd = null;
        _currentCoolDownsTap = AdConfig.coolDownsTaps;
      } else if (_isFacebookInterstitialAdLoaded) {
        FacebookInterstitialAd.showInterstitialAd();
        _currentCoolDownsTap = AdConfig.coolDownsTaps;
      } else {
        if (adClose != null) {
          adClose!.call();
        }
      }
    } else {
      _currentCoolDownsTap--;
    }
  }
}
