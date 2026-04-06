part of '../game_settings_dialog.dart';

class _SettingsModeSelector extends StatelessWidget {
  final GameSettingsModeState selectedMode;
  final ValueChanged<GameSettingsModeState> onModeSelected;

  const _SettingsModeSelector({
    required this.selectedMode,
    required this.onModeSelected,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: _ModeButton(
              label: context.strings
                  .settingsModeLabel(GameSettingsModeState.simple),
              isSelected: selectedMode == GameSettingsModeState.simple,
              onTap: () => onModeSelected(GameSettingsModeState.simple),
              buttonKey: GameSettingsKeys.simpleModeButton,
            ),
          ),
          SizedBox(width: stdHorizontalOffset / 2),
          Expanded(
            child: ProVersionWrapper(
              offset: -6,
              child: _ModeButton(
                label: context.strings
                    .settingsModeLabel(GameSettingsModeState.pro),
                isSelected: selectedMode == GameSettingsModeState.pro,
                onTap: () => onModeSelected(GameSettingsModeState.pro),
                buttonKey: GameSettingsKeys.proModeButton,
              ),
            ),
          ),
        ],
      );
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Key? buttonKey;

  const _ModeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.buttonKey,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        key: buttonKey,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(
            horizontal: stdHorizontalOffset,
            vertical: stdHorizontalOffset / 1.5,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? context.theme.primaryColor
                : context.theme.playerColor.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(stdBorderRadius),
            border: BoxBorder.all(
              color: isSelected ? Colors.transparent : context.theme.hintColor,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected
                    ? context.theme.onPrimary
                    : context.theme.onBackground,
                fontSize: stdFontSize * 0.78,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );
}
