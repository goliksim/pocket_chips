part of '../game_settings_dialog.dart';

class _ProSettingsSection extends StatelessWidget {
  final BlindProgressionType progressionType;
  final String progressionIntervalHint;
  final TextEditingController progressionIntervalController;
  final TextEditingController levelsCountController;
  final String levelsCountHint;
  final List<BlindLevelModel> levels;

  final String Function(AnteType value) anteTypeLabel;
  final ValueChanged<BlindProgressionType?> onProgressionTypeChanged;
  final ValueChanged<String> onProgressionIntervalChanged;
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
    required this.anteTypeLabel,
    required this.onProgressionTypeChanged,
    required this.onProgressionIntervalChanged,
    required this.onLevelsCountChanged,
    required this.onLevelChanged,
    required this.expandedLevelIndex,
    required this.onLevelExpansionChanged,
  });

  String _progressionLabel(BlindProgressionType type) {
    switch (type) {
      case BlindProgressionType.manual:
        return 'Manual';
      case BlindProgressionType.everyNHands:
        return 'N hands';
      case BlindProgressionType.everyNMinutes:
        return 'N minutes';
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: stdHorizontalOffset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: stdHorizontalOffset / 2,
          children: [
            _SettingsDropdownField<BlindProgressionType>(
              label: 'Progression',
              value: progressionType,
              values: BlindProgressionType.values,
              labelBuilder: _progressionLabel,
              onChanged: onProgressionTypeChanged,
            ),
            if (progressionType == BlindProgressionType.everyNHands)
              _SettingsNumericField(
                label: 'Hands interval',
                hint: progressionIntervalHint,
                controller: progressionIntervalController,
                onChanged: onProgressionIntervalChanged,
              ),
            if (progressionType == BlindProgressionType.everyNMinutes)
              _SettingsNumericField(
                label: 'Minutes interval',
                hint: progressionIntervalHint,
                controller: progressionIntervalController,
                onChanged: onProgressionIntervalChanged,
              ),
            _SettingsNumericField(
              label: 'Levels count',
              hint: levelsCountHint,
              controller: levelsCountController,
              onChanged: onLevelsCountChanged,
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: List<Widget>.generate(
                    levels.length,
                    (index) => _SettingsLevelCard(
                      index: index,
                      level: levels[index],
                      isExpanded: expandedLevelIndex == index,
                      anteTypeLabel: anteTypeLabel,
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
