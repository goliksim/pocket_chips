import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/navigation/navigation_manager.dart';
import '../../di/domain_managers.dart';
import '../../di/model_holders.dart';
import '../../domain/model_holders/config_model_holder.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/local_path.dart';
import 'view_state/onboarding_view_state.dart';

class OnboardingViewModel extends AsyncNotifier<OnboardingViewState> {
  ConfigModelHolder get _configModelHolder =>
      ref.read(configModelHolderProvider.notifier);
  NavigationManager get _navigationManager =>
      ref.read(navigationManagerProvider);
  AppLocalizations get _strings => ref.watch(stringsProvider);

  AsyncValue<OnboardingViewState> get stateModel => state;

  @override
  FutureOr<OnboardingViewState> build() async {
    final config = await ref.watch(configModelHolderProvider.future);

    log('OnboardingViewState');

    return OnboardingViewState(
      isFirstLaunch: config.firstLaunch,
      version: config.version,
    );
  }

  void onComplete() {
    final isFirstLaunch = stateModel.requireValue.isFirstLaunch;

    if (isFirstLaunch) {
      _configModelHolder.setFirstLaunch();
    }
  }

  Future<void> showUpdateInfo() => _navigationManager.showUpdateDialog();

  Future<void> sendMail() async {
    final path = await localPath;

    final MailOptions mailOptions = MailOptions(
      body: _strings.about_link_6,
      subject: 'PC: problem or advice ',
      recipients: ['goliksim@gmail.com'],
      isHTML: true,
      attachments: [
        '$path/pocketchips/poker_chips.log',
      ],
    );

    await FlutterMailer.send(mailOptions);
  }

  void changeTheme() => ref.read(themeManagerProvider.notifier).changeTheme();

  void setLocale(Locale locale) {
    {
      _configModelHolder.changeLocale(
        locale.languageCode,
      );
    }
  }
}
