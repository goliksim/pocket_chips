import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../di/domain_managers.dart';
import '../../../services/monitization/video_ads/google_banner_manager.dart';
import '../../../utils/logs.dart';

class AppBarBanner extends ConsumerWidget {
  const AppBarBanner({super.key});

  @override
  Widget build(BuildContext context, ref) {
    if (kIsWeb) {
      // Todo add ad to web
      return SizedBox.shrink();
    }

    final isPro = ref.watch(proVersionProvider);
    final manager = GoogleBannersManager(isPro: isPro);

    return Builder(
      builder: (context) => _GoogleBanner(
        manager: manager,
      ),
    );
  }
}

class _GoogleBanner extends StatefulWidget {
  final GoogleBannersManager manager;

  const _GoogleBanner({
    required this.manager,
  });

  @override
  State<_GoogleBanner> createState() => _GoogleBannerState();
}

class _GoogleBannerState extends State<_GoogleBanner> {
  BannerAd? banner;

  late GoogleBannersManager manager;

  @override
  void didUpdateWidget(covariant _GoogleBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.manager != oldWidget.manager) {
      _dispose();
      _init();
    }
  }

  @override
  void initState() {
    _init();

    super.initState();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _init() {
    manager = widget.manager;

    manager.addListener(_updateBanner);

    banner = manager.bannerAd;
  }

  void _dispose() {
    banner?.dispose();

    manager
      ..removeListener(_updateBanner)
      ..dispose();
  }

  void _updateBanner() {
    setState(() {
      banner = manager.bannerAd;
      logs.writeLog("Banner updating ${banner?.responseInfo?.responseId}");
    });
  }

  @override
  Widget build(BuildContext context) => (banner != null)
      ? SizedBox(
          width: banner!.size.width.w,
          height: banner!.size.height.h,
          child: AdWidget(ad: banner!),
        )
      : SizedBox.shrink();
}
