import 'package:flutter/material.dart';

import '../../app/theme_provider.dart';
import '../../utils/extensions.dart';
import '../../utils/logs.dart';
import '../../utils/theme/themes.dart';
import '../../utils/theme/ui_values.dart';
import '../common/widgets/chips_image.dart';
import 'init_page_view_model.dart';

class InitPage extends StatefulWidget {
  final InitPageViewModel viewModel;
  const InitPage({
    required this.viewModel,
    super.key,
  });

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  bool _animationDone = false;
  bool _initDone = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    //TODO: Выпилить это говно
    final data = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.single,
    ).systemGestureInsets;
    stdCutoutWidth = data.top;
    stdCutoutWidthDown = data.bottom;

    stdCutoutWidth = stdCutoutWidth >= 48 ? stdCutoutWidth : 0;
    stdCutoutWidthDown = stdCutoutWidthDown > 48 ? stdCutoutWidthDown / 2 : 0;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationDone = true;
        _tryNavigate();
      }
    });

    widget.viewModel.addListener(_onInitChanged);

    _controller.forward();
  }

  void _onInitChanged() {
    if (widget.viewModel.value) {
      _initDone = true;
      _tryNavigate();
    }
  }

  void _tryNavigate() {
    if (_navigated) return;
    if (_animationDone && _initDone) {
      _navigated = true;

      logs.writeLog('Switch to HomePage');

      widget.viewModel.pushHomePage();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.viewModel.removeListener(_onInitChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext _) => ThemeProvider(
        theme: Themes.dark(),
        child: Builder(
            builder: (context) => Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      stops: const [
                        0.0,
                        0.175,
                        0.45,
                        0.725,
                        1.0,
                      ],
                      colors: [
                        context.theme.onBackground,
                        context.theme.onBackground,
                        context.theme.primaryColor,
                        context.theme.bgrColor,
                        context.theme.bgrColor,
                      ],
                    ),
                  ),
                  padding: EdgeInsets.only(
                    top: stdCutoutWidth * 0.75,
                    bottom: stdCutoutWidthDown * 0.75,
                  ),
                  child: Scaffold(
                    appBar: AppBar(
                      leading: null,
                      toolbarHeight: stdButtonHeight * 0.75,
                      automaticallyImplyLeading: false,
                      backgroundColor: const Color(0x00000000),
                      iconTheme: IconThemeData(
                        color: context.theme.onBackground,
                      ),
                      elevation: 0,
                    ),
                    backgroundColor: Colors.transparent,
                    body: Center(
                      child: AnimatedBuilder(
                        animation: _opacity,
                        builder: (context, child) => Opacity(
                          opacity: _opacity.value,
                          child: child,
                        ),
                        child: Container(
                          width: stdButtonWidth,
                          margin: EdgeInsets.only(
                            bottom: adaptiveOffset,
                            left: adaptiveOffset,
                            right: adaptiveOffset,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AspectRatio(
                                  aspectRatio: 0.8,
                                  child: ChipsImage(),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          'POCKET CHIPS',
                                          textAlign: TextAlign.center,
                                          style: context.theme.appBarStyle
                                              .copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: stdFontSize * 2.35,
                                            color: context.theme.primaryColor,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'created by goliksim',
                                        style:
                                            context.theme.appBarStyle.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: stdFontSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
      );
}
