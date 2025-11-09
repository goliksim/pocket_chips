import 'package:flutter/material.dart';

class AssetsProvider {
  static const String _chipsAssets = 'assets/chips';

  static Image chipsByValue(int value) => Image.asset(
        '$_chipsAssets/chips_$value.png',
        filterQuality: FilterQuality.medium,
      );

  static const ImageProvider dealerAsset =
      AssetImage('$_chipsAssets/dealer.png');

  static String playerAssetByIndex(int value) =>
      'assets/faces/pokerfaces${value + 1}.jpg';

  static ImageProvider playerIconByIndex(int value) =>
      AssetImage('assets/faces/pokerfaces${value + 1}.jpg');

  static ImageProvider get playerIconEditFrame =>
      AssetImage('assets/faces/edit_frame.png');

  static const String emptyPlayerAsset = 'assets/faces/pokerfaces_empty.jpg';

  static Image get socialGitIcon => Image.asset('assets/social/git.png');
  static Image get socialMainIcon => Image.asset('assets/social/main.png');
  static Image get socialTelegramIcon => Image.asset('assets/social/tele.png');

  static ImageProvider cardBack(bool isDark) =>
      AssetImage('assets/сard_back${isDark ? '_dark' : ''}.jpg');

  static ImageProvider cardFront(bool isDark) =>
      AssetImage('assets/card_front${isDark ? '_dark' : ''}.png');

  static ImageProvider table(bool isDark) =>
      AssetImage('assets/table${isDark ? '_dark' : '_light'}.png');

  static ImageProvider get mainChipsLogo => AssetImage('assets/init_logo.png');

  static ImageProvider get backgroundPattern =>
      AssetImage('assets/pattern.png');
}
