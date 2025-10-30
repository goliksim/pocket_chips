import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

import '../../app/navigation/navigation_manager.dart';
import '../../domain/model_holders/config_model_holder.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/local_path.dart';

class OnboardingViewModel extends ChangeNotifier {
  final ConfigModelHolder _configModelHolder;
  final NavigationManager _navigationManager;
  final AppLocalizations _string;

  String? currentVersion;

  OnboardingViewModel({
    required ConfigModelHolder configModelHolder,
    required NavigationManager navigationManager,
    required AppLocalizations strings,
  })  : _configModelHolder = configModelHolder,
        _navigationManager = navigationManager,
        _string = strings {
    _init();
  }

  bool get isFirstLaunch => _configModelHolder.dataOrNull?.firstLaunch ?? false;

  void onComplete() {
    final currentConfig = _configModelHolder.dataOrNull;

    if (currentConfig != null && currentConfig.firstLaunch) {
      _configModelHolder.updateConfig(
        currentConfig.copyWith(
          firstLaunch: false,
        ),
      );
    }
  }

  Future<void> showUpdateInfo() => _navigationManager.showUpdateDialog();

  Future<void> sendMail() async {
    final path = await localPath;

    final MailOptions mailOptions = MailOptions(
      body: _string.about_link_6,
      subject: 'PC: problem or advice ',
      recipients: ['goliksim@gmail.com'],
      isHTML: true,
      attachments: [
        '$path/pocketchips/poker_chips.log',
      ],
    );

    await FlutterMailer.send(mailOptions);
  }

  //TODO: implement
  void changeTheme() => throw UnimplementedError();

  void setLocale(Locale locale) {
    {
      //TODO: implement changing

      final currentConfig = _configModelHolder.dataOrNull;

      if (currentConfig == null) {
        return;
      }

      _configModelHolder.updateConfig(
        currentConfig.copyWith(
          locale: locale.languageCode,
        ),
      );
    }
  }

  Future<void> _init() async {
    currentVersion = _configModelHolder.dataOrNull?.version ??
        await _configModelHolder.getCurrentVersion();

    notifyListeners();
  }
}
