import 'package:flutter/material.dart';

import '../../../services/assets_provider.dart';
import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../../game/view_state/game_player_item.dart';
import '../../game/widgets/game_contol/raise/raise_field.dart';
import '../../game/widgets/game_contol/raise/raise_provider.dart';
import '../../game/widgets/game_table/player_field.dart';
import '../onboarding_dialog.dart';

class OnboardingGamePage extends StatefulWidget {
  const OnboardingGamePage({
    super.key,
  });

  @override
  State<OnboardingGamePage> createState() => _OnboardingGamePageState();
}

class _OnboardingGamePageState extends State<OnboardingGamePage> {
  bool isPaused = false;

  GamePlayerItem get _player => GamePlayerItem(
        uid: '',
        name: 'Example',
        assetUrl: AssetsProvider.emptyPlayerAsset,
        isDealer: false,
        isCurrent: false,
        isFolded: false,
        isSitOut: isPaused,
        bank: 500,
        bet: 500,
        ante: 500,
      );

  void _pausePlayer() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  @override
  Widget build(BuildContext context) => OnboardingPage(
        title: context.strings.about_tab_1,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  context.strings.about_tab_2,
                  style: TextStyle(
                    height: 1.5,
                    color: context.theme.onBackground,
                    fontWeight: FontWeight.w500,
                    fontSize: stdFontSize * 0.7,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                width: stdButtonHeight * 0.8,
                height: stdButtonHeight * 0.8,
                child: Icon(
                  Icons.sync_sharp,
                  size: stdIconSize,
                  color: context.theme.onBackground,
                ),
              ),
            ],
          ),
          SizedBox(height: stdHorizontalOffset),
          Row(
            children: [
              Flexible(
                child: Text(
                  context.strings.about_tab_5,
                  style: TextStyle(
                    height: 1.5,
                    color: context.theme.onBackground,
                    fontWeight: FontWeight.w500,
                    fontSize: stdFontSize * 0.7,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: stdButtonHeight * 0.6,
                width: stdButtonHeight * 1.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(stdButtonHeight),
                  child: PlayerField(
                    player: _player,
                    shouldReverse: false,
                    onLongPress: () => _pausePlayer(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: stdHorizontalOffset),
          Text(
            context.strings.about_tab_3,
            style: TextStyle(
              height: 1.5,
              color: context.theme.onBackground,
              fontWeight: FontWeight.w500,
              fontSize: stdFontSize * 0.7,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: stdHorizontalOffset),
          RaiseProviderScope(
            additionalBet: 0,
            child: Builder(
              builder: (context) => RaiseFieldWidget(
                maxPossibleBet: 500,
                minPossibleBet: 0,
                minRuleBet: 100,
                currentBet: 0,
              ),
            ),
          ),
          Text(
            '${context.strings.about_tab_4}\n',
            style: TextStyle(
              height: 1.5,
              color: context.theme.onBackground,
              fontWeight: FontWeight.w500,
              fontSize: stdFontSize * 0.7,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      );
}
