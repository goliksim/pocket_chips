import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class EmptyAssetFilter {
  static ColorFilter filter(String playerUid) => ColorFilter.mode(
        HSVColor.fromAHSV(
          1,
          (playerUid.hashCode.abs() % 360).toDouble(),
          0.4,
          1.0,
        ).toColor(),
        BlendMode.color,
      );
}
