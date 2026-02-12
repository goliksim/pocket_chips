import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/keys/keys.dart';
import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../../monitization/pro_version/widgets/pro_version_wrapper.dart';

class AddPlayerButton extends StatefulWidget {
  final VoidCallback? addPlayerCallback;
  final VoidCallback? openPlayersListCallback;

  const AddPlayerButton({
    this.addPlayerCallback,
    this.openPlayersListCallback,
    super.key,
  });

  @override
  State<AddPlayerButton> createState() => _AddPlayerButtonState();
}

class _AddPlayerButtonState extends State<AddPlayerButton> {
  bool addButtonPressed = false;
  Timer? _expandedButtonTimer;

  @override
  void dispose() {
    _expandedButtonTimer?.cancel();
    super.dispose();
  }

  void _onMainButtonPressed() {
    setState(() {
      addButtonPressed = true;
    });
    _expandedButtonTimer?.cancel();
    _expandedButtonTimer = Timer(
      const Duration(seconds: 10),
      () {
        if (mounted) {
          setState(() {
            addButtonPressed = false;
          });
        }
      },
    );
  }

  void _forceClose() {
    _expandedButtonTimer?.cancel();
    if (mounted) {
      setState(() {
        addButtonPressed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
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
                decoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  borderRadius: BorderRadius.circular(stdBorderRadius * 2),
                ),
                child: FittedBox(
                  child: IconButton(
                    key: GameTableKeys.addMainButton,
                    tooltip: context.strings.tooltip_add_main,
                    splashRadius: stdButtonHeight * 0.75 * 0.45,
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: stdIconSize * 1.5,
                    ),
                    onPressed: () => _onMainButtonPressed(),
                  ),
                ),
              )
            : Row(
                key: const ValueKey('2'),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(stdBorderRadius * 2),
                        topLeft: Radius.circular(stdBorderRadius * 2),
                      ),
                    ),
                    child: FittedBox(
                      child: IconButton(
                        key: GameTableKeys.addNewPlayerButton,
                        splashRadius: stdButtonHeight * 0.75 * 0.45,
                        icon: Icon(
                          Icons.person_add,
                          color: Colors.white,
                          size: stdIconSize * 1.5,
                        ),
                        tooltip: context.strings.tooltip_add_new,
                        onPressed: () {
                          _forceClose();
                          widget.addPlayerCallback?.call();
                        },
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(stdBorderRadius),
                        topRight: Radius.circular(stdBorderRadius),
                      ),
                    ),
                    child: FittedBox(
                      child: ProVersionWrapper(
                        offset: -10.h,
                        child: IconButton(
                          key: GameTableKeys.addSavedPlayerButton,
                          splashRadius: stdButtonHeight * 0.75 * 0.45,
                          icon: Icon(
                            Icons.folder_shared,
                            color: Colors.white,
                            size: stdIconSize * 1.5,
                          ),
                          tooltip: context.strings.tooltip_add_stor,
                          onPressed: () {
                            _forceClose();
                            widget.openPlayersListCallback?.call();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      );
}
