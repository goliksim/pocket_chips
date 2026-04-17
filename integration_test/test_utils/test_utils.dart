import 'package:pocket_chips/domain/model_holders/config_model_holder.dart';
import 'package:pocket_chips/domain/models/config_model.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';
import 'package:pocket_chips/services/assets_provider.dart';

Future<ConfigModel> defaultConfig() async {
  final version = await ConfigModelHolder.getCurrentVersion();

  return ConfigModel(
    isDark: false,
    firstLaunch: false,
    locale: 'en',
    version: version,
  );
}

List<PlayerModel> buildPlayers(
  int count, {
  int startIndex = 0,
  String namePrefix = 'name',
}) =>
    List.generate(
      count,
      (index) => PlayerModel(
        uid: 'test_uid_${startIndex + index}',
        name: '${namePrefix}_${startIndex + index}',
        assetUrl: AssetsProvider.emptyPlayerAsset,
      ),
    );
