import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../di/domain_managers.dart';

class GoogleBanner extends ConsumerWidget {
  const GoogleBanner({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adAsync = ref.watch(currentBannerProvider);

    return adAsync.maybeWhen(
      data: (banner) {
        if (banner == null) return const SizedBox.shrink();

        return SizedBox(
          width: banner.size.width.w,
          height: banner.size.height.h,
          child: AdWidget(
            key: ObjectKey(banner),
            ad: banner,
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
