import 'package:flutter/widgets.dart';

class LobbyScrollController {
  final ScrollController scrollController = ScrollController();

  void dispose() {
    scrollController.dispose();
  }
}
