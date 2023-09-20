import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../data/uiValues.dart';

//Всплывающие уведомления
Future<bool?> toastWarning(String text) =>Fluttertoast.showToast(
        msg: text, // message
        fontSize: stdFontSize*0.75,
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.BOTTOM, // location
        timeInSecForIosWeb: 1,
        backgroundColor: thisTheme.bgrColor,
        textColor: thisTheme.onBackground, // duration
      );
  
void showToast(String text) async{
  try{
    await toastWarning(text);
  }
  catch(e){
    // ignore: avoid_print
    print('TOAST ERROR of: $text');
  }
}
//Подтверждение действия
class ConfirmationWindow extends StatelessWidget {
  const ConfirmationWindow({Key? key, required this.type, required this.message, required this.action, required this.button}) : super(key: key);

  final String type;
  final String message;
  final String button;
  final Function action;
  

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
  backgroundColor: thisTheme.bgrColor,
      insetPadding: EdgeInsets.symmetric(
          horizontal: adaptiveOffset ), //windowInitialization(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(stdBorderRadius))),
      child: Container(
          padding: EdgeInsets.all(
            stdHorizontalOffset,
          ),
          width: stdButtonWidth,
          height: stdDialogHeight/1.3,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: stdButtonHeight*0.5,
                  child: Text(type,
                      style: TextStyle(
                          color: thisTheme.onBackground,
                          fontSize: stdFontSize,
                          fontWeight: FontWeight.bold)),
                ),
                Center(
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: thisTheme.onBackground,
                              fontSize: stdFontSize )),
                    ),
                  ),
                
                Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [    
                        Expanded(
                          child: MyButton(height: stdButtonHeight*0.75, 
                          width: double.infinity,
                          buttonColor: thisTheme.bgrColor,
                          textString: button,
                          textStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: thisTheme.subsubmainColor,
                                      fontSize: stdFontSize ,
                                    ),
                          action: () async{
                                //_quickDelete(index)
                                Navigator.of(context).pop(true);
                                action();
                              },
                          ),
                        ),
                        Expanded(
                          child: MyButton(height: stdButtonHeight*0.75, 
                          width: double.infinity,
                          buttonColor: thisTheme.bgrColor,
                          textString: "conf.canc".tr(),
                          textStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: thisTheme.primaryColor,
                                      fontSize: stdFontSize ,
                                    ),
                          action: () => Navigator.of(context).pop(false),
                          ),
                        ),  
                        
                      ]),
                
              ]),
        ),
      );
  }
}

//Класс Большинства кнопочек
class MyButton extends StatelessWidget{
  const MyButton({Key? key,
  this.height,  
  required this.buttonColor,  
  this.action,
  this.borderRadius,
  this.textString,
  this.padding = EdgeInsets.zero,
  this.alignment,
  this.longAction,
  this.width,
  this.child,
  this.textStyle,
  this.side,
 
  }) : assert(textString == null || child == null,
         'Cannot provide both a textString and a child\n'),
         assert(textString != null || child != null,
         'textString or child should be set\n'), super(key: key);

  final double? height;
  final double? width;
  final EdgeInsets padding;
  final Color buttonColor;
  final Function? action;
  final Function? longAction;
  final BorderRadius? borderRadius;
  final String? textString;
  final Alignment? alignment;
  final Widget? child;
  final TextStyle? textStyle;
  final BorderSide? side;


  @override
  Widget build(BuildContext context) {
    return Container(
            height: (height!=null)?height: stdButtonHeight,  
            alignment: alignment,  
            width: (width!=null)?width: stdButtonWidth, 
            child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: side,
                    elevation:stdElevation,
                    shape: RoundedRectangleBorder(
                        borderRadius: (borderRadius!=null)?borderRadius!: BorderRadius.circular(stdBorderRadius)
                    ),
                    padding: padding,
                    foregroundColor: thisTheme.bgrColor,
                    backgroundColor: buttonColor,
                    //textStyle: (textStyle!=null)?textStyle:TextStyle(color: thisTheme.onPrimary, fontFamily: 'Ubuntu' ,fontSize: stdFontSize, fontWeight: FontWeight.w500),
                  ),
                  child: (textString!=null)? Text(textString!, textAlign: TextAlign.center, style: (textStyle!=null)?textStyle: stdTextStyle.copyWith(fontSize: stdFontSize),): child,
                  onPressed: () {
                     if(action != null) action!();
                  },
                  onLongPress: (){
                    if(longAction != null) longAction!();
                  },
                ),
          );
  }
}

//Фон с патерном
class PatternContainer extends StatelessWidget {
  final Widget child;
  final double opacity;
  final EdgeInsets? padding;
   const PatternContainer({Key? key, required this.child, this.opacity=1.0, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      padding: padding,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
          opacity: 0.3*opacity,
          colorFilter: ColorFilter.mode(
            thisTheme.primaryColor,
            BlendMode.srcATop),
          image: const AssetImage(
          'assets/pattern.png'
          ),
        fit: BoxFit.cover,
        ),
      )
    );
  }
}
