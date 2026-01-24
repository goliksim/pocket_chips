// Кнопка добавления игрока
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../services/assets_provider.dart';
import '../../../services/toast_manager.dart';
import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../../common/player_avatar.dart';
import '../../common/widgets/ui_widgets.dart';
import '../../monitization/pro_version/widgets/pro_version_wrapper.dart';
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

class PlayerEditorPageState extends State<PlayerEditorPage> with ToastsMixin {
  late FocusNode focusNodeName = FocusNode();
  late FocusNode focusNodeStack = FocusNode();

  Future<void> _onLogoTap() async {
    //SystemChrome.restoreSystemUIOverlays();
    if (focusNodeName.hasFocus || focusNodeStack.hasFocus) {
      focusNodeStack.unfocus();
      focusNodeName.unfocus();
      await Future.delayed(const Duration(milliseconds: 500));
    }
    widget.viewModel.openLogoEditor();
  }

  void _onBankChanged(String value) {
    value = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (!kDebugMode && value == '0') {
      value = '1';
    }

    widget.viewModel.changeBank(value);
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, value) {
        final player = widget.viewModel.playerState;

        final validInput = widget.viewModel.validateInput;

        return Dialog(
          elevation: stdElevation,
          backgroundColor: context.theme.bgrColor,
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
                ProVersionWrapper(
                  child: GestureDetector(
                    onTap: () => _onLogoTap(),
                    child: Stack(
                      children: [
                        PlayerAvatar(
                          assetUrl: player.assetUrl,
                          radius: (stdDialogHeight / 2) / 2,
                          filterQuality: FilterQuality.high,
                        ),
                        Container(
                          width: stdDialogHeight / 2,
                          height: stdDialogHeight / 2,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.5,
                              color: (player.assetUrl !=
                                      AssetsProvider.emptyPlayerAsset)
                                  ? context.theme.primaryColor
                                  : context.theme.bgrColor,
                            ),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              filterQuality: FilterQuality.medium,
                              image: AssetsProvider.playerIconEditFrame,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                                color: context.theme.onBackground,
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
                              color: context.theme.onBackground,
                              fontSize: stdFontSize * 0.85,
                            ),
                            maxLength: 10,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: stdFontSize * 0.85,
                                color: context.theme.hintColor,
                              ),
                              hintText: context.strings.playp_edit_win1,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    // цвет линнии в окне
                                    BorderSide(
                                  color: (player.nameInput?.isNotEmpty ?? false)
                                      ? context.theme.primaryColor
                                      : context.theme.hintColor,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: (player.nameInput?.isNotEmpty ?? false)
                                      ? context.theme.primaryColor
                                      : context.theme.hintColor,
                                ),
                              ),
                              counterText: '',
                            ),
                            onChanged: widget.viewModel.changePlayerName,
                          ),
                        ),
                        // Bank field
                        SizedBox(
                          height: stdButtonHeight * 0.6,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            focusNode: focusNodeStack,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: context.theme.onBackground,
                              fontSize: stdFontSize * 0.85,
                            ),
                            maxLength: 8,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: stdFontSize * 0.85,
                                color: context.theme.hintColor,
                              ),
                              hintText:
                                  '${context.strings.playp_edit_win2} - ${player.bankInput}',
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    // цвет линнии в окне
                                    BorderSide(
                                  color: (player.bankInput != null)
                                      ? context.theme.primaryColor
                                      : context.theme.hintColor,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: (player.bankInput != null)
                                      ? context.theme.primaryColor
                                      : context.theme.hintColor,
                                ),
                              ),
                              counterText: '',
                            ),
                            onChanged: _onBankChanged,
                          ),
                        ),
                        // Button field

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 7,
                              child: Text(
                                context.strings.playp_edit_win3,
                                style: TextStyle(
                                  color: player.forceDeadler
                                      ? context.theme.hintColor
                                      : context.theme.onBackground,
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
                                        ? context.theme.primaryColor
                                        : context.theme.bgrColor,
                                  ),
                                  value:
                                      player.makeDealer || player.forceDeadler,
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
                              ? context.theme.primaryColor
                              : context.theme.bankColor,
                          textString: widget.viewModel.newPlayerEditing
                              ? context.strings.playp_edit_add
                              : context.strings.playp_edit_conf,
                          action: () async {
                            if (!validInput) {
                              return widget.viewModel.notifyWrongInput();
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
