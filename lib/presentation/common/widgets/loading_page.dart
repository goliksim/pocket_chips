import 'package:flutter/material.dart';

import 'ui_widgets.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) => PatternBackground(
          child: Center(
        child: CircularProgressIndicator(),
      ));
}
