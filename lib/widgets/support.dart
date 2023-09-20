import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';


//import '../business/myTargetAds.dart.txt';
import '../business/revenue.dart';
import '../business/unityAds.dart';
import '../data/storage.dart';
import '../data/uiValues.dart';
import '../ui/ui_widgets.dart';


class DonateWindow extends StatefulWidget {
  const DonateWindow({Key? key, required this.callbackFunction, this.onWillPop = false}) : super(key: key);

  final Function() callbackFunction;
  final bool onWillPop;
  @override
  State<DonateWindow> createState() => _DonateWindowState();
}

class _DonateWindowState extends State<DonateWindow> {
  CustomerInfo? _customerInfo;
  List<StoreProduct>? _storeProducts;

  bool loaded = false;

  
  @override
  void initState() {
    super.initState();
    initPlatformState();
    //Unity Ads
    unityInit(unityLoaded);
    
    
    //loadRevenueCat();
    //mytargetInit(myTargetLoaded);
  }



  void unityLoaded(bool result){
    setState(() {
        loaded = result;
      }); 
  }

  void myTargetLoaded(bool result){
    setState(() {
        loaded = result;
      }); 
  }

  void unityAdsShow(){
    placements[UnityAdManager.interstitialVideoAdPlacementId] == true && loaded
                      ? showAd(UnityAdManager.rewardedVideoAdPlacementId,unityLoaded)
                      : null;
  }

  /*
  void mytargetShow(){
    print('show');
    if (interstitialAd == null) {
        showToast('Ad not created');
      } else {
        interstitialAd!.show();
        createAd(MyTargetManager.slotId);
      }
  }
  */

  Future<void> initPlatformState() async {
    
    if (Platform.isIOS){
      StoreConfig(
        store: Stores.appleStore,
        apiKey: appleApiKey,
      );
    }
    else {
      StoreConfig(
        store: Stores.appleStore,
        apiKey: googleApiKey,
      );
    }
    await Purchases.setDebugLogsEnabled(true);
    
    PurchasesConfiguration configuration;
    configuration = PurchasesConfiguration(StoreConfig.instance.apiKey);
  
    //CONFIGURE
    await Purchases.configure(configuration);
  
    await Purchases.enableAdServicesAttributionTokenCollection();

    final customerInfo = await Purchases.getCustomerInfo();
    
    Purchases.addReadyForPromotedProductPurchaseListener(
        (productID, startPurchase) async {
      logs.writeLog('Received readyForPromotedProductPurchase event for '
          'productID: $productID');

      try {
        final purchaseResult = await startPurchase.call();
        logs.writeLog('Promoted purchase for productID '
            '${purchaseResult.productIdentifier} completed, or product was'
            'already purchased. customerInfo returned is:'
            ' ${purchaseResult.customerInfo}');
      } on PlatformException catch (e) {
        logs.writeLog('Error purchasing promoted product: ${e.message}');
      }
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _customerInfo = customerInfo;
    });

    fetchData();
  }

  Future<void> fetchData() async {
    List<StoreProduct> products = [];
    
    try {
      for (String name in ['modest_donat','nice_donat','huge_donat']){
        var product = await Purchases.getProducts([name],type: PurchaseType.inapp);
        products.add(product[0]);
      }
      ;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _storeProducts = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: thisTheme.bgrColor, //Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
          vertical: stdHorizontalOffset,
          horizontal:
              adaptiveOffset), //windowInitialization(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(stdBorderRadius))),
      child: SizedBox(
        width: stdButtonWidth,
        height: 485.h,
        child: PatternContainer(
          opacity: 0.4,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(stdBorderRadius)),
            child: Padding(
              padding:
                  EdgeInsets.all( stdHorizontalOffset * 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Column(children: [
                  Text("support.tittle".tr(),
                    style: TextStyle(
                    color: thisTheme.onBackground,
                    fontWeight: FontWeight.w500,
                    fontSize: stdFontSize
                    ),
                  ),
                  /*
                  !loaded? 
                    Container(
                      height: stdButtonHeight,
                      padding: EdgeInsets.symmetric(vertical: stdHorizontalOffset),
                      child: AspectRatio(aspectRatio: 1, child: const CircularProgressIndicator()),
                    ):MyButton(height: stdButtonHeight,
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(stdBorderRadius),
                    textStyle: stdTextStyle.copyWith(color: thisTheme.onBackground.withOpacity(loaded? 1.0:0.5), fontSize: stdFontSize*0.8),
                    buttonColor: thisTheme.playerColor,
                    textString: 'View interstitial ads',
                    action: placements[AdManager.interstitialVideoAdPlacementId] == true && loaded
                      ? () => showAd(AdManager.interstitialVideoAdPlacementId)
                      : null,
                    ),*/
                ],),
                donateWidget(
                  //text
                  'support.video'.tr(),
                  //icon
                  Icon(
                    MdiIcons.cardsSpade,
                    color: thisTheme.onBackground,
                    size: stdIconSize*1.15
                  ),
                  //button           
                  loaded? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.smart_display, 
                        color: Colors.deepPurpleAccent,
                        size: stdIconSize*1.25,),
                  
                      FittedBox(child: Padding(padding: EdgeInsets.all(stdHorizontalOffset/2),child: Text('support.free'.tr(),style: TextStyle(color: thisTheme.onBackground,))))
                      ],
                    ):Padding(
                      padding: EdgeInsets.all(stdHorizontalOffset*2.5),
                      child: const CircularProgressIndicator(strokeWidth: 3)
                      ),
                      //action
                      //mytargetShow
                      unityAdsShow         //РИСОВАТЬ РЕКЛАМУ <------------------------           
                ),
                donateWidget(
                  //text
                  'support.modest'.tr(),
                  //icon
                  Image.asset("assets/chips/chips_50.png"),
                     
                  //button         
                  _storeProducts==null||_storeProducts!.isEmpty? Padding(
                      padding: EdgeInsets.all(stdHorizontalOffset*2.5),
                      child: const CircularProgressIndicator(strokeWidth: 3)
                      ): Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${_storeProducts![0].price}\n${_storeProducts![0].currencyCode}', textAlign: TextAlign.center,  style: TextStyle(color: Colors.deepPurpleAccent,fontSize: stdFontSize*0.9)),
                      //Text('Buy',style: TextStyle(color: thisTheme.onBackground,fontSize: stdFontSize*0.7))
                      ],
                   ),
                //action     
                ()async 
                  {
                  try{
                    await Purchases.purchaseProduct('modest_donat');
                  }
                  catch (e){
                    //String message = '$e';
                    showToast('toast.unav'.tr());
                    //showToast(message.substring(0,20));
                  }
                  }
                ),
                donateWidget(
                  //text
                  'support.nice'.tr(),
                  //icon          
                  Image.asset("assets/chips/chips_500.png"),  
                  //button         
                 _storeProducts==null||_storeProducts!.isEmpty? Padding(
                      padding: EdgeInsets.all(stdHorizontalOffset*2.5),
                      child: const CircularProgressIndicator(strokeWidth: 3)
                      ):Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${_storeProducts![1].price}\n${_storeProducts![0].currencyCode}', textAlign: TextAlign.center,  style: TextStyle(color: Colors.deepPurpleAccent,fontSize: stdFontSize*0.9)),
                      //Text('Buy',style: TextStyle(color: thisTheme.onBackground,fontSize: stdFontSize*0.7))
                      ],
                   ),
                //action     
                ()async {
                  try{
                    await Purchases.purchaseProduct('nice_donat');
                  }
                  catch (e){
                    //String message = '$e';
                    showToast('toast.unav'.tr());
                    //showToast(message.substring(0,20));
                  }
                  },
                ),
                donateWidget(
                  //text
                  'support.huge'.tr(),
                  //icon
                  Image.asset("assets/chips/chips_5000.png"),   
                  //button         
                  _storeProducts==null||_storeProducts!.isEmpty? Padding(
                      padding: EdgeInsets.all(stdHorizontalOffset*2.5),
                      child: const CircularProgressIndicator(strokeWidth: 3)
                      ):Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${_storeProducts![2].price}\n${_storeProducts![0].currencyCode}', textAlign: TextAlign.center, style: TextStyle(color: Colors.deepPurpleAccent,fontSize: stdFontSize*0.9)),
                      //Text('Buy',style: TextStyle(color: thisTheme.onBackground,fontSize: stdFontSize*0.7))
                      ],
                   ),
                //action     
                //(){showToast('Not availible now');},
                ()async {
                  try{
                    await Purchases.purchaseProduct('huge_donat');
                  }
                  catch (e){
                    //String message = '$e';
                    showToast('toast.unav'.tr());
                    //showToast(message.substring(0,20));
                  }
                  },
                ),
                  MyButton(
                  side: BorderSide(width: 1.5, color: thisTheme.secondaryColor.withOpacity(0.6)),  
                  height: stdButtonHeight*0.6,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(stdBorderRadius),
                  textStyle: stdTextStyle.copyWith(color: thisTheme.secondaryColor.withOpacity(0.6), fontSize: stdFontSize*0.8),
                  buttonColor: thisTheme.bgrColor,
                  textString: 'support.close'.tr(),
                  action: () async {
                    Navigator.pop(context); 
                    //const url = 'https://github.com/goliksim';
                    //if (!await launch(url)) throw 'Could not launch $url';
                  },
                  ),
                ],
              )
            ),
          ),
        ),
      ),
    );
  }

  Widget donateWidget(text, icon, button,action) => SizedBox(height: stdButtonHeight,
                          width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                                      color: thisTheme.bankColor,
                                                      borderRadius: BorderRadius.circular(stdBorderRadius),                                            
                                                    ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: stdButtonHeight/4,
                                    ),
                                  SizedBox(
                                    width: stdButtonHeight/1.75,
                                    height: stdButtonHeight,
                                    child: AspectRatio(aspectRatio: 1, child: icon,
                                    ),
                                  ),
                                  SizedBox(
                                    width: stdHorizontalOffset,
                                    ),
                                  Expanded(child: Text(text,textAlign: TextAlign.center, style: stdTextStyle.copyWith(color: thisTheme.onBackground, fontSize: stdFontSize*0.8))),
                              SizedBox(
                                    width: stdHorizontalOffset,
                                    ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: stdHorizontalOffset/2),
                        AspectRatio(aspectRatio: 1, child: 
                            MyButton(
                              height: stdButtonHeight,
                              width: double.infinity,
                              borderRadius: BorderRadius.circular(stdBorderRadius),
                              buttonColor: thisTheme.playerColor,
                              child: button,
                              action: action,
                            ))
                      ],
                  ),
                );
}

