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

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void didUpdateWidget(_SettingsNumericField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != null) {
      return;
    }

    if (widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.initialValue ?? '';
    }
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
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: stdHorizontalOffset / 2),
        child: Row(
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
        ),
      );

  @override
  void dispose() {
    if (widget.controller == null) {
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
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: stdHorizontalOffset / 2),
        child: Row(
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
                ),
              ),
            ),
          ],
        ),
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

  const _SettingsDropdownField({
    required this.label,
    required this.value,
    required this.values,
    required this.labelBuilder,
    required this.onChanged,
    this.fontSizeMultiplier = 1.0,
    this.dropdownFontSizeMultiplier = 1.0,
    this.widthMultiplier = 1.0,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: stdHorizontalOffset / 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: context.theme.onBackground,
                  fontSize: stdFontSize * fontSizeMultiplier,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(width: stdHorizontalOffset),
            Flexible(
              child: DropdownButtonFormField<T>(
                isExpanded: true,
                isDense: false,
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
                          overflow: TextOverflow.ellipsis,
                        ),
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
