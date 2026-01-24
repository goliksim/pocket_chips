import 'dart:io';

import 'package:flutter/material.dart';

import '../../services/assets_provider.dart';

class PlayerAvatar extends StatelessWidget {
  final String assetUrl;
  final double? radius;
  final ColorFilter? colorFilter;
  final FilterQuality? filterQuality;

  const PlayerAvatar({
    required this.assetUrl,
    this.radius,
    this.colorFilter,
    this.filterQuality,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isFile = !assetUrl.startsWith('assets/');

    final imageProvider = isFile
        ? Image.file(
            File(assetUrl),
            errorBuilder: (context, error, stackTrace) =>
                Image.asset(AssetsProvider.emptyPlayerAsset),
          )
        : Image.asset(assetUrl);

    return Container(
      width: radius != null ? radius! * 2 : null,
      height: radius != null ? radius! * 2 : null,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: imageProvider.image,
          fit: BoxFit.cover,
          colorFilter: colorFilter,
          filterQuality: filterQuality ?? FilterQuality.medium,
          onError: (exception, stackTrace) =>
              AssetImage(AssetsProvider.emptyPlayerAsset),
        ),
      ),
    );
  }
}
