import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';

class AdCreator {

  //test ca-app-pub-3940256099942544/6300978111 : ca-app-pub-3940256099942544/2934735716
  //real ca-app-pub-5242916624413241/7530490132 : ca-app-pub-5242916624413241/1236544523
  static String get bannerAdUnitId => GetPlatform.isAndroid ?
  'ca-app-pub-3940256099942544/6300978111': 'ca-app-pub-3940256099942544/2934735716';

  //test ca-app-pub-3940256099942544/1033173712 : ca-app-pub-3940256099942544/4411468910
  //real ca-app-pub-5242916624413241/3451466710 : ca-app-pub-5242916624413241/3259895026
  static String get interstitialAdUnitId => GetPlatform.isAndroid ?
  'ca-app-pub-3940256099942544/1033173712': 'ca-app-pub-3940256099942544/4411468910';

  static InterstitialAd? interstitialAd;

  static BannerAd getBannerAd(){
    BannerAd bannerAd = BannerAd(size: AdSize.banner, adUnitId: bannerAdUnitId , listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) => ad.dispose(),
    ), request: const AdRequest());
    return bannerAd;
  }

  static void initialize() async {
    await MobileAds.instance.initialize();
  }

  static void createInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback:InterstitialAdLoadCallback(
          onAdLoaded: (ad) => interstitialAd = ad,
          onAdFailedToLoad: (LoadAdError error) => interstitialAd = null,
      ),
    );
  }
// show interstitial ads to user
  static void showInterstitialAd(){
    if(interstitialAd == null) return;
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) => ad.dispose(),
        onAdFailedToShowFullScreenContent: (ad, error) => ad.dispose()
    );
    interstitialAd!.show();
    interstitialAd = null;
  }
}