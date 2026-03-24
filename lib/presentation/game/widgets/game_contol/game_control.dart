import 'package:flutter/material.dart';

import '../../../../utils/theme/ui_values.dart';
import 'breakdown_buttons.dart';
import 'control_buttons.dart';
import 'raise/raise_buttons.dart';
import 'raise/raise_field.dart';
import 'raise/raise_provider.dart';
import 'view_model/game_control_view_model.dart';
import 'view_state/game_page_control_state.dart';

class GameControl extends StatefulWidget {
  final GameControlViewModel viewModel;

  const GameControl({
    required this.viewModel,
    super.key,
  });

  @override
  State<GameControl> createState() => _GameControlState();
}

class _GameControlState extends State<GameControl> {
  late bool raiseButtonPressed;

  @override
  void initState() {
    raiseButtonPressed = false;
    super.initState();
  }

  GamePageControlState get state => widget.viewModel.controlsState;

  void changeRaiseBool(bool value) {
    setState(() {
      raiseButtonPressed = value;
    });
  }

  @override
  void didUpdateWidget(covariant GameControl oldWidget) {
    raiseButtonPressed = false;

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => _InheritedWrapper(
        state: state,
        child: Builder(
          builder: (context) => Column(
            children: [
              state.maybeMap(
                active: (activeState) => SizedBox(
                  height: stdButtonHeight * 1.6,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) =>
                            FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.1),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.ease,
                          ),
                        ),
                        child: child,
                      ),
                    ),
                    child: SizedBox(
                      height:
                          2 * stdButtonHeight * 0.75 + stdHorizontalOffset / 2,
                      key: ValueKey(raiseButtonPressed),
                      child: raiseButtonPressed
                          ? RaiseFieldWidget(
                              maxPossibleBet:
                                  activeState.raiseState.maxPossibleBet,
                              minPossibleBet:
                                  activeState.raiseState.minPossibleBet,
                              minRuleBet: activeState.raiseState.minRuleBet,
                              currentBet: activeState.raiseState.currentBet,
                            )
                          : null,
                    ),
                  ),
                ),
                orElse: () => SizedBox(
                  height: stdButtonHeight * 1.6,
                  child: null,
                ),
              ),
              SizedBox(height: stdHorizontalOffset),
              // Bottom button panel
              state.map(
                active: (activeState) => raiseButtonPressed
                    ? RaiseButtons(
                        state: activeState.raiseState,
                        onConfirm: widget.viewModel.onControlAction,
                        onClose: () => changeRaiseBool(false),
                      )
                    : ControlButtons(
                        controlAction: widget.viewModel.onControlAction,
                        state: activeState,
                        openRaiseField: () => changeRaiseBool(true),
                      ),
                breakdown: (breakdownState) => BreakdownButtons(
                  canStartBetting: breakdownState.canStartBetting,
                  openSettings: () => widget.viewModel.openSettings(),
                  startBetting: () => widget.viewModel.startBetting(),
                ),
                showdown: (_) => SizedBox(
                  height: stdButtonHeight,
                ),
              ),
            ],
          ),
        ),
      );
}

class _InheritedWrapper extends StatelessWidget {
  final GamePageControlState state;
  final Widget child;

  const _InheritedWrapper({
    required this.state,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => state.map(
        active: (activeState) => RaiseProviderScope(
          additionalBet: activeState.raiseState.minRuleBet,
          child: child,
        ),
        breakdown: (_) => child,
        showdown: (value) => child,
      );
}
