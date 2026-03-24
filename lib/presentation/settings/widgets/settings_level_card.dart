part of '../game_settings_dialog.dart';

class _SettingsLevelCard extends StatefulWidget {
  final int index;
  final BlindLevelModel level;
  final bool isExpanded;

  final ValueChanged<bool> onExpansionChanged;
  final ValueChanged<BlindLevelModel> onLevelChanged;

  const _SettingsLevelCard({
    required this.index,
    required this.level,
    required this.isExpanded,
    required this.onExpansionChanged,
    required this.onLevelChanged,
  });

  @override
  State<_SettingsLevelCard> createState() => _SettingsLevelCardState();
}

class _SettingsLevelCardState extends State<_SettingsLevelCard> {
  int? _parseValue(String raw) {
    final filtered = raw.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(filtered);
  }

  String _levelSubtitle(BlindLevelModel level) {
    final blinds =
        '${widget.level.smallBlind.toCompact}\u2215${(widget.level.smallBlind * 2).toCompact}';
    final ante = context.strings.anteTypeLabel(widget.level.anteType) +
        (widget.level.anteType == AnteType.none
            ? ''
            : '\u2215${widget.level.anteValue}');

    final blindsText = '${context.strings.sett_level_blind}: $blinds'
        .replaceAll(' ', '\u{00A0}');
    final anteText =
        '${context.strings.sett_level_ante}: $ante'.replaceAll(' ', '\u{00A0}');

    return '$blindsText | $anteText';
  }

  void _onAnteTypeChanged(AnteType? value) {
    if (value == null || value == widget.level.anteType) {
      return;
    }

    final int? anteValue;
    switch (value) {
      case AnteType.traditional:
        anteValue = widget.level.smallBlind;
        break;
      case AnteType.bigBlindAnte:
        anteValue = widget.level.smallBlind * 2;
        break;
      default:
        anteValue = null;
    }

    widget.onLevelChanged(widget.level.copyWith(
      anteType: value,
      anteValue: anteValue,
    ));
  }

  void _onSmallBlindChanged(String value) => widget.onLevelChanged(
        widget.level.copyWith(
          smallBlind: _parseValue(value) ?? widget.level.smallBlind,
        ),
      );

  void _onAnteValueChanged(String value) => widget.onLevelChanged(
        widget.level.copyWith(
          anteValue: _parseValue(value) ?? widget.level.anteValue,
        ),
      );

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(bottom: stdHorizontalOffset / 2),
        decoration: BoxDecoration(
          color: context.theme.playerColor,
          borderRadius: BorderRadius.circular(stdBorderRadius),
          border: Border.all(
            color: widget.isExpanded
                ? context.theme.primaryColor
                : context.theme.hintColor,
            width: 1,
          ),
        ),
        child: Theme(
          data: ThemeData().copyWith(
            dividerColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: ExpansionTile(
            key:
                ValueKey('settings_level_${widget.index}_${widget.isExpanded}'),
            initiallyExpanded: widget.isExpanded,
            tilePadding: EdgeInsets.symmetric(horizontal: stdHorizontalOffset),
            onExpansionChanged: widget.onExpansionChanged,
            childrenPadding: EdgeInsets.fromLTRB(
              stdHorizontalOffset,
              0,
              stdHorizontalOffset,
              stdHorizontalOffset / 2,
            ),
            title: Text(
              '${context.strings.sett_level} ${widget.index + 1}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: context.theme.onBackground,
                fontSize: stdFontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Text(
              _levelSubtitle(widget.level),
              style: TextStyle(
                color: context.theme.hintColor,
                fontSize: stdFontSize * 0.68,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            children: [
              Divider(),
              _SettingsNumericField(
                label: context.strings.sett_small_blind,
                initialValue: widget.level.smallBlind.toString(),
                onChanged: _onSmallBlindChanged,
                allowZero: false,
                fontSizeMultiplier: 0.9,
                widthMultiplier: 0.8,
              ),
              _SettingsReadonlyRow(
                label: context.strings.sett_big_blind,
                value: '${widget.level.smallBlind * 2}',
                fontSizeMultiplier: 0.9,
                widthMultiplier: 0.8,
              ),
              _SettingsDropdownField<AnteType>(
                label: context.strings.sett_ante_type,
                value: widget.level.anteType,
                values: AnteType.values,
                labelBuilder: context.strings.anteTypeLabel,
                onChanged: _onAnteTypeChanged,
                fontSizeMultiplier: 0.9,
                dropdownFontSizeMultiplier: 0.75,
                widthMultiplier: 0.83,
              ),
              if (widget.level.anteType != AnteType.none)
                _SettingsNumericField(
                  label: context.strings.sett_ante,
                  initialValue: widget.level.anteValue.toString(),
                  onChanged: _onAnteValueChanged,
                  allowZero: false,
                  fontSizeMultiplier: 0.9,
                  widthMultiplier: 0.8,
                ),
            ],
          ),
        ),
      );
}
