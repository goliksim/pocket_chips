// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onboarding/onboarding.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../../data/config_model.dart';
import '../../../../../internal/localization.dart';
import '../../../../../ui/dialog_widget.dart';
//import 'package:in_app_review/in_app_review.dart';

import '../../data/storage.dart';
import '../../data/uiValues.dart';
import '../../ui/ui_widgets.dart';

class OnboardingDialog extends StatefulWidget {
  const OnboardingDialog({
    super.key,
    this.callbackFunction,
    required this.packageInfo,
    required this.pages,
  });

  final List<PageModel> pages;
  final Function()? callbackFunction;
  final PackageInfo packageInfo;
  @override
  State<OnboardingDialog> createState() => _OnboardingDialogState();
}

class _OnboardingDialogState extends State<OnboardingDialog> {
  late Material materialButton;
  late int index;

  @override
  void initState() {
    super.initState();
    //materialButton = _skipButton();
    index = 0;
  }

  Widget _skipButton({void Function(int)? setIndex, required int finalIndex}) {
    return MyButton(
      buttonColor: thisTheme.bankColor,
      height: stdButtonHeight * 0.75,
      textString: context.locale.about_skip,
      textStyle: stdTextStyle.copyWith(fontSize: stdFontSize),
      action: () {
        if (setIndex != null) {
          index = finalIndex;
          setIndex(index);
        }
      },
    );
  }

  Widget get _finishButton {
    return MyButton(
      buttonColor: thisTheme.primaryColor,
      height: stdButtonHeight * 0.75,
      textString: context.locale.about_end,
      action: () {
        thisConfig.firstTime = false;
        configStorage.write(thisConfig);
        //print(thisConfig.firstTime);
        Navigator.pop(context);
      },
    );
  }

  void callBack() {
    setState(() {});
    //print('tutor setstate');
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      child: Onboarding(
        //Pages
        pages: widget.pages,
        onPageChange: (int pageIndex) {
          index = pageIndex;
        },
        startPageIndex: 0,
        //Indicator and button
        footerBuilder: (context, dragDistance, pagesLength, setIndex) {
          return Container(
            //height: stdButtonHeight*0.75,
            color: const Color(0x00000000), //!!!!!!!!!!!!!!
            child: Padding(
              padding: EdgeInsets.only(
                left: 20.h,
                right: 20.h,
                top: stdButtonHeight * 0.125,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: CustomIndicator(
                      netDragPercent: dragDistance,
                      pagesLength: pagesLength,
                      indicator: Indicator(
                        activeIndicator: const ActiveIndicator(
                          color: Colors.grey,
                          borderWidth: 0.7,
                        ),
                        closedIndicator: ClosedIndicator(
                          color: thisTheme.primaryColor.withOpacity(0.5),
                          borderWidth: 0.7,
                        ),
                        indicatorDesign: IndicatorDesign.polygon(
                          polygonDesign: PolygonDesign(
                            polygon: DesignType.polygon_diamond,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: index == pagesLength - 1
                        ? _finishButton
                        : _skipButton(
                            setIndex: setIndex,
                            finalIndex: pagesLength - 1,
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.children,
    required this.title,
  });
  final List<Widget> children;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(
          //top: stdHorizontalOffset,
          left: stdHorizontalOffset / 2,
          right: stdHorizontalOffset / 2,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(stdBorderRadius)),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: thisTheme.playerColor,
              border: Border.all(
                width: 0.0,
                color: const Color(0x00000000),
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: ScrollController(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: stdHorizontalOffset),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    //style: pageTitleStyle,
                    style: TextStyle(
                      color: thisTheme.onBackground,
                      fontWeight: FontWeight.w700,
                      fontSize: stdFontSize / 20 * 23,
                    ),
                    //textAlign: TextAlign.left,
                  ),
                  SizedBox(height: stdHorizontalOffset / 2),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: stdHorizontalOffset * 2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: children,
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
