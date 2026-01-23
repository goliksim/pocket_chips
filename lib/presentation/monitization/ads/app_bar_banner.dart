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
    final isPro = ref.watch(proVersionProvider);

    final manager = GoogleBannersManager(isPro: isPro);

    return Builder(
      builder: (context) => _AppBarBanner(
        manager: manager,
      ),
    );
  }
}

class _AppBarBanner extends StatefulWidget {
  final GoogleBannersManager manager;

  const _AppBarBanner({
    required this.manager,
  });

  @override
  State<_AppBarBanner> createState() => _AppBarBannerState();
}

class _AppBarBannerState extends State<_AppBarBanner> {
  BannerAd? banner;

  late GoogleBannersManager manager;

  @override
  void didUpdateWidget(state) {
    _dispose();
    _init();

    super.didUpdateWidget(state);
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
