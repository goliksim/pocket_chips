part of '../game_settings_dialog.dart';

class _SettingsNumericField extends StatelessWidget {
  final String label;
  final String hint;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final Key? fieldKey;

  const _SettingsNumericField({
    required this.label,
    required this.hint,
    required this.onChanged,
    this.controller,
    this.fieldKey,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: stdHorizontalOffset / 2),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                  color: context.theme.onBackground,
                  fontSize: stdFontSize,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(
              width: stdButtonWidth * 0.3,
              child: TextFormField(
                key: fieldKey,
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: context.theme.onBackground,
                  fontSize: stdFontSize,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                    fontSize: stdFontSize,
                    color: context.theme.hintColor,
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                ),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      );
}

class _SettingsReadonlyRow extends StatelessWidget {
  final String label;
  final String value;

  const _SettingsReadonlyRow({
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
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                  color: context.theme.hintColor,
                  fontSize: stdFontSize,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: context.theme.hintColor,
                fontSize: stdFontSize,
                fontWeight: FontWeight.normal,
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

  const _SettingsDropdownField({
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  color: context.theme.onBackground,
                  fontSize: stdFontSize,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(
              width: stdButtonWidth * 0.42,
              child: DropdownButtonFormField<T>(
                initialValue: value,
                decoration: const InputDecoration(
                  isDense: true,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                alignment: AlignmentDirectional.centerEnd,
                style: TextStyle(
                  color: context.theme.onBackground,
                  fontSize: stdFontSize,
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
