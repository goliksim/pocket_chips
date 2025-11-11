import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../services/assets_provider.dart';
import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../../lobby/player_list/view_state/lobby_player_item.dart';
import '../../lobby/player_list/widgets/player_card.dart';
import '../onboarding_dialog.dart';

class OnboardingLobbyPage extends StatelessWidget {
  const OnboardingLobbyPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    LobbyPlayerItem tutorPlayer = LobbyPlayerItem(
      name: 'TestPlayer',
      assetUrl: AssetsProvider.emptyPlayerAsset,
      bank: 500,
      uid: Uuid().v4(),
    );

    return OnboardingPage(
      title: context.strings.about_plme_1,
      children: [
        Text(
          context.strings.about_plme_2,
          style: TextStyle(
            height: 1.5,
            color: context.theme.onBackground,
            fontWeight: FontWeight.w500,
            fontSize: stdFontSize * 0.7,
          ),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: stdHorizontalOffset),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(stdBorderRadius),
            border: BoxBorder.all(
              color: context.theme.primaryColor,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(stdBorderRadius),
            ),
            child: PlayerCard(
              player: tutorPlayer,
              canReorderOrDismiss: true,
              rightCallback: () async => false,
              leftCallback: () async => false,
            ),
          ),
        ),
        SizedBox(
          height: stdHorizontalOffset,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '- ${context.strings.about_plme_3}',
            style: TextStyle(
              height: 1.5,
              color: context.theme.onBackground,
              fontWeight: FontWeight.w500,
              fontSize: stdFontSize * 0.7,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        Row(
          children: [
            Flexible(
              child: Text(
                '- ${context.strings.about_plme_4}\n${context.strings.about_plme_5}',
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
              height: stdButtonHeight * 0.6,
              child: Icon(
                Icons.folder_shared,
                size: stdIconSize,
                color: context.theme.onBackground,
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '\n- ${context.strings.about_plme_6}\n\n- ${context.strings.about_plme_7}\n',
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
    );
  }
}
