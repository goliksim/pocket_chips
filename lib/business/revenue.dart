

enum Stores{appleStore, googlePlay}

class StoreConfig {
  final Stores store;
  final String apiKey;
  static StoreConfig? _instance;

  factory StoreConfig({required Stores store, required String apiKey}) {
    _instance ??= StoreConfig._internal(store, apiKey);
    return _instance!;
  }

  StoreConfig._internal(this.store, this.apiKey);

  static StoreConfig get instance {
    return _instance!;
  }

  static bool isForAppleStore() => _instance!.store == Stores.appleStore;

  static bool isForGooglePlay() => _instance!.store == Stores.googlePlay;

}

//TO DO: add the Apple API key for your app from the RevenueCat dashboard: https://app.revenuecat.com
const String appleApiKey = 'appl_api_key';

//TO DO: add the Google API key for your app from the RevenueCat dashboard: https://app.revenuecat.com
const String googleApiKey = 'google_api_key';



