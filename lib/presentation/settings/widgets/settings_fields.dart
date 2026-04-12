part of '../game_settings_dialog.dart';

class _SettingsNumericField extends StatefulWidget {
  final String label;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final Key? fieldKey;
  final bool allowZero;
  final int? maxValue;
  final double fontSizeMultiplier;
  final double widthMultiplier;
  final String? initialValue;

  const _SettingsNumericField({
    required this.label,
    required this.onChanged,
    this.controller,
    this.fieldKey,
    this.allowZero = true,
    this.maxValue,
    this.fontSizeMultiplier = 1.0,
    this.widthMultiplier = 1.0,
    this.initialValue,
  });

  @override
  State<_SettingsNumericField> createState() => _SettingsNumericFieldState();
}

class _SettingsNumericFieldState extends State<_SettingsNumericField>
    with ToastsMixin {
  late TextEditingController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _attachController();
  }

  @override
  void didUpdateWidget(_SettingsNumericField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      if (_ownsController) {
        _controller.dispose();
      }
      _attachController();
      return;
    }

    if (_ownsController && widget.initialValue != oldWidget.initialValue) {
      final newValue = widget.initialValue ?? '';
      _controller.value = _controller.value.copyWith(
        text: newValue,
        selection: TextSelection.collapsed(offset: newValue.length),
        composing: TextRange.empty,
      );
    }
  }

  void _attachController() {
    final externalController = widget.controller;
    _ownsController = externalController == null;
    _controller = externalController ??
        TextEditingController(text: widget.initialValue ?? '');
  }

  void _onChanged(String value) {
    // Удаляем все нецифровые символы
    final filtered = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Если не позволяем нули и значение начинается с 0
    if (!widget.allowZero && filtered.isNotEmpty && filtered[0] == '0') {
      showToast(context.strings.toast_cannot_be_zero);
      final corrected = filtered.replaceFirst(RegExp(r'^0+'), '');
      final finalValue = corrected.isEmpty ? '' : corrected;
      _controller.value = _controller.value.copyWith(
        text: finalValue,
        selection: TextSelection.collapsed(offset: finalValue.length),
      );
      widget.onChanged(finalValue);
      return;
    }

    // Проверяем максимальное значение
    if (widget.maxValue != null && filtered.isNotEmpty) {
      final parsed = int.tryParse(filtered);
      if (parsed != null && parsed > widget.maxValue!) {
        showToast(context.strings.toast_exceeds_maximum);
        final maxStr = widget.maxValue.toString();
        _controller.value = _controller.value.copyWith(
          text: maxStr,
          selection: TextSelection.collapsed(offset: maxStr.length),
        );
        widget.onChanged(maxStr);
        return;
      }
    }

    // Обновляем контроллер если текст изменился
    if (filtered != value) {
      _controller.value = _controller.value.copyWith(
        text: filtered,
        selection: TextSelection.collapsed(offset: filtered.length),
      );
    }

    widget.onChanged(filtered);
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Text(
              widget.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: context.theme.onBackground,
                fontSize: stdFontSize * widget.fontSizeMultiplier,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          SizedBox(
            width: stdButtonWidth * 0.3 * widget.widthMultiplier,
            child: TextFormField(
              key: widget.fieldKey,
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: context.theme.onBackground,
                fontSize: stdFontSize * widget.fontSizeMultiplier,
                height: 0,
              ),
              maxLength: 8,
              decoration: InputDecoration(
                hintText: widget.initialValue,
                hintStyle: TextStyle(
                  fontSize: stdFontSize * widget.fontSizeMultiplier,
                  color: context.theme.hintColor,
                ),
                counterText: "",
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
              ),
              onChanged: _onChanged,
            ),
          ),
        ],
      );

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }
}

class _SettingsReadonlyRow extends StatelessWidget {
  final String label;
  final String value;
  final double fontSizeMultiplier;
  final double widthMultiplier;

  const _SettingsReadonlyRow({
    required this.label,
    required this.value,
    this.fontSizeMultiplier = 1.0,
    this.widthMultiplier = 1.0,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: context.theme.hintColor,
                fontSize: stdFontSize * fontSizeMultiplier,
                fontWeight: FontWeight.normal,
                height: 0,
              ),
            ),
          ),
          SizedBox(
            width: stdButtonWidth * 0.3 * widthMultiplier,
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: context.theme.hintColor,
                fontSize: stdFontSize * fontSizeMultiplier,
                fontWeight: FontWeight.normal,
                height: 0,
              ),
            ),
          ),
        ],
      );
}

class _SettingsDropdownField<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> values;
  final String Function(T value) labelBuilder;
  final ValueChanged<T?> onChanged;
  final double fontSizeMultiplier;
  final double dropdownFontSizeMultiplier;
  final double widthMultiplier;
  final String? tooltip;

  const _SettingsDropdownField({
    required this.label,
    required this.value,
    required this.values,
    required this.labelBuilder,
    required this.onChanged,
    this.fontSizeMultiplier = 1.0,
    this.dropdownFontSizeMultiplier = 1.0,
    this.widthMultiplier = 1.0,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: FittedBox(
              child: Text.rich(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$label ',
                      style: TextStyle(
                        color: context.theme.onBackground,
                        fontSize: stdFontSize,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    if (tooltip != null)
                      WidgetSpan(
                        child: Tooltip(
                          triggerMode: TooltipTriggerMode.tap,
                          showDuration: const Duration(seconds: 7),
                          message: tooltip,
                          child: Icon(
                            Icons.help_outline,
                            color: context.theme.hintColor,
                            size: stdIconSize * 0.75 * fontSizeMultiplier,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: stdHorizontalOffset),
          Expanded(
            child: DropdownButtonFormField<T>(
              isExpanded: true,
              initialValue: value,
              decoration: const InputDecoration(
                isDense: true,
              ),
              alignment: AlignmentDirectional.centerEnd,
              style: TextStyle(
                color: context.theme.onBackground,
                fontSize: stdFontSize * dropdownFontSizeMultiplier,
              ),
              dropdownColor: context.theme.bgrColor,
              items: values
                  .map(
                    (item) => DropdownMenuItem<T>(
                      value: item,
                      child: Text(
                        labelBuilder(item),
                        textAlign: TextAlign.right,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      );
}
