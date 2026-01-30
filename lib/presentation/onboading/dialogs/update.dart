import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onboarding/onboarding.dart';

import '../../../app/keys/keys.dart';
import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
//import 'package:in_app_review/in_app_review.dart';

import '../onboarding_dialog.dart';
import '../onboarding_view_model.dart';

/// Screen with patchnote info
class UpdateDialog extends StatelessWidget {
  final OnboardingViewModel viewModel;

  const UpdateDialog({
    required this.viewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final version = viewModel.stateModel.maybeWhen(
      data: (data) => data.version,
      orElse: () => null,
    );

    return OnboardingDialog(
      key: OnboardingKeys.updateDialog,
      closeKey: OnboardingKeys.closeUpdateDialogButton,
      onComplete: () => viewModel.onComplete(),
      pages: [
        PageModel(
          widget: OnboardingPage(
            title: '${context.strings.update_title} $version',
            children: [
              SizedBox(height: stdHorizontalOffset),
              _PatchNoteItem(
                text: context.strings.update_1,
                icon: Icons.build,
              ),
              _PatchNoteItem(
                text: context.strings.update_2,
                icon: Icons.monetization_on,
              ),
              _PatchNoteItem(
                text: context.strings.update_3,
                icon: Icons.photo,
              ),
              _PatchNoteItem(
                text: context.strings.update_4,
                icon: Icons.restore,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PatchNoteItem extends StatelessWidget {
  final String text;
  final IconData icon;

  const _PatchNoteItem({
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: stdHorizontalOffset),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: context.theme.primaryColor,
              size: stdIconSize,
            ),
            SizedBox(width: stdHorizontalOffset * 1.5),
            Flexible(
              child: Text(
                text,
                maxLines: null,
                style: TextStyle(
                  height: 1.5,
                  color: context.theme.onBackground,
                  fontWeight: FontWeight.w500,
                  fontSize: stdFontSize * 0.7,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      );
}
