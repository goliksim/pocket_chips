enum AppPage {
  init('init'),
  menu('menu'),
  lobby('lobby'),
  game('game');

  final String _name;

  String get path => '/$_name';
  String get routeName => _name;

  const AppPage(this._name);
}
