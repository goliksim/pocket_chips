import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pocket_chips/internal/cards/card_model.dart' as c;

class CardWidget extends StatelessWidget {
  const CardWidget({super.key, required this.card});
  final c.Card card;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red,
      child: SizedBox(
        height: 100.h,
      ),
    );
  }
}
