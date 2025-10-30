// Static Raise Window
import 'package:flutter/material.dart';

import '../../../../../utils/theme/ui_values.dart';
import '../view_state/game_page_control_state.dart';
import 'raise_provider.dart';

class RaiseFieldWidget extends StatefulWidget {
  final RaiseControlState state;

  const RaiseFieldWidget({
    required this.state,
    super.key,
  });

  @override
  RaiseFieldWidgetState createState() => RaiseFieldWidgetState();
}

class RaiseFieldWidgetState extends State<RaiseFieldWidget> {
  late List<int> _chipsToShow;

  static const List<int> _chipsValues = [
    1,
    5,
    10,
    25,
    50,
    100,
    500,
    1000,
    5000,
    10000
  ];

  @override
  void initState() {
    super.initState();

    _chipsToShow = _getChipsFromBetRange(
      widget.state.maxPossibleBet - widget.state.minPossibleBet,
    );
  }

  List<int> _getChipsFromBetRange(int betRange) =>
      _chipsValues.where((value) => value <= betRange).toList();

  @override
  Widget build(BuildContext context) {
    final provider = CurrentBetValueProvider.of(context);
    final currentBet = provider.currentBet;

    return ClipRRect(
      borderRadius: BorderRadius.circular(stdBorderRadius),
      child: ColoredBox(
        color: thisTheme.playerColor,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                stdHorizontalOffset / 2,
                stdHorizontalOffset / 2,
                stdHorizontalOffset / 2,
                0,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(stdButtonHeight * 0.75),
                child: _CoinsRow(
                  onTap: (coin) {
                    if (currentBet + coin <= widget.state.maxPossibleBet) {
                      provider.changeBet(currentBet + coin);
                    }
                  },
                  chips: _chipsToShow,
                ),
              ),
            ),
            _RaiseSlider(
              minBet: widget.state.minPossibleBet,
              maxBet: widget.state.maxPossibleBet,
              value: currentBet,
              onChanged: (newValue) {
                provider.changeBet(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

//Слайдер с кнопками фишек
class _CoinsRow extends StatelessWidget {
  const _CoinsRow({
    required this.onTap,
    required this.chips,
  });
  final Function(int) onTap;
  final List<int> chips;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min, // <-- notice 'min' here. Important
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (int coin in chips)
            Container(
              width: stdButtonHeight * 0.75,
              height: stdButtonHeight * 0.75,
              margin: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 2.5,
              ),
              //padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: thisTheme.playerColor,
                borderRadius: BorderRadius.circular(stdBorderRadius),
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      stdBorderRadius,
                    ),
                  ),
                ),
                child: Image.asset(
                  'assets/chips/chips_$coin.png',
                  filterQuality: FilterQuality.medium,
                ),
                onPressed: () => onTap(coin),
              ),
            ),
        ],
      ),
    );
  }
}

//Слайдер выбора ставки
class _RaiseSlider extends StatefulWidget {
  const _RaiseSlider({
    required this.minBet,
    required this.maxBet,
    required this.value,
    required this.onChanged,
  });
  final int minBet;
  final int value;
  final int maxBet;
  final Function(int) onChanged;
  @override
  State<_RaiseSlider> createState() => _RaiseSliderState();
}

class _RaiseSliderState extends State<_RaiseSlider> {
  late int tmpBid;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant _RaiseSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    tmpBid = widget.value;
  }

  @override
  void initState() {
    tmpBid = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: stdHorizontalOffset),
      child: SizedBox(
        height: stdButtonHeight * 0.75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.minBet}',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: stdFontSize,
                color: thisTheme.onBackground,
              ),
            ),
            SizedBox(width: stdHorizontalOffset / 2),
            Flexible(
              flex: 6,
              fit: FlexFit.tight,
              child: Slider(
                label: '$tmpBid',
                value: tmpBid.toDouble(),
                onChanged: (newValue) {
                  widget.onChanged(newValue.toInt());

                  setState(() {
                    tmpBid = newValue.toInt();
                  });
                },
                min: widget.minBet.toDouble(),
                max: widget.maxBet.toDouble(),
              ),
            ),
            SizedBox(width: stdHorizontalOffset / 2),
            Text(
              '${widget.maxBet}',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: stdFontSize,
                color: thisTheme.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
