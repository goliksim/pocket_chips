import 'package:flutter/material.dart';

import '../../app/keys/keys.dart';
import '../../domain/models/game/blind_level_model.dart';
import '../../domain/models/game/blind_progression_model.dart';
import '../../domain/models/game/game_settings_model.dart';
import '../../domain/models/lobby/lobby_state_model.dart';
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

class _GameSettingsDialogState extends State<GameSettingsDialog> {
  late final TextEditingController bankController;
  late final TextEditingController progressionIntervalController;
  late final TextEditingController levelsCountController;

  late GameSettingsModeState settingsMode;
  late BlindProgressionType progressionType;
  late List<BlindLevelModel> levels;
  late bool allowCustomBets;
  int? expandedLevelIndex;

  GameSettingsModelArgs get state => widget.viewModel.state;

  @override
  void initState() {
    super.initState();
    logs.writeLog('Settings is opened');

    allowCustomBets = state.allowCustomBets;
    final progression = state.progression;

    settingsMode = state.progression.map(
      (_) => GameSettingsModeState.simple,
      pro: (_) => GameSettingsModeState.pro,
    );

    progressionType = progression.progressionType;
    levels = progression.levels;

    bankController = TextEditingController();
    progressionIntervalController = TextEditingController(
      text: progression.progressionInterval?.toString() ?? '',
    );
    levelsCountController = TextEditingController(
      text: levels.length.toString(),
    );
  }

  @override
  void dispose() {
    bankController.dispose();
    progressionIntervalController.dispose();
    levelsCountController.dispose();
    super.dispose();
  }

  int get startingStack => parseControllerValue(
        bankController,
        fallback: state.startingStack,
      );

  bool validateLevels() => levels.every(validateLevel);

  bool validateLevel(BlindLevelModel level) {
    if (startingStack < level.smallBlind * 2) {
      widget.viewModel.showInvalidStackToast();
      return false;
    }

    return true;
  }

  void validateCurrentModeIfNeeded() {
    if (settingsMode == GameSettingsModeState.simple) {
      //TODO
      validateLevel(levels.first);
      return;
    }
    //TODO
    validateLevels();
  }

  void onCustomRaisesChanged(bool? value) {
    if (value == null) {
      return;
    }

    setState(() {
      allowCustomBets = value;
    });
  }

  int parseControllerValue(
    TextEditingController controller, {
    required int fallback,
  }) {
    final filtered = digitsOnly(controller.text);
    if (filtered != controller.text) {
      controller.value = controller.value.copyWith(
        text: filtered,
        selection: TextSelection.collapsed(offset: filtered.length),
      );
    }

    return int.tryParse(filtered) ?? fallback;
  }

  String digitsOnly(String value) => value.replaceAll(RegExp(r'[^0-9]'), '');

  void syncLevelsCount(int count) {
    final normalizedCount = count < 1 ? 1 : count;
    final currentLevels = List<BlindLevelModel>.from(levels);

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
      levels = currentLevels;
      levelsCountController.text = normalizedCount.toString();
      levelsCountController.selection = TextSelection.collapsed(
        offset: levelsCountController.text.length,
      );
    });
  }

  void updateLevel(int index, BlindLevelModel level) {
    final updatedLevels = List<BlindLevelModel>.from(levels);
    updatedLevels[index] = level;

    setState(() {
      levels = updatedLevels;
    });

    validateLevels();
  }

  void onLevelExpansionChanged(int index, bool isExpanded) {
    setState(() {
      expandedLevelIndex = isExpanded ? index : null;
    });
  }

  String anteTypeLabel(AnteType anteType) {
    switch (anteType) {
      case AnteType.none:
        return 'None';
      case AnteType.traditional:
        return 'Traditional';
      case AnteType.bigBlindAnte:
        return 'Big Blind Ante';
    }
  }

  Future<void> saveSettings() async {
    final isValid = settingsMode == GameSettingsModeState.simple
        ? validateLevel(levels.first)
        : validateLevels();

    if (!isValid) {
      return;
    }

    final progressionInterval = progressionType == BlindProgressionType.manual
        ? null
        : int.tryParse(digitsOnly(progressionIntervalController.text));

    final newSettings = GameSettingsModelResult(
      allowCustomBets: allowCustomBets,
      newStartingStack: startingStack,
      newProgression: settingsMode == GameSettingsModeState.simple
          ? BlindProgressionModel(
              progressionType: progressionType,
              progressionInterval: progressionInterval,
              blinds: levels.first,
            )
          : BlindProgressionModel.pro(
              progressionType: progressionType,
              progressionInterval: progressionInterval,
              levels: levels,
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
                      hint: state.startingStack.toString(),
                      controller: bankController,
                      fieldKey: GameSettingsKeys.stackField,
                      onChanged: (_) {
                        setState(() {});
                        validateCurrentModeIfNeeded();
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
                            value: allowCustomBets,
                            checkColor: Colors.white,
                            fillColor: WidgetStateProperty.all<Color>(
                              allowCustomBets
                                  ? context.theme.primaryColor
                                  : context.theme.bgrColor,
                            ),
                            onChanged: onCustomRaisesChanged,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Modes
                  _SettingsModeSelector(
                    selectedMode: settingsMode,
                    onModeSelected: (mode) {
                      setState(() {
                        settingsMode = mode;
                      });
                    },
                  ),
                  (settingsMode == GameSettingsModeState.simple)
                      ? _SimpleSettingsSection(
                          blinds: levels.first,
                          anteTypeLabel: anteTypeLabel,
                          changeSimpleLevel: (level) => updateLevel(0, level),
                          //smallBlindController: _simpleSmallBlindController,
                          //anteController: _simpleAnteController,
                        )
                      : Flexible(
                          child: _ProSettingsSection(
                            progressionType: progressionType,
                            progressionIntervalHint: state
                                    .progression.progressionInterval
                                    ?.toString() ??
                                '10',
                            progressionIntervalController:
                                progressionIntervalController,
                            levelsCountController: levelsCountController,
                            levelsCountHint: levels.length.toString(),
                            levels: levels,
                            anteTypeLabel: anteTypeLabel,
                            onProgressionTypeChanged: (value) {
                              if (value == null) {
                                return;
                              }

                              setState(() {
                                progressionType = value;
                                if (progressionType ==
                                    BlindProgressionType.manual) {
                                  progressionIntervalController.clear();
                                }
                              });
                            },
                            onProgressionIntervalChanged: (_) =>
                                setState(() {}),
                            onLevelsCountChanged: (value) {
                              final parsed = int.tryParse(digitsOnly(value));
                              if (parsed != null) {
                                syncLevelsCount(parsed);
                              }
                            },
                            onLevelChanged: updateLevel,
                            expandedLevelIndex: expandedLevelIndex,
                            onLevelExpansionChanged: onLevelExpansionChanged,
                          ),
                        ),

                  MyButton(
                    key: GameSettingsKeys.confirmButton,
                    height: stdButtonHeight * 0.75,
                    width: double.infinity,
                    buttonColor: context.theme.primaryColor,
                    textString: context.strings.sett_conf,
                    action: saveSettings,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
