import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onboarding/onboarding.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/keys/keys.dart';
import '../../../di/view_models.dart';
import '../../../utils/extensions.dart';
import '../onboarding_dialog.dart';
import '../pages/onboarding_game_page.dart';
import '../pages/onboarding_links_page.dart';
import '../pages/onboarding_lobby_page.dart';
import '../pages/onboarding_pro_version_page.dart';
import '../pages/onboarding_settings_page.dart';
import '../pages/onboarding_welcome_page.dart';

class AboutDialog extends StatelessWidget {
  const AboutDialog({
    super.key,
  });

  void _launchUrl(String url) {
    final uri = Uri.parse(url);
    try {
      launchUrl(uri);
    } catch (e) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) => Consumer(
        builder: (context, ref, _) {
          ref.watch(onboardingViewModelProvider);

          final viewModel = ref.watch(onboardingViewModelProvider.notifier);
          final state = ref.watch(onboardingViewModelProvider);

          final title = state.maybeWhen(
            skipLoadingOnReload: true,
            data: (data) => data.isFirstLaunch
                ? '${context.strings.about_welc}\nPOCKET CHIPS'
                : 'POCKET CHIPS',
            orElse: () => '',
          );

          final version = state.maybeWhen(
            data: (data) => data.version,
            orElse: () => null,
          );

          return OnboardingDialog(
            key: OnboardingKeys.aboutDialog,
            closeKey: OnboardingKeys.closeAboutDialogButton,
            onComplete: () => viewModel.onComplete(),
            pages: [
              PageModel(
                widget: OnboardingWelcomePage(
                  title: title,
                  setLocale: viewModel.setLocale,
                ),
              ),
              PageModel(
                widget: OnboardingProVersionPage(),
              ),

              PageModel(
                widget: OnboardingLobbyPage(),
              ),
              // Settings
              PageModel(
                widget: OnboardingSettingsPage(),
              ),
              // Game table
              PageModel(
                widget: OnboardingGamePage(),
              ),
              // Helpful
              PageModel(
                widget: OnboardingLinksPage(
                  launchUrl: _launchUrl,
                  sendMail: viewModel.sendMail,
                  showUpdateInfo: viewModel.showUpdateInfo,
                  version: version,
                ),
              ),
            ],
          );
        },
      );
}
