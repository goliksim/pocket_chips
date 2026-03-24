part of '../game_settings_dialog.dart';

class _SimpleSettingsSection extends StatelessWidget {
  //final TextEditingController smallBlindController;
  //final TextEditingController anteController;
  final BlindLevelModel blinds;
  final String Function(AnteType value) anteTypeLabel;
  final Function(BlindLevelModel value) changeSimpleLevel;

  const _SimpleSettingsSection({
    required this.blinds,
    required this.changeSimpleLevel,
    required this.anteTypeLabel,
    //required this.smallBlindController,
    //required this.anteController,
  });

  void _onSmallBlindChanged(String value) => changeSimpleLevel(
        blinds.copyWith(smallBlind: int.tryParse(value) ?? blinds.smallBlind),
      );

  void _onAnteChanged(String value) => changeSimpleLevel(
        blinds.copyWith(anteValue: int.tryParse(value) ?? blinds.anteValue),
      );

  void _onAnteTypeChanged(AnteType? value) {
    if (value == null) {
      return;
    }

    changeSimpleLevel(
      blinds.copyWith(anteType: value),
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: stdHorizontalOffset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: stdHorizontalOffset / 2,
          children: [
            _SettingsNumericField(
              label: context.strings.sett_win2,
              hint: blinds.smallBlind.toString(),
              //controller: smallBlindController,
              fieldKey: GameSettingsKeys.smallBlindField,
              onChanged: _onSmallBlindChanged,
            ),
            _SettingsReadonlyRow(
              label: context.strings.sett_win3,
              value: '${blinds.smallBlind * 2}',
            ),
            _SettingsDropdownField<AnteType>(
              label: 'Ante Type',
              value: blinds.anteType,
              values: AnteType.values,
              labelBuilder: anteTypeLabel,
              onChanged: _onAnteTypeChanged,
            ),
            if (blinds.anteType != AnteType.none)
              _SettingsNumericField(
                label: 'Ante',
                hint: blinds.anteValue.toString(),
                //controller: anteController,
                onChanged: _onAnteChanged,
              ),
          ],
        ),
      );
}
