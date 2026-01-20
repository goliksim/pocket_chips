import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';

import '../../common/widgets/dialog_widget.dart';
import '../../onboading/pages/onboarding_pro_version_page.dart';

class ProVersionOfferPage extends StatelessWidget {
  const ProVersionOfferPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => DialogWidget(
        child: Onboarding(
          pages: [
            PageModel(
              widget: OnboardingProVersionPage(),
            ),
          ],
        ),
      );
}
