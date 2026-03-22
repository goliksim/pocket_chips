class AnalyticsEvent {
  final String name;
  final Map<String, Object> parameters;

  const AnalyticsEvent(
    this.name, {
    this.parameters = const {},
  });

  static AnalyticsEvent launchUrl(String url) => AnalyticsEvent(
        'launch_url',
        parameters: {
          'url': url,
        },
      );

  static AnalyticsEvent purchaseAttempt(String productId) => AnalyticsEvent(
        'purchase_attempt',
        parameters: {
          'product_id': productId,
        },
      );

  static AnalyticsEvent purchaseSuccess(String productId) => AnalyticsEvent(
        'purchase_success',
        parameters: {
          'product_id': productId,
        },
      );

  static AnalyticsEvent purchaseRestoreAttempt =
      AnalyticsEvent('purchase_restore_attempt');

  static AnalyticsEvent purchaseRestored(String productId) => AnalyticsEvent(
        'purchase_restored',
        parameters: {
          'product_id': productId,
        },
      );

  static AnalyticsEvent purchaseInvalid(String productId) => AnalyticsEvent(
        'purchase_invalid',
        parameters: {
          'product_id': productId,
        },
      );

  static const AnalyticsEvent adInterstitialShown =
      AnalyticsEvent('ad_interstitial_shown');

  static const AnalyticsEvent adInterstitialFailed =
      AnalyticsEvent('ad_interstitial_failed');
}
