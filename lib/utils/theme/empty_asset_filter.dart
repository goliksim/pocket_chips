import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EmptyAssetFilter extends ColorFilter {
  EmptyAssetFilter(String playerUid)
      : super.mode(
          HSVColor.fromAHSV(
            1,
            (playerUid.hashCode.abs() % 360).toDouble(),
            0.4,
            1.0,
          ).toColor(),
          BlendMode.color,
        );
}
