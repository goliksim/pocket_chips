// Static Raise Window
import 'package:flutter/material.dart';

import '../../../../data/lobby.dart';
import '../../../../data/uiValues.dart';
import '../../../../internal/gamelogic.dart';

class StaticRaiseButton extends StatefulWidget {
  const StaticRaiseButton({
    required this.newPlayer,
    required this.changeBid,
    required this.tmpBid,
    required this.minBid,
    super.key,
  });
  final Function newPlayer;
  final Function changeBid;
  final int tmpBid;
  final int minBid;

  @override
  StaticRaiseButtonState createState() => StaticRaiseButtonState();
}

class StaticRaiseButtonState extends State<StaticRaiseButton> {
  late int tmpBid;
  late List<int> chips;

  @override
  void initState() {
    super.initState();
    tmpBid = widget.tmpBid;
    /*Future.delayed(const Duration(milliseconds: 0), () {
      widget.changeRaiseButton(tmpBid);
    x});
    */
    chips = getChips(
      thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank - tmpBid,
    );
  }

  List<int> getChips(int maxbank) {
    List<int> tmplist = [1, 5, 10, 25, 50, 100, 500, 1000, 5000, 10000];
    while (true) {
      if (tmplist.last > maxbank) {
        tmplist.removeLast();
        continue;
      }

      return tmplist;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                child: CoinsRow(
                  onTap: (coin) {
                    if (tmpBid + coin <=
                        thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank) {
                      tmpBid += coin;
                      widget.changeBid(tmpBid);
                      setState(() {});
                      //widget.changeRaiseButton(tmpBid);
                    }
                  },
                  chips: chips,
                ),
              ),
            ),
            RaiseSlider(
              minBid: widget.minBid,
              value: tmpBid,
              maxBid: thisGame.maxbid(),
              onChanged: (newValue) {
                tmpBid = newValue;
                widget.changeBid(tmpBid);
                //widget.changeRaiseButton(tmpBid);
                //setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}

//Слайдер с кнопками фишек
class CoinsRow extends StatelessWidget {
  const CoinsRow({super.key, required this.onTap, required this.chips});
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
class RaiseSlider extends StatefulWidget {
  const RaiseSlider({
    super.key,
    required this.minBid,
    required this.value,
    required this.maxBid,
    required this.onChanged,
  });
  final int minBid;
  final int value;
  final int maxBid;
  final Function(int) onChanged;
  @override
  State<RaiseSlider> createState() => _RaiseSliderState();
}

class _RaiseSliderState extends State<RaiseSlider> {
  late int tmpBid;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant RaiseSlider oldWidget) {
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
              '${widget.minBid}',
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
                min: widget.minBid.toDouble(),
                max: widget.maxBid.toDouble(),
              ),
            ),
            SizedBox(width: stdHorizontalOffset / 2),
            Text(
              '${widget.maxBid}',
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
