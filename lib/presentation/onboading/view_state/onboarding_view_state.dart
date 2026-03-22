import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/models/remote_config_links.dart';

part 'onboarding_view_state.freezed.dart';

@freezed
abstract class OnboardingViewState with _$OnboardingViewState {
  const factory OnboardingViewState({
    required String version,
    required bool isFirstLaunch,
    required RemoteConfigLinks links,
  }) = _OnboardingViewState;
}
