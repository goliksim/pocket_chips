part of '../game_settings_dialog.dart';

class _SimpleSettingsSection extends StatelessWidget {
  final BlindLevelModel blinds;

  final Function(BlindLevelModel value) changeSimpleLevel;

  const _SimpleSettingsSection({
    required this.blinds,
    required this.changeSimpleLevel,
  });

  void _onSmallBlindChanged(String value) => changeSimpleLevel(
        blinds.copyWith(smallBlind: int.tryParse(value) ?? blinds.smallBlind),
      );

  void _onAnteChanged(String value) => changeSimpleLevel(
        blinds.copyWith(anteValue: int.tryParse(value) ?? blinds.anteValue),
      );

  void _onAnteTypeChanged(AnteType? value) {
    if (value == null || value == blinds.anteType) {
      return;
    }

    final int? anteValue;
    switch (value) {
      case AnteType.traditional:
        anteValue = blinds.smallBlind;
        break;
      case AnteType.bigBlindAnte:
        anteValue = blinds.smallBlind * 2;
        break;
      default:
        anteValue = null;
    }

    changeSimpleLevel(
      blinds.copyWith(
        anteType: value,
        anteValue: anteValue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: stdHorizontalOffset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: stdHorizontalOffset / 2,
          children: [
            Column(
              children: [
                _SettingsNumericField(
                  label: context.strings.sett_small_blind,
                  initialValue: blinds.smallBlind.toString(),
                  fieldKey: GameSettingsKeys.smallBlindField,
                  onChanged: _onSmallBlindChanged,
                  allowZero: false,
                ),
                _SettingsReadonlyRow(
                  label: context.strings.sett_big_blind,
                  value: '${blinds.smallBlind * 2}',
                  fontSizeMultiplier: 0.7,
                ),
              ],
            ),
            Divider(
              color: context.theme.bgrColor,
              thickness: 2,
            ),
            _SettingsDropdownField<AnteType>(
              label: context.strings.sett_ante_type,
              value: blinds.anteType,
              values: AnteType.values,
              labelBuilder: context.strings.anteTypeLabel,
              onChanged: _onAnteTypeChanged,
              dropdownFontSizeMultiplier: 0.85,
              widthMultiplier: 0.83,
            ),
            if (blinds.anteType != AnteType.none) ...[
              Divider(
                color: context.theme.bgrColor,
                indent: stdHorizontalOffset * 2,
                endIndent: stdHorizontalOffset * 2,
                thickness: 2,
              ),
              _SettingsNumericField(
                fieldKey: ValueKey('simple_ante_field'),
                label: context.strings.sett_ante,
                initialValue: blinds.anteValue.toString(),
                onChanged: _onAnteChanged,
                allowZero: false,
              ),
            ]
          ],
        ),
      );
}
