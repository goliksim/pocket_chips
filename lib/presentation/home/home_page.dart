// ignore_for_file: file_names
import 'package:flutter/material.dart';

import '../../utils/extensions.dart';
import '../../utils/theme/ui_values.dart';
import '../common/widgets/chips_image.dart';
import '../common/widgets/ui_widgets.dart';
import 'home_page_view_model.dart';

class HomePage extends StatelessWidget {
  final HomePageViewModel viewModel;

  const HomePage({
    required this.viewModel,
    super.key,
  });

  final String title = 'POCKET CHIPS';

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: viewModel,
        builder: (_, __) {
          final shouldDrawContinure =
              viewModel.hasActiveLobby || viewModel.isLoading;

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
                  color: thisTheme.onBackground,
                ),
                elevation: 0,
                centerTitle: true,
                title: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: appBarStyle().copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: stdFontSize / 20 * 28,
                  ),
                ),
                actions: <Widget>[
                  AspectRatio(
                    aspectRatio: 1,
                    child: IconButton(
                      icon: Icon(
                        (thisTheme == themeList[0])
                            ? Icons.mode_night_outlined
                            : Icons.nightlight_round,
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
                        Expanded(
                          child: ChipsImage(),
                        ),
                        SizedBox(
                          height: stdButtonHeight * 2 +
                              stdHorizontalOffset * 2 +
                              (shouldDrawContinure ? stdButtonHeight : 0),
                          child: Column(
                            children: [
                              if (shouldDrawContinure)
                                // Continue Button
                                viewModel.isLoading
                                    ? SizedBox(
                                        height: stdButtonHeight,
                                        width: double.infinity,
                                        child: CircularProgressIndicator(),
                                      )
                                    : MyButton(
                                        height: stdButtonHeight,
                                        width: double.infinity,
                                        borderRadius: BorderRadius.circular(
                                            stdBorderRadius),
                                        buttonColor: thisTheme.primaryColor,
                                        textString: context.strings.home_cont,
                                        action: () => viewModel.continueGame(),
                                      ),
                              SizedBox(height: stdHorizontalOffset),
                              //New Game
                              MyButton(
                                height: stdButtonHeight,
                                width: double.infinity,
                                borderRadius:
                                    BorderRadius.circular(stdBorderRadius),
                                buttonColor: shouldDrawContinure
                                    ? thisTheme.secondaryColor
                                    : thisTheme.primaryColor,
                                textString: context.strings.home_new,
                                action: () => viewModel.createNewGame(),
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
                                          thisTheme.additionButtonColor,
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
                                            thisTheme.additionButtonColor,
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
        },
      );
}
