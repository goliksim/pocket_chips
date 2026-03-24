part of '../game_settings_dialog.dart';

class _SettingsLevelCard extends StatefulWidget {
  final int index;
  final BlindLevelModel level;
  final bool isExpanded;
  final String Function(AnteType value) anteTypeLabel;
  final ValueChanged<bool> onExpansionChanged;
  final ValueChanged<BlindLevelModel> onLevelChanged;

  const _SettingsLevelCard({
    required this.index,
    required this.level,
    required this.isExpanded,
    required this.anteTypeLabel,
    required this.onExpansionChanged,
    required this.onLevelChanged,
  });

  @override
  State<_SettingsLevelCard> createState() => _SettingsLevelCardState();
}

class _SettingsLevelCardState extends State<_SettingsLevelCard> {
  int _parseValue(String raw, int fallback) {
    final filtered = raw.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(filtered) ?? fallback;
  }

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
              'Level ${widget.index + 1}',
              style: TextStyle(
                color: context.theme.onBackground,
                fontSize: stdFontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Text(
              'Blinds:\u{00A0}${widget.level.smallBlind}\u2215${widget.level.smallBlind * 2}'
              ' | '
              'Ante:\u{00A0}${widget.anteTypeLabel(widget.level.anteType).replaceAll(' ', '\u{00A0}')}\u2215${widget.level.anteValue}',
              style: TextStyle(
                color: context.theme.hintColor,
                fontSize: stdFontSize * 0.68,
              ),
              overflow: TextOverflow.fade,
              maxLines: 2,
            ),
            children: [
              Divider(),
              _LevelNumberField(
                label: 'Small blind',
                initialValue: widget.level.smallBlind.toString(),
                onChanged: (value) => widget.onLevelChanged(
                  widget.level.copyWith(
                    smallBlind: _parseValue(value, widget.level.smallBlind),
                  ),
                ),
              ),
              _LevelReadonlyRow(
                label: 'Big blind',
                value: '${widget.level.smallBlind * 2}',
              ),
              _LevelDropdownField<AnteType>(
                label: 'Ante type',
                value: widget.level.anteType,
                values: AnteType.values,
                labelBuilder: widget.anteTypeLabel,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }

                  widget.onLevelChanged(widget.level.copyWith(anteType: value));
                },
              ),
              if (widget.level.anteType != AnteType.none)
                _LevelNumberField(
                  label: 'Ante',
                  initialValue: widget.level.anteValue.toString(),
                  onChanged: (value) => widget.onLevelChanged(
                    widget.level.copyWith(
                      anteValue: _parseValue(value, widget.level.anteValue),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
}

class _LevelNumberField extends StatelessWidget {
  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const _LevelNumberField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: stdHorizontalOffset / 2),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: context.theme.onBackground,
                  fontSize: stdFontSize * 0.9,
                ),
              ),
            ),
            SizedBox(
              width: stdButtonWidth * 0.24,
              child: TextFormField(
                initialValue: initialValue,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: context.theme.onBackground,
                  fontSize: stdFontSize * 0.9,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      );
}

class _LevelReadonlyRow extends StatelessWidget {
  final String label;
  final String value;

  const _LevelReadonlyRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: stdHorizontalOffset / 2),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: context.theme.hintColor,
                  fontSize: stdFontSize * 0.9,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: context.theme.hintColor,
                fontSize: stdFontSize * 0.9,
              ),
            ),
          ],
        ),
      );
}

class _LevelDropdownField<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> values;
  final String Function(T value) labelBuilder;
  final ValueChanged<T?> onChanged;

  const _LevelDropdownField({
    required this.label,
    required this.value,
    required this.values,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: stdHorizontalOffset / 2),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: context.theme.onBackground,
                  fontSize: stdFontSize * 0.9,
                ),
              ),
            ),
            SizedBox(
              width: stdButtonWidth * 0.35,
              child: DropdownButtonFormField<T>(
                initialValue: value,
                decoration: const InputDecoration(
                  isDense: true,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                style: TextStyle(
                  color: context.theme.onBackground,
                  fontSize: stdFontSize * 0.75,
                ),
                dropdownColor: context.theme.bgrColor,
                items: values
                    .map(
                      (item) => DropdownMenuItem<T>(
                        value: item,
                        child: Text(labelBuilder(item)),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      );
}
