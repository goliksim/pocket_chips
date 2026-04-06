import 'package:flutter/material.dart';

import '../../../../../app/keys/keys.dart';
import '../../../../../services/assets_provider.dart';
import '../../../../../services/toast_manager.dart';
import '../../../../../utils/extensions.dart';
import '../../../../../utils/theme/ui_values.dart';
import 'raise_provider.dart';

class RaiseFieldWidget extends StatefulWidget {
  final int maxPossibleBet;
  final int minPossibleBet;
  final int minRuleBet;
  final int currentBet;

  const RaiseFieldWidget({
    required this.maxPossibleBet,
    required this.minPossibleBet,
    required this.minRuleBet,
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

  void _changeBet(RaiseProviderScopeState provider, int newValue) {
    final oldValue = provider.additionalBet;

    provider.changeBet(newValue);

    if (newValue < widget.minRuleBet && oldValue >= widget.minRuleBet) {
      ToastManager().showToast(
        context.strings.toast_custom_bet_warning,
      );
    }
  }

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
                        _changeBet(provider, bet + coin);
                      });
                    }
                  },
                  chips: _chipsToShow,
                ),
              ),
            ),
            _RaiseSlider(
              minBet: widget.minPossibleBet,
              minRuleBet: widget.minRuleBet,
              maxBet: widget.maxPossibleBet,
              currentBet: widget.currentBet,
              value: provider.additionalBet,
              onChanged: (newValue) {
                _changeBet(provider, newValue);
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
  final int minRuleBet;
  final int value;
  final int maxBet;
  final int currentBet;
  final Function(int) onChanged;

  const _RaiseSlider({
    required this.minBet,
    required this.minRuleBet,
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

  //TODO bad logic
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
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.transparent,
                    inactiveTrackColor: Colors.transparent,
                    secondaryActiveTrackColor: Colors.transparent,
                    trackShape: _RaiseSliderTrackShape(
                      minimum: widget.minBet,
                      warningLimit: widget.minRuleBet,
                      maximum: widget.maxBet,
                      warningColor: context.theme.alertColor,
                      regularColor: context.theme.secondaryColor,
                      inactiveColor: context.theme.hintColor.withValues(
                        alpha: 0.35,
                      ),
                    ),
                    thumbColor: tmpBid < widget.minRuleBet
                        ? context.theme.alertColor
                        : context.theme.secondaryColor,
                    overlayColor: (tmpBid < widget.minRuleBet
                            ? context.theme.alertColor
                            : context.theme.secondaryColor)
                        .withValues(alpha: 0.15),
                  ),
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

class _RaiseSliderTrackShape extends SliderTrackShape {
  final int minimum;
  final int warningLimit;
  final int maximum;
  final Color warningColor;
  final Color regularColor;
  final Color inactiveColor;

  const _RaiseSliderTrackShape({
    required this.minimum,
    required this.warningLimit,
    required this.maximum,
    required this.warningColor,
    required this.regularColor,
    required this.inactiveColor,
  });

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight ?? 4;
    final trackLeft = offset.dx +
        (sliderTheme.overlayShape
                    ?.getPreferredSize(isEnabled, isDiscrete)
                    .width ??
                0) /
            2;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackWidth = parentBox.size.width -
        (sliderTheme.overlayShape
                ?.getPreferredSize(isEnabled, isDiscrete)
                .width ??
            0);

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    final canvas = context.canvas;
    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final radius = Radius.circular(trackRect.height / 2);
    final trackRRect = RRect.fromRectAndRadius(trackRect, radius);
    canvas.drawRRect(trackRRect, Paint()..color = inactiveColor);

    if (maximum <= minimum) {
      return;
    }

    final warningClamped = warningLimit.clamp(minimum, maximum).toDouble();
    final warningRatio = (warningClamped - minimum) / (maximum - minimum);
    final warningWidth = trackRect.width * warningRatio;

    if (warningWidth > 0) {
      final warningRect = Rect.fromLTWH(
        trackRect.left,
        trackRect.top,
        warningWidth,
        trackRect.height,
      );
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          warningRect,
          topLeft: radius,
          bottomLeft: radius,
          topRight: warningWidth >= trackRect.width ? radius : Radius.zero,
          bottomRight: warningWidth >= trackRect.width ? radius : Radius.zero,
        ),
        Paint()..color = warningColor,
      );
    }

    if (warningWidth < trackRect.width) {
      final regularRect = Rect.fromLTWH(
        trackRect.left + warningWidth,
        trackRect.top,
        trackRect.width - warningWidth,
        trackRect.height,
      );
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          regularRect,
          topLeft: warningWidth <= 0 ? radius : Radius.zero,
          bottomLeft: warningWidth <= 0 ? radius : Radius.zero,
          topRight: radius,
          bottomRight: radius,
        ),
        Paint()..color = regularColor,
      );
    }
  }
}
