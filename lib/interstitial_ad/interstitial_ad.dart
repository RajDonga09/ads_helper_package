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

  static void loadInterstitialAd() async {
    printLog('-----### Load Interstitial Ads ###------');
    if (AdConfig.isShowFacebookInterstitialAd && AdConfig.facebookInterstitialAdAdUnitId.isNotEmpty) {
      _loadFacebookAd();
    } else {
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
            _isFacebookInterstitialAdLoaded = false;
            loadInterstitialAd();
            break;
          case InterstitialAdResult.CLICKED:
            printLog('Facebook InterstitialAd Ad CLICKED:');
            break;
          case InterstitialAdResult.ERROR:
            printLog('Facebook InterstitialAd Ad ERROR: $value');
            _isFacebookInterstitialAdLoaded = false;
            _numFacebookInterstitialLoadAttempts += 1;
            if (_numFacebookInterstitialLoadAttempts <= Constant.maxFailedLoadAttempts) {
              loadInterstitialAd();
            } else {
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
            loadInterstitialAd();
          } else {
            _loadFacebookAd();
          }
        },
      ),
    );
  }

  static showInterstitialAds() {
    if (_currentCoolDownsTap <= 0) {
      if (_adMobInterstitialAd != null) {
        _adMobInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (InterstitialAd ad) {
            printLog('AdMob InterstitialAd Ad onAdShowedFullScreenContent:');
          },
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
            printLog('AdMob InterstitialAd Ad onAdDismissedFullScreenContent:');
            ad.dispose();
            loadInterstitialAd();
          },
          onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
            printLog('AdMob InterstitialAd Ad onAdFailedToShowFullScreenContent: $error');
            ad.dispose();
            loadInterstitialAd();
          },
        );
        _adMobInterstitialAd!.show();
        _adMobInterstitialAd = null;
        _currentCoolDownsTap = AdConfig.coolDownsTaps;
      } else if (_isFacebookInterstitialAdLoaded) {
        FacebookInterstitialAd.showInterstitialAd();
        _currentCoolDownsTap = AdConfig.coolDownsTaps;
      }
    } else {
      _currentCoolDownsTap--;
    }
  }
}
