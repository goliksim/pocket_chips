import 'dart:async';

import 'package:flutter/material.dart';

import '../../../utils/extensions.dart';

class GameTitleWidget extends StatefulWidget {
  final String gameState;
  final String? player;

  const GameTitleWidget({
    super.key,
    required this.gameState,
    this.player,
  });

  @override
  GameTitleWidgetState createState() => GameTitleWidgetState();
}

class GameTitleWidgetState extends State<GameTitleWidget> {
  String? _temporaryStateText;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _temporaryStateText = widget.gameState;

    _startTimer();
  }

  @override
  void didUpdateWidget(GameTitleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.gameState != oldWidget.gameState) {
      setState(() {
        _temporaryStateText = widget.gameState;
      });
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _temporaryStateText = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerText = widget.player != null
        ? '${context.strings.game_turn} ${widget.player}'
        : null;

    final displayText = _temporaryStateText ?? playerText ?? widget.gameState;
    final primaryText = displayText != playerText;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) =>
          FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: _ScrollingText(
        key: ValueKey<String>(displayText),
        text: displayText,
        style: TextStyle(
          color: primaryText
              ? context.theme.primaryColor
              : context.theme.onBackground,
        ),
      ),
    );
  }
}

class _ScrollingText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const _ScrollingText({
    super.key,
    required this.text,
    this.style,
  });

  @override
  State<_ScrollingText> createState() => _ScrollingTextState();
}

class _ScrollingTextState extends State<_ScrollingText> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _manageScrolling());
  }

  @override
  void didUpdateWidget(_ScrollingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _manageScrolling());
    }
  }

  @override
  void dispose() {
    _isScrolling = false;
    _scrollController.dispose();
    super.dispose();
  }

  void _manageScrolling() {
    if (!mounted) return;

    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0.0);
    }

    final bool needsScrolling = _scrollController.hasClients &&
        _scrollController.position.maxScrollExtent > 0;

    if (needsScrolling && !_isScrolling) {
      _isScrolling = true;
      _scrollLoop();
    } else if (!needsScrolling && _isScrolling) {
      _isScrolling = false;
    }
  }

  void _scrollLoop() async {
    while (_isScrolling && mounted) {
      await Future.delayed(const Duration(seconds: 5));
      if (!_isScrolling || !mounted) return;

      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent > 0) {
        final scrollDuration = Duration(
            milliseconds:
                (_scrollController.position.maxScrollExtent * 40).toInt());

        await _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: scrollDuration,
          curve: Curves.easeInOutCubic,
        );

        await Future.delayed(const Duration(seconds: 5));
        if (!_isScrolling || !mounted) return;

        await _scrollController.animateTo(
          0.0,
          duration: scrollDuration,
          curve: Curves.easeInOutCubic,
        );
      } else {
        await Future.delayed(const Duration(seconds: 5));
      }
    }
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        physics: const NeverScrollableScrollPhysics(),
        child: Text(
          widget.text,
          style: widget.style,
          overflow: TextOverflow.fade,
        ),
      );
}
