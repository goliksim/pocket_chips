import 'package:flutter/widgets.dart';

/// Keys for the main Onboarding flow.
class OnboardingKeys {
  static const Key updateDialog = Key('updateDialog');
  static const Key aboutDialog = Key('aboutDialog');

  static const Key skipButton = Key('skipButton');

  static const Key showUpdateDialogButton = Key('showUpdateDialogButton');

  static const Key closeUpdateDialogButton = Key('closeUpdateDialogButton');
  static const Key closeAboutDialogButton = Key('closeAboutDialogButton');
}

/// Keys for the main Home Page.
class HomeKeys {
  static const Key page = Key('homePage');

  static const Key helpButton = Key('aboutButton');
}

class ProVersionKeys {
  static const Key proVersionBlockWrapper = Key('proVersionBlockWrapper');

  static const Key proVersionPurshasedButton = Key('proVersionPurshasedButton');
  static const Key proVersionAvailableButton = Key('proVersionAvailableButton');
  static const Key proVersionNotAvailableButton =
      Key('proVersionNotAvailableButton');
}
