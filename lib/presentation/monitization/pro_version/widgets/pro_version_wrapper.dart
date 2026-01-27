import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../di/domain_managers.dart';
import '../../../../di/model_holders.dart';
import '../../../../utils/extensions.dart';
import '../../../../utils/theme/ui_values.dart';

class ProVersionWrapper extends ConsumerWidget {
  final Widget child;
  final double? offset;
  final bool? conditionToEnable;

  const ProVersionWrapper({
    required this.child,
    this.conditionToEnable,
    this.offset,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPro =
        ref.watch(proVersionOfferModelHolderProvider).value?.isPurchased ??
            false;

    if (isPro || (conditionToEnable ?? false)) {
      return child;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Opacity(
          opacity: isPro ? 1.0 : 0.6,
          child: child,
        ),
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              ref.read(navigationManagerProvider).showProVersionOfferDialog();
            },
          ),
        ),
        Positioned(
          top: offset ?? 0,
          right: offset ?? 0,
          child: IgnorePointer(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: stdHorizontalOffset / 2,
                vertical: stdHorizontalOffset / 4,
              ),
              decoration: BoxDecoration(
                color: context.theme.additionButtonColor,
                borderRadius: BorderRadius.circular(stdBorderRadius / 2),
              ),
              child: Text(
                'PRO',
                style: TextStyle(
                  color: context.theme.onPrimary,
                  fontSize: stdFontSize * 0.6,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
