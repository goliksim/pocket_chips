// Ячейка банка
import 'package:flutter/material.dart';

import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../../common/widgets/ui_widgets.dart';
import 'bank_editor_view_model.dart';

class BankEditorDialog extends StatefulWidget {
  final BankEditorViewModel viewModel;
  const BankEditorDialog({
    required this.viewModel,
    super.key,
  });

  @override
  State<BankEditorDialog> createState() => _BankWindowState();
}

class _BankWindowState extends State<BankEditorDialog> {
  final TextEditingController _bankController = TextEditingController();
  late int tmpBank;

  @override
  void initState() {
    tmpBank = widget.viewModel.currentDefaultBank;

    super.initState();
  }

  void _onValueChanged(String value) {
    value = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (value != '') {
      tmpBank = int.parse(value);
    } else {
      tmpBank = widget.viewModel.currentDefaultBank;
    }
    _bankController.value = _bankController.value.copyWith(
      text: value,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: thisTheme.bgrColor,
      insetPadding: EdgeInsets.symmetric(
        horizontal: adaptiveOffset,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(stdBorderRadius),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(
          stdHorizontalOffset,
        ),
        width: stdButtonWidth,
        height: stdButtonHeight * 0.75 * 2.7 + stdHorizontalOffset * 3.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: stdButtonHeight * 0.5,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    context.strings.playp_bank_title,
                    style: TextStyle(
                      color: thisTheme.onBackground,
                      fontSize: stdFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: stdHorizontalOffset / 2,
            ),
            Container(
              height: stdButtonHeight * 0.75,
              decoration: BoxDecoration(
                color: thisTheme.bankColor,
                borderRadius: BorderRadius.circular(stdBorderRadius),
              ),
              child: TextFormField(
                controller: _bankController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: thisTheme.onBackground,
                  fontSize: stdFontSize,
                ),
                maxLength: 10,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    fontSize: stdFontSize,
                    color: thisTheme.bgrColor,
                  ),
                  hintText: '${widget.viewModel.currentDefaultBank}',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(stdBorderRadius),
                    borderSide: BorderSide(color: thisTheme.bankColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(stdBorderRadius),
                    borderSide: BorderSide(color: thisTheme.bankColor),
                  ),
                  counterText: '',
                ),
                onChanged: _onValueChanged,
              ),
            ),
            SizedBox(
              height: stdHorizontalOffset,
            ),
            MyButton(
              height: stdButtonHeight * 0.75,
              width: double.infinity,
              buttonColor:
                  (tmpBank >= 1) ? thisTheme.primaryColor : thisTheme.bankColor,
              action: () => widget.viewModel.changeBank(tmpBank),
              textString: context.strings.playp_bank_conf,
            ),
          ],
        ),
      ),
    );
  }
}
