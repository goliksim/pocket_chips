import 'package:flutter/material.dart';

import '../../../app/keys/keys.dart';
import '../../../domain/models/game/blind_level_model.dart';
import '../../../l10n/localization_extension.dart';
import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../view_state/game_table_state.dart';

class GameProgressionWidget extends StatelessWidget {
  final GameTableState tableState;

  const GameProgressionWidget({required this.tableState, super.key});

  @override
  Widget build(BuildContext context) {
    final blinds = context.strings.blindsValueLabel(tableState.smallBlindValue);
    final ante = context.strings
        .anteValueLabel(tableState.anteValue, tableState.anteType);

    final String? progressionText;
    final progressionLevel =
        '${context.strings.sett_level_full} ${tableState.progressionLevel}';

    progressionText = tableState.showProgression
        ? context.strings.progressionLeftLabel(tableState.progressionType)
        : null;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            key: GameKeys.progressionWidget,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: context.theme.bgrColor,
              borderRadius: BorderRadius.circular(stdBorderRadius),
              border: Border.all(
                color: context.theme.primaryColor,
                width: 1.5,
              ),
            ),
            padding: EdgeInsets.all(stdHorizontalOffset),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Small/Big Blinds
                Padding(
                  padding: EdgeInsets.only(bottom: stdHorizontalOffset / 4),
                  child: Text(
                    tableState.showProgression
                        ? progressionLevel
                        : context.strings.game_progression_setup,
                    key: tableState.showProgression
                        ? GameKeys.progressionLevel(
                            tableState.progressionLevel ?? 0)
                        : GameKeys.progressionSetupLabel,
                    style: TextStyle(
                      color: context.theme.primaryColor.withAlpha(200),
                      fontSize: stdFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: stdButtonHeight * 0.75,
                  child: VerticalDivider(
                    color: context.theme.primaryColor,
                    width: stdHorizontalOffset * 3,
                    thickness: 1,
                  ),
                ),

                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Blinds info))
                      _ProgressionItem(
                        title: context.strings.sett_level_blind,
                        value: blinds,
                        key: GameKeys.blinds(tableState.smallBlindValue),
                      ),
                      // Ante info
                      if (tableState.anteType != AnteType.none) ...[
                        Divider(
                          height: stdHorizontalOffset,
                          indent: stdHorizontalOffset,
                          endIndent: stdHorizontalOffset,
                        ),
                        _ProgressionItem(
                          title: context.strings.sett_level_ante,
                          value: ante,
                        ),
                      ],
                      // Progression info
                      if (progressionText != null &&
                          tableState.leftInterval != null) ...[
                        Divider(
                          height: stdHorizontalOffset,
                          indent: stdHorizontalOffset,
                          endIndent: stdHorizontalOffset,
                        ),
                        _ProgressionItem(
                          title: progressionText,
                          value: '${tableState.leftInterval}',
                          valueKey: GameKeys.progressionIntervalValue(
                            tableState.leftInterval!,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressionItem extends StatelessWidget {
  final String? title;
  final String value;
  final Key? valueKey;

  const _ProgressionItem({
    required this.value,
    this.title,
    this.valueKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (title != null)
            Text(
              title!,
              style: TextStyle(
                color: context.theme.onBackground,
                fontSize: stdFontSize * 0.8,
              ),
            ),
          SizedBox(width: stdHorizontalOffset),
          Flexible(
            child: Text(
              key: valueKey,
              value,
              style: TextStyle(
                color: context.theme.primaryColor,
                fontSize: stdFontSize * 0.8,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      );
}
