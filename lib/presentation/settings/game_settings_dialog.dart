import 'dart:ui';

import 'package:flutter/material.dart';

import '../../app/keys/keys.dart';
import '../../domain/models/game/blind_level_model.dart';
import '../../domain/models/game/blind_progression_model.dart';
import '../../domain/models/game/game_settings_model.dart';
import '../../domain/models/lobby/lobby_state_model.dart';
import '../../l10n/localization_extension.dart';
import '../../services/toast_manager.dart';
import '../../utils/extensions.dart';
import '../../utils/logs.dart';
import '../../utils/theme/ui_values.dart';
import '../common/widgets/ui_widgets.dart';
import '../monitization/pro_version/widgets/pro_version_wrapper.dart';
import 'view_model/game_settings_view_model.dart';
import 'view_state/game_settings_mode_state.dart';

part 'widgets/settings_fields.dart';
part 'widgets/settings_level_card.dart';
part 'widgets/settings_mode_selector.dart';
part 'widgets/settings_pro_section.dart';
part 'widgets/settings_simple_section.dart';

class GameSettingsDialog extends StatefulWidget {
  final GameSettingsViewModel viewModel;

  const GameSettingsDialog({
    required this.viewModel,
    super.key,
  });

  @override
  State<GameSettingsDialog> createState() => _GameSettingsDialogState();
}

class _GameSettingsDialogState extends State<GameSettingsDialog>
    with ToastsMixin {
  late final TextEditingController _bankController;
  late final TextEditingController _progressionIntervalController;
  late final TextEditingController _levelsCountController;

  late GameSettingsModeState _settingsMode;
  late BlindProgressionType _progressionType;
  late List<BlindLevelModel> _levels;
  late bool _allowCustomBets;
  int? _expandedLevelIndex;

  GameSettingsModelArgs get state => widget.viewModel.state;

  @override
  void initState() {
    super.initState();
    logs.writeLog('Settings is opened');

    _allowCustomBets = state.allowCustomBets;
    final progression = state.progression;

    _settingsMode = state.progression.map(
      (_) => GameSettingsModeState.simple,
      pro: (_) => GameSettingsModeState.pro,
    );

    _progressionType = progression.progressionType;
    _levels = progression.levels;

    _bankController = TextEditingController();
    _progressionIntervalController = TextEditingController();
    _levelsCountController = TextEditingController();
  }

  @override
  void dispose() {
    _bankController.dispose();
    _progressionIntervalController.dispose();
    _levelsCountController.dispose();
    super.dispose();
  }

  int? get _startingStack => _parseControllerValue(
        _bankController,
        fallback: null,
      );

  int get _progressionInterval =>
      _parseControllerValue(_progressionIntervalController) ?? 10;

  bool _validateLevels() {
    for (var level in _levels) {
      if (!_validateLevel(level)) {
        return false;
      }
    }
    return true;
  }

  bool _validateLevel(BlindLevelModel level) {
    final effectiveAnte = (level.anteType == AnteType.bigBlindAnte
            ? level.smallBlind * 2
            : level.anteValue) ??
        0;

    final newStartingStack = _startingStack ?? state.startingStack;

    if (newStartingStack < level.smallBlind * 2 + effectiveAnte) {
      showToast(context.strings.toast_stack_warning);
      return false;
    }

    return true;
  }

  void _onCustomRaisesChanged(bool? value) {
    if (value == null) {
      return;
    }

    setState(() {
      _allowCustomBets = value;
    });
  }

  bool _validateStartingStack() {
    if (_startingStack == 0) {
      showToast(context.strings.toast_bank3);
      return false;
    }
    return true;
  }

  int? _parseControllerValue<T>(
    TextEditingController controller, {
    int? fallback,
    bool allowZero = false,
  }) {
    final filtered = _digitsOnly(controller.text);

    // Предотвращаем ввод нулей если allowZero = false
    if (!allowZero && filtered.isNotEmpty && filtered[0] == '0') {
      final corrected = filtered.replaceFirst(RegExp(r'^0+'), '');
      final finalValue = corrected.isEmpty ? '0' : corrected;
      controller.value = controller.value.copyWith(
        text: finalValue,
        selection: TextSelection.collapsed(offset: finalValue.length),
      );
      return int.tryParse(finalValue) ?? fallback;
    }

    if (filtered != controller.text) {
      controller.value = controller.value.copyWith(
        text: filtered,
        selection: TextSelection.collapsed(offset: filtered.length),
      );
    }

    return int.tryParse(filtered) ?? fallback;
  }

  String _digitsOnly(String value) => value.replaceAll(RegExp(r'[^0-9]'), '');

  void _syncLevelsCount(int count) {
    final normalizedCount = clampDouble(count.toDouble(), 1, 20).toInt();

    final currentLevels = List<BlindLevelModel>.from(_levels);

    if (normalizedCount > currentLevels.length) {
      final seedLevel = currentLevels.isNotEmpty
          ? currentLevels.last
          : BlindLevelModel(smallBlind: defaultSmallBlindValue);

      for (int i = currentLevels.length; i < normalizedCount; i++) {
        currentLevels.add(seedLevel);
      }
    } else if (normalizedCount < currentLevels.length) {
      currentLevels.removeRange(normalizedCount, currentLevels.length);
    }

    setState(() {
      _levels = currentLevels;
      _levelsCountController.text = normalizedCount.toString();
      _levelsCountController.selection = TextSelection.collapsed(
        offset: _levelsCountController.text.length,
      );
    });
  }

  void _updateLevel(int index, BlindLevelModel level) {
    final updatedLevels = List<BlindLevelModel>.from(_levels);
    updatedLevels[index] = level;

    setState(() {
      _levels = updatedLevels;
    });

    _validateLevel(level);
  }

  void onLevelExpansionChanged(int index, bool isExpanded) {
    setState(() {
      _expandedLevelIndex = isExpanded ? index : null;
    });
  }

  Future<void> _saveSettings() async {
    // Проверяем Starting stack
    // Проверяем блайнды
    if (!_validateStartingStack()) {
      return;
    }

    final progressionInterval = _progressionType == BlindProgressionType.manual
        ? null
        : _progressionInterval;

    final newSettings = GameSettingsModelResult(
      allowCustomBets: _allowCustomBets,
      newStartingStack: _startingStack,
      newProgression: _settingsMode == GameSettingsModeState.simple
          ? BlindProgressionModel(
              progressionType: BlindProgressionType.manual,
              progressionInterval: null,
              blinds: _levels.first,
            )
          : BlindProgressionModel.pro(
              progressionType: _progressionType,
              progressionInterval: progressionInterval,
              levels: _levels,
            ),
    );

    logs.writeLog('GameSettings: save $newSettings');
    await widget.viewModel.saveSettings(newSettings);
  }

  @override
  Widget build(BuildContext context) => Dialog(
        key: GameSettingsKeys.dialog,
        elevation: 0,
        backgroundColor: context.theme.bgrColor,
        insetPadding: EdgeInsets.symmetric(horizontal: adaptiveOffset),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SizedBox(
            width: stdButtonWidth,
            child: Padding(
              padding: EdgeInsets.all(stdHorizontalOffset),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: stdHorizontalOffset / 2,
                children: [
                  // Title
                  SizedBox(
                    height: stdButtonHeight * 0.5,
                    child: Center(
                      child: FittedBox(
                        child: Text(
                          context.strings.sett_title,
                          style: TextStyle(
                            color: context.theme.onBackground,
                            fontSize: stdFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Starting stack
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: stdHorizontalOffset),
                    child: _SettingsNumericField(
                      label: context.strings.sett_win1,
                      initialValue: state.startingStack.toString(),
                      controller: _bankController,
                      fieldKey: GameSettingsKeys.stackField,
                      allowZero: false,
                      onChanged: (_) {
                        setState(() {});
                        _validateStartingStack();
                        _validateLevels();
                      },
                    ),
                  ),
                  // Allow custom bets checkbox
                  Padding(
                    padding: EdgeInsets.only(
                      left: stdHorizontalOffset,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            context.strings.sett_custom_bets,
                            style: TextStyle(
                              color: context.theme.onBackground,
                              fontSize: stdFontSize,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Transform.scale(
                          scale: 1.25,
                          child: Checkbox(
                            key: GameSettingsKeys.allowCustomBetsCheckbox,
                            value: _allowCustomBets,
                            checkColor: Colors.white,
                            fillColor: WidgetStateProperty.all<Color>(
                              _allowCustomBets
                                  ? context.theme.primaryColor
                                  : context.theme.bgrColor,
                            ),
                            onChanged: _onCustomRaisesChanged,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Modes
                  _SettingsModeSelector(
                    selectedMode: _settingsMode,
                    onModeSelected: (mode) {
                      setState(() {
                        _settingsMode = mode;
                      });
                    },
                  ),
                  (_settingsMode == GameSettingsModeState.simple)
                      ? _SimpleSettingsSection(
                          blinds: _levels.first,
                          changeSimpleLevel: (level) => _updateLevel(0, level),
                        )
                      : Flexible(
                          child: _ProSettingsSection(
                            progressionType: _progressionType,
                            progressionIntervalHint:
                                _progressionInterval.toString(),
                            progressionIntervalController:
                                _progressionIntervalController,
                            levelsCountController: _levelsCountController,
                            levelsCountHint: _levels.length.toString(),
                            levels: _levels,
                            onProgressionTypeChanged: (value) {
                              if (value == null) {
                                return;
                              }

                              setState(() {
                                _progressionType = value;
                                if (_progressionType ==
                                    BlindProgressionType.manual) {
                                  _progressionIntervalController.clear();
                                }
                              });
                            },
                            onLevelsCountChanged: (value) {
                              final parsed = int.tryParse(_digitsOnly(value));
                              if (parsed != null) {
                                _syncLevelsCount(parsed);
                              }
                            },
                            onLevelChanged: _updateLevel,
                            expandedLevelIndex: _expandedLevelIndex,
                            onLevelExpansionChanged: onLevelExpansionChanged,
                          ),
                        ),

                  MyButton(
                    key: GameSettingsKeys.confirmButton,
                    height: stdButtonHeight * 0.75,
                    width: double.infinity,
                    buttonColor: context.theme.primaryColor,
                    textString: context.strings.sett_conf,
                    action: _saveSettings,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
