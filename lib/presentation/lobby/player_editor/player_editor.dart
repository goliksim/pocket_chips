// Кнопка добавления игрока
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../../common/widgets/ui_widgets.dart';
import 'view_model/player_editor_view_model.dart';

class PlayerEditorPage extends StatefulWidget {
  final PlayerEditorViewModel viewModel;

  const PlayerEditorPage({
    required this.viewModel,
    super.key,
  });

  @override
  PlayerEditorPageState createState() => PlayerEditorPageState();
}

class PlayerEditorPageState extends State<PlayerEditorPage> {
  static const String _frameAssetName = 'assets/faces/edit_frame.png';

  final TextEditingController _bankController = TextEditingController();
  late FocusNode focusNodeName = FocusNode();
  late FocusNode focusNodeStack = FocusNode();

  Future<void> _onLogoTap() async {
    SystemChrome.restoreSystemUIOverlays();
    if (focusNodeName.hasFocus || focusNodeStack.hasFocus) {
      focusNodeStack.unfocus();
      focusNodeName.unfocus();
      await Future.delayed(const Duration(milliseconds: 500));
    }
    widget.viewModel.openLogoEditor();
  }

  void _onBankChanged(String value) {
    value = value.replaceAll(RegExp(r'[^0-9]'), '');

    widget.viewModel.changeBank(value);

    _bankController.value = _bankController.value.copyWith(
      text: value,
    );
  }

  bool get _validateBank => widget.viewModel.validBank;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, value) {
        final player = widget.viewModel.playerState;
        final canEdit = widget.viewModel.canEdit;

        final validInput = widget.viewModel.validateInput;

        return Dialog(
          elevation: stdElevation,
          backgroundColor: thisTheme.bgrColor,
          insetPadding: EdgeInsets.symmetric(horizontal: adaptiveOffset),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Container(
            padding: EdgeInsets.all(
              stdHorizontalOffset,
            ),
            width: stdButtonWidth,
            height: stdDialogHeight * 1.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Аватарка
                GestureDetector(
                  onTap: () => _onLogoTap(),
                  child: Stack(
                    children: [
                      Container(
                        width: stdDialogHeight / 2,
                        height: stdDialogHeight / 2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            filterQuality: FilterQuality.medium,
                            image: AssetImage(player.assetUrl),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Container(
                        width: stdDialogHeight / 2,
                        height: stdDialogHeight / 2,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.5,
                            color: (player.assetUrl !=
                                    PlayerEditorViewModel.standartLogo)
                                ? thisTheme.primaryColor
                                : thisTheme.bgrColor,
                          ),
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            filterQuality: FilterQuality.medium,
                            image: AssetImage(_frameAssetName),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: stdHorizontalOffset),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Text on top
                        SizedBox(
                          height: stdButtonHeight * 0.5,
                          child: Center(
                            child: Text(
                              widget.viewModel.newPlayerEditing
                                  ? context.strings.playp_edit_title1
                                  : context.strings.playp_edit_title2,
                              style: TextStyle(
                                color: thisTheme.onBackground,
                                fontWeight: FontWeight.bold,
                                fontSize: stdFontSize,
                              ),
                            ),
                          ),
                        ),
                        // Name field
                        SizedBox(
                          height: stdButtonHeight * 0.6,
                          child: TextFormField(
                            initialValue: player.nameInput,
                            focusNode: focusNodeName,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: thisTheme.onBackground,
                              fontSize: stdFontSize * 0.85,
                            ),
                            maxLength: 10,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: stdFontSize * 0.85,
                                color: thisTheme.hintColor,
                              ),
                              hintText: context.strings.playp_edit_win1,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    // цвет линнии в окне
                                    BorderSide(
                                  color: (player.nameInput?.isNotEmpty ?? false)
                                      ? thisTheme.primaryColor
                                      : thisTheme.hintColor,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: (player.nameInput?.isNotEmpty ?? false)
                                      ? thisTheme.primaryColor
                                      : thisTheme.hintColor,
                                ),
                              ),
                              counterText: '',
                            ),
                            onChanged: widget.viewModel.changePlayerName,
                          ),
                        ),
                        // Bank field
                        if (canEdit)
                          SizedBox(
                            height: stdButtonHeight * 0.6,
                            child: TextFormField(
                              controller: _bankController,
                              keyboardType: TextInputType.number,
                              focusNode: focusNodeStack,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: thisTheme.onBackground,
                                fontSize: stdFontSize * 0.85,
                              ),
                              maxLength: 5,
                              textAlignVertical: TextAlignVertical.bottom,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: stdFontSize * 0.85,
                                  color: thisTheme.hintColor,
                                ),
                                hintText:
                                    '${context.strings.playp_edit_win2} - ${player.bankInput}',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      // цвет линнии в окне
                                      BorderSide(
                                    color: _validateBank
                                        ? thisTheme.primaryColor
                                        : thisTheme.hintColor,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: _validateBank
                                        ? thisTheme.primaryColor
                                        : thisTheme.hintColor,
                                  ),
                                ),
                                counterText: '',
                              ),
                              onChanged: _onBankChanged,
                            ),
                          ),
                        // Button field
                        if (canEdit)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 7,
                                child: Text(
                                  context.strings.playp_edit_win3,
                                  style: TextStyle(
                                    color: thisTheme.onBackground,
                                    fontSize: stdFontSize * 0.85,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: stdButtonHeight * 0.6,
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    fillColor: WidgetStateProperty.all<Color>(
                                      player.makeDealer
                                          ? thisTheme.primaryColor
                                          : thisTheme.hintColor,
                                    ),
                                    value: player.makeDealer,
                                    onChanged: widget.viewModel.makeDealer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        MyButton(
                          height: stdButtonHeight * 0.75,
                          width: double.infinity,
                          buttonColor: validInput
                              ? thisTheme.primaryColor
                              : thisTheme.bankColor,
                          textString: widget.viewModel.newPlayerEditing
                              ? context.strings.playp_edit_conf
                              : context.strings.playp_edit_add,
                          action: () async {
                            if (!validInput) {
                              return;
                            }
                            // закрываем клаву, при нажатии кнопки
                            if (focusNodeName.hasFocus ||
                                focusNodeStack.hasFocus) {
                              focusNodeStack.unfocus();
                              focusNodeName.unfocus();
                              await Future.delayed(
                                const Duration(milliseconds: 500),
                              );
                            }

                            widget.viewModel.confirmEditing();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
