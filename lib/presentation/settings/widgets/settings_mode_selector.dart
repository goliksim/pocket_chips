part of '../game_settings_dialog.dart';

class _SettingsModeSelector extends StatelessWidget {
  final GameSettingsModeState selectedMode;
  final ValueChanged<GameSettingsModeState> onModeSelected;

  const _SettingsModeSelector({
    required this.selectedMode,
    required this.onModeSelected,
  });

  String _modeLabel(GameSettingsModeState mode) =>
      mode == GameSettingsModeState.simple ? 'Simple' : 'Pro';

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: _ModeButton(
              label: _modeLabel(GameSettingsModeState.simple),
              isSelected: selectedMode == GameSettingsModeState.simple,
              onTap: () => onModeSelected(GameSettingsModeState.simple),
            ),
          ),
          SizedBox(width: stdHorizontalOffset / 2),
          Expanded(
            child: ProVersionWrapper(
              offset: -6,
              child: _ModeButton(
                label: _modeLabel(GameSettingsModeState.pro),
                isSelected: selectedMode == GameSettingsModeState.pro,
                onTap: () => onModeSelected(GameSettingsModeState.pro),
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

  const _ModeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
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
