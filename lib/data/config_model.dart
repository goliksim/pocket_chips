
import 'package:package_info_plus/package_info_plus.dart';

Config thisConfig = Config(0, false, '');


class Config {
  Config([this.themeIndex = 0, this.firstTime = true, this.locale = '']);
  //Theme
  int themeIndex;
  
  //Bool for werlcome page
  bool firstTime;

  //Picked Localization
  String locale;

  //Version controll
  String? version;

  Future<String> getVersion()async{
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  } 

  //пишем в json
  Map toJson() => {'theme': themeIndex, 'first': firstTime, 'locale': locale};
  //читаем из json
  Config.fromJson(Map<String, dynamic> json)
      : themeIndex = json['theme'],
        firstTime = json['first'],
        locale = json['locale'];
}