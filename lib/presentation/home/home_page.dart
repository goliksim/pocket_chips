import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/theme_provider.dart';
import '../../di/domain_managers.dart';
import '../../di/view_models.dart';
import '../../utils/extensions.dart';
import '../../utils/theme/themes.dart';
import '../../utils/theme/ui_values.dart';
import '../common/widgets/attention_button.dart';
import '../common/widgets/chips_image.dart';
import '../common/widgets/ui_widgets.dart';

class AnimatedHomePage extends ConsumerStatefulWidget {
  const AnimatedHomePage({
    super.key,
  });

  @override
  ConsumerState<AnimatedHomePage> createState() => _AnimatedHomePageState();
}

class _AnimatedHomePageState extends ConsumerState<AnimatedHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _themeController;
  late final Animation<double> _themeAnim;
  Themes? _oldTheme;

  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    _themeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _themeAnim = CurvedAnimation(
      parent: _themeController,
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.fastOutSlowIn,
    );

    // When animation completes, drop the old theme so only the new theme remains.
    _themeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isAnimating = false;
        _oldTheme = null;
        // ensure rebuild to remove the underneath old-theme widget
        if (mounted) setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext _) {
    // Listen theme mode changes. Capture previous theme and run animation.
    ref.listen<ThemeMode>(themeManagerProvider, (previous, next) {
      if (previous != null && previous != next) {
        _oldTheme =
            (previous == ThemeMode.dark) ? Themes.dark() : Themes.light();
        _isAnimating = true;
        _themeController.forward(from: 0);
      }
    });

    // If we're animating, render old theme content underneath and new theme
    // content on top inside a ShaderMask that reveals it. Otherwise render
    // single content with current theme.
    final currentTheme = context.theme;

    if (_isAnimating && _oldTheme != null) {
      final old = _oldTheme!;

      return Stack(
        children: [
          // old theme (underneath)
          ThemeProvider(
            theme: old,
            child: HomePage(),
          ),

          // new theme revealed with radial mask
          ThemeProvider(
            theme: currentTheme,
            child: AnimatedBuilder(
              animation: _themeAnim,
              builder: (context, child) => ShaderMask(
                shaderCallback: (rect) => RadialGradient(
                  radius: Tween<double>(begin: 0, end: 15.h).evaluate(
                    CurvedAnimation(
                      parent: _themeAnim,
                      curve: Curves.fastOutSlowIn.flipped,
                      reverseCurve: Curves.fastOutSlowIn,
                    ),
                  ),
                  colors: const [
                    Colors.white,
                    Colors.transparent,
                    Colors.transparent,
                  ],
                  stops: const [0.4, 0.45, 1],
                  center: const FractionalOffset(1.0, 0.0),
                ).createShader(rect),
                child: child,
              ),
              child: HomePage(),
            ),
          ),
        ],
      );
    }

    // default: no animation, just current theme
    return ThemeProvider(
      theme: currentTheme,
      child: HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  final title = 'POCKET CHIPS';

  const HomePage({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final viewModel = ref.watch(homePageViewModelProvider.notifier);
    final asyncState = ref.watch(homePageViewModelProvider);

    final isLoading = asyncState.isLoading;

    final shouldDrawContinue = asyncState.maybeWhen(
      data: (data) => data,
      orElse: () => false,
    );

    return PatternContainer(
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
          centerTitle: true,
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: context.theme.appBarStyle.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: stdFontSize / 20 * 28,
            ),
          ),
          actions: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: IconButton(
                icon: Icon(
                  (context.theme.isDark)
                      ? Icons.nightlight_round
                      : Icons.mode_night_outlined,
                  size: stdIconSize,
                ),
                tooltip: context.strings.tooltip_theme,
                onPressed: () => viewModel.changeTheme(),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: Center(
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
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Continue Button
                              Opacity(
                                opacity: shouldDrawContinue ? 1 : 0.25,
                                child: MyButton(
                                  height: stdButtonHeight,
                                  width: double.infinity,
                                  borderRadius:
                                      BorderRadius.circular(stdBorderRadius),
                                  buttonColor: context.theme.primaryColor,
                                  textString: context.strings.home_cont,
                                  action: () {
                                    if (shouldDrawContinue) {
                                      viewModel.continueGame();
                                    }
                                  },
                                ),
                              ),

                              SizedBox(height: stdHorizontalOffset),
                              //New Game
                              AttentionButton(
                                onTap: () => viewModel.createNewGame(),
                                needToAnimate: () => !shouldDrawContinue,
                                bgColor: shouldDrawContinue
                                    ? context.theme.secondaryColor
                                    : context.theme.primaryColor,
                                textColor: context.theme.onBackground,
                                textWidget: Text(
                                  context.strings.home_new,
                                  style: context.theme.stdTextStyle.copyWith(
                                    fontSize: stdFontSize,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: stdHorizontalOffset,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: MyButton(
                                      height: stdButtonHeight,
                                      borderRadius: BorderRadius.circular(
                                          stdBorderRadius),
                                      buttonColor:
                                          context.theme.additionButtonColor,
                                      textString: context.strings.home_abo,
                                      action: () => viewModel.showAboutInfo(),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: stdHorizontalOffset,
                                      ),
                                      child: MyButton(
                                        height: stdButtonHeight,
                                        borderRadius: BorderRadius.circular(
                                            stdBorderRadius),
                                        buttonColor:
                                            context.theme.additionButtonColor,
                                        textString:
                                            context.strings.home_win_check,
                                        action: () =>
                                            viewModel.showWinnerSolver(),
                                      ),
                                    ),
                                  ),
                                ],
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
    );
  }
}
