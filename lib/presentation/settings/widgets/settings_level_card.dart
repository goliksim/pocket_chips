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
    final blinds = context.strings.blindsValueLabel(widget.level.smallBlind);
    final ante = context.strings
        .anteValueLabel(widget.level.anteValue, widget.level.anteType);

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
          child: _AnimatedExpandable(
            isExpanded: widget.isExpanded,
            onToggle: () => widget.onExpansionChanged(!widget.isExpanded),
            visibleChild: Row(
              children: [
                Text(
                  ' ${widget.index + 1}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.theme.onBackground,
                    fontSize: stdFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: stdHorizontalOffset),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: stdHorizontalOffset / 2),
                    child: Text(
                      _levelSubtitle(widget.level),
                      style: TextStyle(
                          color: context.theme.hintColor,
                          fontSize: stdFontSize * 0.68,
                          height: 0),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
            expandedChild: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(
                  color: context.theme.primaryColor,
                  height: stdHorizontalOffset / 2,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    stdHorizontalOffset,
                    0,
                    stdHorizontalOffset,
                    stdHorizontalOffset / 2,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _SettingsNumericField(
                        fieldKey:
                            ValueKey('level_small_blind_field_${widget.index}'),
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
                        fontSizeMultiplier: 0.7,
                        widthMultiplier: 0.8,
                      ),
                      Divider(
                        color: context.theme.bgrColor,
                        height: stdHorizontalOffset * 1.5,
                        thickness: 2,
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
                      if (widget.level.anteType != AnteType.none) ...[
                        Divider(
                          color: context.theme.bgrColor,
                          height: stdHorizontalOffset * 1.5,
                          thickness: 2,
                        ),
                        _SettingsNumericField(
                          fieldKey: ValueKey(
                            'level_ante_field_${widget.index}',
                          ),
                          label: context.strings.sett_ante,
                          initialValue: widget.level.anteValue.toString(),
                          onChanged: _onAnteValueChanged,
                          allowZero: false,
                          fontSizeMultiplier: 0.9,
                          widthMultiplier: 0.8,
                        ),
                      ],
                      SizedBox(height: stdHorizontalOffset / 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _AnimatedExpandable extends StatefulWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final Widget visibleChild;
  final Widget expandedChild;

  const _AnimatedExpandable({
    required this.isExpanded,
    required this.onToggle,
    required this.visibleChild,
    required this.expandedChild,
  });

  @override
  State<_AnimatedExpandable> createState() => _AnimatedExpandableState();
}

class _AnimatedExpandableState extends State<_AnimatedExpandable>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 250),
      vsync: this,
      value: widget.isExpanded ? 1.0 : 0.0,
    );
    _heightAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didUpdateWidget(_AnimatedExpandable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isExpanded != widget.isExpanded) {
      if (widget.isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: widget.onToggle,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: stdHorizontalOffset),
              height: stdButtonHeight * 0.75,
              child: Row(
                children: [
                  Expanded(child: widget.visibleChild),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 0.0,
                      end: widget.isExpanded ? -0.5 : 0.0,
                    ),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, value, child) => RotationTransition(
                      turns: AlwaysStoppedAnimation(value),
                      child: Icon(
                        Icons.expand_more,
                        color: context.theme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _heightAnimation,
            axis: Axis.vertical,
            child: widget.expandedChild,
          ),
        ],
      );
}
