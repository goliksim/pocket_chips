part of '../game_settings_dialog.dart';

class _ProSettingsSection extends StatelessWidget {
  final BlindProgressionType progressionType;
  final String progressionIntervalHint;
  final TextEditingController progressionIntervalController;
  final TextEditingController levelsCountController;
  final String levelsCountHint;
  final List<BlindLevelModel> levels;

  final ValueChanged<BlindProgressionType?> onProgressionTypeChanged;
  final ValueChanged<String> onLevelsCountChanged;
  final void Function(int index, BlindLevelModel level) onLevelChanged;
  final int? expandedLevelIndex;
  final void Function(int index, bool isExpanded) onLevelExpansionChanged;

  const _ProSettingsSection({
    required this.progressionType,
    required this.progressionIntervalHint,
    required this.progressionIntervalController,
    required this.levelsCountController,
    required this.levelsCountHint,
    required this.levels,
    required this.onProgressionTypeChanged,
    required this.onLevelsCountChanged,
    required this.onLevelChanged,
    required this.expandedLevelIndex,
    required this.onLevelExpansionChanged,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: stdHorizontalOffset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: stdHorizontalOffset / 2,
          children: [
            _SettingsDropdownField<BlindProgressionType>(
              label: context.strings.sett_progression,
              value: progressionType,
              values: BlindProgressionType.values,
              labelBuilder: context.strings.progressionLabel,
              onChanged: onProgressionTypeChanged,
              fontSizeMultiplier: 0.9,
              dropdownFontSizeMultiplier: 0.85,
              widthMultiplier: 0.83,
            ),
            if (progressionType != BlindProgressionType.manual)
              Divider(
                color: context.theme.bgrColor,
                indent: stdHorizontalOffset * 2,
                endIndent: stdHorizontalOffset * 2,
                height: stdHorizontalOffset,
                thickness: 2,
              ),
            if (progressionType == BlindProgressionType.everyNHands)
              _SettingsNumericField(
                fieldKey: const ValueKey('progression_interval_hands_field'),
                label: context.strings.sett_progression_hands_interval,
                initialValue: progressionIntervalHint,
                controller: progressionIntervalController,
                fontSizeMultiplier: 0.9,
                maxValue: 100,
                onChanged: (_) {},
              ),
            if (progressionType == BlindProgressionType.everyNMinutes)
              _SettingsNumericField(
                fieldKey: const ValueKey('progression_interval_minutes_field'),
                label: context.strings.sett_progression_minutes_interval,
                initialValue: progressionIntervalHint,
                controller: progressionIntervalController,
                fontSizeMultiplier: 0.9,
                maxValue: 120,
                onChanged: (_) {},
              ),
            Divider(
              color: context.theme.bgrColor,
              height: stdHorizontalOffset,
              thickness: 2,
            ),
            _SettingsNumericField(
              fieldKey: const ValueKey('levels_count_field'),
              label: context.strings.sett_levels_count,
              initialValue: levelsCountHint,
              controller: levelsCountController,
              onChanged: onLevelsCountChanged,
              fontSizeMultiplier: 0.9,
              allowZero: false,
              maxValue: 20,
            ),
            SizedBox(height: stdHorizontalOffset / 2),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: List<Widget>.generate(
                    levels.length,
                    (index) => _SettingsLevelCard(
                      index: index,
                      level: levels[index],
                      isExpanded: expandedLevelIndex == index,
                      onExpansionChanged: (isExpanded) =>
                          onLevelExpansionChanged(index, isExpanded),
                      onLevelChanged: (level) => onLevelChanged(index, level),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
