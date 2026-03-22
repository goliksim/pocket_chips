import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../services/assets_provider.dart';
import '../../../../utils/extensions.dart';
import '../../../../utils/theme/ui_values.dart';
import '../view_state/donation_lead_item.dart';

class DonationLeadBuilder extends StatelessWidget {
  final DonationLeadItem item;

  const DonationLeadBuilder({
    required this.item,
    super.key,
  });

  @override
  Widget build(BuildContext context) => item.map(
        videoAd: (_) => FittedBox(
          child: Icon(
            Icons.smart_display,
            color: context.theme.alertColor,
            size: stdIconSize * 3.25,
          ),
        ),
        pro: (_) => FittedBox(
          child: Icon(
            Icons.rocket_launch_rounded,
            color: context.theme.primaryColor,
            size: stdIconSize * 3.25,
          ),
        ),
        chips: (item) => Image(
          image: AssetsProvider.chipsByValue(item.chipsValue).image,
          errorBuilder: (_, __, ___) => CircleAvatar(
            child: Icon(
              MdiIcons.pokerChip,
              size: stdIconSize,
            ),
          ),
        ),
        loading: (_) => Icon(
          Icons.shopping_basket,
          color: context.theme.hintColor,
          size: stdIconSize * 3.25,
        ),
      );
}
