import 'package:flutter/material.dart';

import '../../../../../app/keys/keys.dart';
import '../../../../../services/assets_provider.dart';
import '../../../../../utils/extensions.dart';
import '../../../../../utils/theme/ui_values.dart';
import 'raise_provider.dart';

class RaiseFieldWidget extends StatefulWidget {
  final int maxPossibleBet;
  final int minPossibleBet;
  final int currentBet;

  const RaiseFieldWidget({
    required this.maxPossibleBet,
    required this.minPossibleBet,
    required this.currentBet,
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
      widget.maxPossibleBet - widget.minPossibleBet,
    );
  }

  List<int> _getChipsFromBetRange(int betRange) =>
      _chipsValues.where((value) => value <= betRange).toList();

  @override
  Widget build(BuildContext context) {
    final provider = RaiseProviderScope.of(context);

    return ClipRRect(
      key: GameControlKeys.raiseField,
      borderRadius: BorderRadius.circular(stdBorderRadius),
      child: ColoredBox(
        color: context.theme.playerColor,
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
                    final bet = provider.additionalBet;

                    if (bet + coin <= widget.maxPossibleBet) {
                      setState(() {
                        provider.changeBet(bet + coin);
                      });
                    }
                  },
                  chips: _chipsToShow,
                ),
              ),
            ),
            _RaiseSlider(
              minBet: widget.minPossibleBet,
              maxBet: widget.maxPossibleBet,
              currentBet: widget.currentBet,
              value: provider.additionalBet,
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

/// Row with chips buttons
class _CoinsRow extends StatelessWidget {
  const _CoinsRow({
    required this.onTap,
    required this.chips,
  });
  final Function(int) onTap;
  final List<int> chips;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
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
                decoration: BoxDecoration(
                  color: context.theme.playerColor,
                  borderRadius: BorderRadius.circular(stdBorderRadius),
                ),
                child: TextButton(
                  key: GameControlKeys.raiseChip(coin),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        stdBorderRadius,
                      ),
                    ),
                  ),
                  child: Image(
                    image: AssetsProvider.chipsByValue(coin).image,
                    errorBuilder: (_, __, ___) => Container(
                      padding: EdgeInsets.all(stdHorizontalOffset),
                      decoration: BoxDecoration(
                        color: context.theme.secondaryColor,
                        borderRadius: BorderRadius.circular(stdBorderRadius),
                      ),
                      child: FittedBox(
                        child: Text(
                          coin.toCompactBank,
                          style: context.theme.stdTextStyle
                              .copyWith(color: context.theme.onPrimary),
                        ),
                      ),
                    ),
                  ),
                  onPressed: () => onTap(coin),
                ),
              ),
          ],
        ),
      );
}

/// Raise selection slider
class _RaiseSlider extends StatefulWidget {
  final int minBet;
  final int value;
  final int maxBet;
  final int currentBet;
  final Function(int) onChanged;

  const _RaiseSlider({
    required this.minBet,
    required this.maxBet,
    required this.value,
    required this.onChanged,
    required this.currentBet,
  });
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

  int get totalBetMin => widget.minBet + widget.currentBet;
  int get totalBetMax => widget.maxBet + widget.currentBet;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: stdHorizontalOffset),
        child: SizedBox(
          height: stdButtonHeight * 0.75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                totalBetMin.toCompact,
                key: GameControlKeys.raiseMinLabel,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: stdFontSize,
                  color: context.theme.onBackground,
                ),
              ),
              Flexible(
                child: Slider(
                  key: GameControlKeys.raiseSlider,
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
              Text(
                totalBetMax.toCompact,
                key: GameControlKeys.raiseMaxLabel,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: stdFontSize,
                  color: context.theme.onBackground,
                ),
              ),
            ],
          ),
        ),
      );
}
