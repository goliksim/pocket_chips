import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../utils/extensions.dart';
import 'google_banner.dart';

class BannerAdWrapper extends StatelessWidget {
  final Widget child;
  const BannerAdWrapper({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
            child: child,
          ),
          if (!kIsWeb)
            ColoredBox(
              color: context.theme.bgrColor,
              child: GoogleBanner(),
            ),
        ],
      );
}
