import 'package:flutter/material.dart';

import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../../monitization/pro_version/widgets/pro_version_wrapper.dart';

class AddPlayerButton extends StatefulWidget {
  final bool canEditPlayers;
  final VoidCallback? addPlayerCallback;
  final VoidCallback? openPlayersListCallback;

  const AddPlayerButton({
    required this.canEditPlayers,
    this.addPlayerCallback,
    this.openPlayersListCallback,
    super.key,
  });

  @override
  State<AddPlayerButton> createState() => _AddPlayerButtonState();
}

class _AddPlayerButtonState extends State<AddPlayerButton> {
  bool addButtonPressed = false;

  @override
  Widget build(BuildContext context) => widget.canEditPlayers
      ? SizedBox(
          height: stdButtonHeight * 0.75 * 0.8,
          width: stdButtonHeight * 0.75 * 2,
          child: Center(
            child: AnimatedSwitcher(
              switchInCurve: Curves.easeInOutBack,
              switchOutCurve: Curves.easeInOutBack,
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget widget, Animation<double> animation) =>
                  AnimatedBuilder(
                animation: animation,
                child: widget,
                builder: (context, widget) => Transform(
                  transform: Matrix4.diagonal3Values(
                    animation.value,
                    1.0,
                    1.0,
                  ),
                  alignment: Alignment.center,
                  child: widget,
                ),
              ),
              child: !addButtonPressed
                  ? Container(
                      key: const ValueKey('1'),
                      height: stdButtonHeight * 0.75 * 0.8,
                      width: stdButtonHeight * 0.75 * 0.8,
                      decoration: BoxDecoration(
                        color: context.theme.primaryColor,
                        borderRadius:
                            BorderRadius.circular(stdBorderRadius * 2),
                      ),
                      child: FittedBox(
                        child: IconButton(
                          tooltip: context.strings.tooltip_add_main,
                          splashRadius: stdButtonHeight * 0.75 * 0.45,
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                            //size: stdIconSize,
                          ),
                          onPressed: () async {
                            setState(() {
                              addButtonPressed = true;
                            });
                            //TODO: продлить, если нажали на внутренние кнопки
                            await Future.delayed(const Duration(seconds: 10));
                            setState(() {
                              addButtonPressed = false;
                            });
                          },
                        ),
                      ),
                    )
                  : Row(
                      key: const ValueKey('2'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: stdButtonHeight * 0.75 * 0.8,
                          width: stdButtonHeight * 0.75 * 0.8,
                          decoration: BoxDecoration(
                            color: context.theme.primaryColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(stdBorderRadius * 2),
                              topLeft: Radius.circular(stdBorderRadius * 2),
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: IconButton(
                              splashRadius: stdButtonHeight * 0.75 * 0.45,
                              icon: const Icon(
                                Icons.person_add,
                                color: Colors.white,
                                //size: stdIconSize,
                              ),
                              tooltip: context.strings.tooltip_add_new,
                              onPressed: () => widget.addPlayerCallback?.call(),
                            ),
                          ),
                        ),
                        Container(
                          height: stdButtonHeight * 0.75 * 0.8,
                          width: stdButtonHeight * 0.75 * 0.8,
                          decoration: BoxDecoration(
                            color: context.theme.primaryColor,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(stdBorderRadius),
                              topRight: Radius.circular(stdBorderRadius),
                            ),
                          ),
                          child: ProVersionWrapper(
                            offset: -5,
                            child: FittedBox(
                              child: IconButton(
                                splashRadius: stdButtonHeight * 0.75 * 0.45,
                                icon: const Icon(
                                  Icons.folder_shared,
                                  color: Colors.white,
                                  //size: stdIconSize,
                                ),
                                tooltip: context.strings.tooltip_add_stor,
                                onPressed: () =>
                                    widget.openPlayersListCallback?.call(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        )
      : const SizedBox();
}
