import 'package:flutter/material.dart';
import 'package:noradio/YT/mainPlayer.dart';

class DynamicSlider extends StatefulWidget {
final MainPlayer player;
// final Video currentVideo;
// final AudioOnlyStreamInfo streamInfo;

const DynamicSlider(this.player, {Key? key}) : super(key: key);
@override
State<StatefulWidget> createState() => _DynamicSliderState();
}

class _DynamicSliderState extends State<DynamicSlider> {
  double currentPosition = 1;

  @override
  void didUpdateWidget(covariant DynamicSlider oldWidget) {
    setState(() {
      currentPosition = 1;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        overlayShape: SliderComponentShape.noOverlay,
      ),
      child: Slider(
          value: listenToSteps(),
          min: 0,
          max: widget.player.getVideoDuration()!.inSeconds.toDouble(),
          onChanged: (value) {
            setState(() {
              currentPosition = value;
            });
          },
          onChangeEnd: (double value) {
            widget.player.playPosition(value.toInt());
          }),
    );
  }

  double listenToSteps() {
    widget.player.getPositionedStream().listen((event) {
      if(currentPosition==event.inSeconds.toDouble()) {
        //skip setstate
      } else {
        setState(() {
          currentPosition = event.inSeconds.toDouble();
        }); }
    });
    return currentPosition;
  }
}